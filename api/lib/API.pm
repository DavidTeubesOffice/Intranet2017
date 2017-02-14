package API;
use Mojo::Base 'Mojolicious';
use MojoX::Log::Log4perl;
use Data::Dumper;

# This method will run once at server start
sub startup {
  my $self = shift;
  
  my $CONFIG = $self->plugin( 'config' => {file => 'api.conf'} );
  $self->mode($CONFIG->{mode});
  $self->log( MojoX::Log::Log4perl->new( $CONFIG->{log_config} ) );
  my $log = Log::Log4perl->get_logger;
  $self->plugin('DSC', $CONFIG->{database}->{DSC});
  # $self->plugin('database', $CONFIG->{database}->{db});
  $self->plugin('Util::RandomString');
  # $self->plugin('API::Helpers::Generic');
  $self->plugin('API::Helpers::Validation');
  $self->plugin('DateTime', time_zone => 'local');
  $self->plugin('mail', $CONFIG->{mail});
  $self->plugin('Model');
  # Documentation browser under "/perldoc"
  # $self->plugin('PODRenderer');

  ## handle errors & Exceptions
  $self->hook(before_render => sub {
    my ($c, $args) = @_;

    # $args->{format} = 'json';

    # Make sure we are rendering the exception template
    return unless my $template = $args->{template};
    return unless $template eq 'exception';

    $args->{json} = {status => 'fail', error_message => 'Server Error'};
    # Switch to JSON rendering if content negotiation allows it
    # $args->{json} = {exception => $args->{exception}} if $c->accepts('json');
  });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  # $r->get('/tests')->to('example#tests');

  $r->post('/authenticate')->to('Authentication#authenticate');
  $r->any('/authenticate_session')->to('Authentication#authenticate_session');

  my $auth = $r->under('/users')->to('Authentication#authenticate_session');
  $auth->get('/list')->to('Users#list');

  # $auth->get('/tests')->to('example#tests');
}

1;
