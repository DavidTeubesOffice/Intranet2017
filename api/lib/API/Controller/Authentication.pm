package API::Controller::Authentication;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

our $log = Log::Log4perl->get_logger;

# This action will render a template
sub authenticate {
  my $self = shift;
  my $params = $self->req->json;
  my $where = {};
  my $session_token = "";
  my $errors;
  my @types;
  my $Schema;
  Schema::Users->BUILD;
  Schema::AuthenticationEntities->BUILD;
  Schema::AuthenticationSessions->BUILD;
  Schema::UserAuthenticationEntities->BUILD;
  # push @types, ('test_key');

  ## params validation
  my $validation = {
    identifier => ['email', 'required'],
    secret => ['password', 'required'],
  };
  return if $self->livrvalidate($params, undef, $validation);

  ## validate login
  # $self->model('user')->login($params);
  # return $self->render( json => {status => 'fail', 'error_message' => 'TEST'}, status => 200 );

  $where = {
    identifier => $params->{identifier},
    secret => { '=' => \['SHA2(?, 512)', $params->{secret}] }
  };
  $Schema = Schema->dbix->select('authentication_entities', 'id', $where);
  # $log->warn(Dumper $Schema->{st}->{sth}->{ParamValues});
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Login'}, status => 401 ) unless $Schema->rows == 1;
  $Schema->into(my ($authentication_entity_id));

  $Schema = Schema->dbix->select('user_authentication_entities', 'user_id', {authentication_entity_id => $authentication_entity_id});
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Login'}, status => 401 ) unless $Schema->rows == 1;
  $Schema->into(my $user_id);

  $Schema = Schema->dbix->select('users', '*', {id => $user_id});
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Login'}, status => 401 ) unless $Schema->rows == 1;
  my $Users = $Schema->hash;
  $log->debug(Dumper $Users);

  ## check status of user
  ## todo: improve check - check status with SQL, not with perl == ID
  Schema->dbix->select('system_statuses', 'id', {title => 'user_active', system_group => 'users'})->into(my $user_active);
  unless($Users->{system_status_id} == $user_active)
  {
    return $self->render( json => {status => 'fail', 'error_message' => 'User not active'}, status => 404 );
  }

  $where = {
    authentication_entity_id => $authentication_entity_id,
    dbdate_modified => { '>=' => \['date_sub(now(), interval ? minute)', 60] }
  };
  $Schema = Schema->dbix->select('authentication_sessions', '*', $where)->object('Schema::AuthenticationSessions');
  if(my $AuthenticationSessions = $Schema->data)
  {
    $session_token = $AuthenticationSessions->{session_token};
    $Schema->dbdate_modified( $self->now(time_zone => 'local')->strftime('%F %T') )->update;
  }
  else
  {
    do
    {
      $session_token = $self->random_string(length => 128);
    }while(Schema->dbix->select('authentication_sessions', 'id', {session_token => $session_token})->rows > 0);

    $log->debug("CREATING NEW SESSION ($session_token)");
    my $test = Schema->dbix->insert('authentication_sessions', {
      session_token => "$session_token",
      dbdate_modified => $self->now(time_zone => 'local')->strftime('%F %T'),
      authentication_entity_id => $authentication_entity_id,
    });
    $log->debug("last_insert_id: ".Dumper(Schema->dbix->last_insert_id(undef, undef, undef, undef)));
  }
  
  Schema->dbix->commit;

  $log->info("Session-Key: $session_token");
  $self->render( json => {status => 'ok', session_token => $session_token} );
}

