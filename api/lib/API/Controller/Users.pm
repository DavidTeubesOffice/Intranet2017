package API::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

our $log = Log::Log4perl->get_logger;

# This action will render a template
sub add {
  my $self = shift;
  my $params = $self->req->json;
  my $where = {};
  my $session_token = "";
  my $errors;
  my @types;
  my $Schema;

   ## params validation
  my $validation = {
    email => ['email', 'required'],
    
  };
  return if $self->livrvalidate($params, undef, $validation);
  
  
  Schema->dbix->commit;

  $log->info("Session-Key: $session_token");
  $self->render( json => {status => 'ok', session_token => $session_token} );
}

sub list {
  my $self = shift;
  my $params = $self->req->json;
  my $where = {};
  my $session_token = "";
  my $errors;
  my @types;
  my $Schema;
  my @Users = ();
  Schema::Users->BUILD;
  Schema::UserData->BUILD;
  Schema::DataAttributes->BUILD;
  Schema::SystemStatuses->BUILD;

   ## params validation
  # my $validation = {
  #   email => ['email', 'required'],
  # };
  # return if $self->livrvalidate($params, undef, $validation);

  ## get User Attributes
  my @UserAttribues = Schema->dbix->select('data_attributes', '*', { attribute_group => 'users' })->hashes;
  $log->debug(Dumper(\@UserAttribues));
  my %a = map { $_->{id} => $_ } @UserAttribues;
  $log->debug(Dumper \%a);

  ## get Users
  my @Users = Schema->dbix->select('users', '*')->hashes;

  for my $i (keys @Users)
  {
    my @UserData = Schema->dbix->select('user_data', '*', { user_id => $Users[$i]->{id} })->hashes;

    for my $j (keys @UserData)
    {
      $UserData[$j]->{attribute_title} = $a{ $UserData[$j]->{attribute_id} }->{attribute_title};
      $UserData[$j]->{attribute_name} = $a{ $UserData[$j]->{attribute_id} }->{attribute_name};
    }

    $Users[$i]->{attributes} = \@UserData;
  }

  $log->debug(Dumper \@Users);
  
  $self->render( json => {status => 'ok', users => \@Users} );
}

1;
