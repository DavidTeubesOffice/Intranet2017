use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t = Test::Mojo->new('API');

$t->post_ok('/authenticate' => json => { identifier => 'test@example.com', secret => 'test' })
->status_is(200)
->json_like('/session_token' => qr/^[A-Za-z0-9]{128}$/);

my $session_token = $t->tx->res->json->{session_token};

$t->get_ok('/users/list' => { 'Session-Token' => $session_token } )
->status_is(200)
->json_has('/status' => 'ok')
->json_has('/users');

# $t->get_ok('/users/tests' => { 'Session-Token' => $session_token })
# ->status_is(200)
# ->json_has('/status' => 'ok');

done_testing();