sub authenticate_session {
  my $self = shift;
  my $session_token = $self->req->headers->header('Session-Token');
  my $where = {};
  my $errors;
  my @types;
  my $Schema;
  Schema::AuthenticationSessions->BUILD;

  $log->debug(Dumper $session_token);

  ## params validation
  my $validation = {
    session_token => ['printable', 'required']
  };
  return if $self->livrvalidate({session_token => $session_token}, undef, $validation);

  $where = {
    session_token => $session_token,
    dbdate_modified => { ">=" => $self->now(time_zone => 'local')->subtract(minutes => 60)->strftime('%F %T') }
  };
  $Schema = Schema->dbix->select('authentication_sessions', '*', $where);
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Session'}, status => 401 ) unless $Schema->rows == 1;
  my $AuthenticationSessions = $Schema->object('Schema::AuthenticationSessions');
  my $authentication_entity_id = $AuthenticationSessions->data->{authentication_entity_id};

  $Schema = Schema->dbix->select('user_authentication_entities', 'user_id', {authentication_entity_id => $authentication_entity_id});
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid User'}, status => 401 ) unless $Schema->rows == 1;
  $Schema->into(my $user_id);

  $Schema = Schema->dbix->select('users', '*', {id => $user_id});
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Login'}, status => 401 ) unless $Schema->rows == 1;
  my $Users = $Schema->hash;

  ## check status of user
  ## todo: improve check - check status with SQL, not with perl == ID
  Schema->dbix->select('system_statuses', 'id', {title => 'user_active', system_group => 'users'})
    ->into(my $user_active);
  unless($Users->{system_status_id} == $user_active)
  {
    return $self->render( json => {status => 'fail', 'error_message' => 'User not active'}, status => 404 );
  }

  ## update session
  $AuthenticationSessions->dbdate_modified( $self->now(time_zone => 'local')
    ->strftime('%F %T') )
    ->update;

  Schema->dbix->commit;

  $self->render( json => {status => 'ok'} );
}

sub verify_new_user {
  my $self = shift;
  my $params = {
    verification_key => $self->param('key')
  };
  my $where = {};
  my $errors;
  my $Schema;
  Schema::Users->BUILD;
  Schema::AuthenticationSessions->BUILD;
  Schema::AuthenticationEntities->BUILD;
  $log->info("API::Controller::Authentication::verify_new_user\nParams: ".Dumper($params));

  my @types = map +( $_ ), keys $params;
  $log->debug(Dumper \@types);
  return if $self->livrvalidate(undef, $params);
  # $Schema = Schema->dbix->select();

  ## CHECK FOR verification_key
  my $UserData = Schema->dbix->select('user_data', '*', {
    attribute_id => { "=" => \["(select id from user_attributes where attribute_name=?)", 'verification_key'] },
    attribute_value => $self->param('key'),
    dbdate_created => { ">=" => \["date_sub(now(), interval ? day)", 1] },
  });
  return $self->render( json => {status => 'fail', 'error_message' => 'Invalid Activation Code'}, status => 404 ) unless $UserData->rows == 1;
  $UserData = $UserData->hash;

  ## CHECK IF user already verified
  return $self->render( json => {status => 'fail', 'error_message' => 'Account Already Activated'}, status => 404 )
    if Schema->dbix->select('users', '*', {
      id => $UserData->{parent_id},
      system_status_id => Schema->dbix->select('system_statuses', 'id', {title => 'user_active'})->hash->{id}
    })
      ->rows > 0;

  Schema->dbix->select('authentication_entities', '*', {
    id => { "=" => \["(select authentication_entity_id from user_authentication_entities where user_id=?)", $UserData->{parent_id}] },
  })
    ->object('Schema::AuthenticationEntities')
    ->system_status_id( Schema->dbix->select('system_statuses', 'id', {title => 'authentication_verified'})->hash->{id} )
    ->update;
  
  Schema->dbix->select('users', '*', {
    id => $UserData->{parent_id}
  })
    ->object('Schema::Users')
    ->system_status_id( Schema->dbix->select('system_statuses', 'id', {title => 'user_active'})->hash->{id} )
    ->update;

  Schema->dbix->commit;

  $self->render( json => {status => 'ok', error_message => ''} );
}

1;
