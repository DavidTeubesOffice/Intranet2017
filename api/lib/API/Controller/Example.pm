package API::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub tests {
  my $self = shift;

  my $att = "users";
  my $params = {
    email => 'test@example.com',
    phone => '2017-01-01',
    # sdfdf => 'sdfsdfsdf_f',
  };

  my $extra = {
    phone => ['date']
  };

  return if $self->livrvalidate($params, $extra, $extra);
  # return if $self->livrvalidate($params, $att);

  # $self->render(text => 'Welcome to the Mojolicious real-time web framework!');
  $self->render(json => {status => 'ok'});
}

1;
