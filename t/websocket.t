use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use File::Spec::Functions;

use Mojolicious::Lite;
plugin Swagger2 => {controller => 't::Api', url => 't/data/petstore.json', websocket => '/stream'};

my $t  = Test::Mojo->new;
my $id = 1;

{
  local $TODO = 'Not yet sure how to handle missing input';
  $t->websocket_ok('/api/stream');
  $t->send_ok({json => {op => 'foo'}})->finish_ok;
}

$t->websocket_ok('/api/stream');

diag 'kit-cat';
$t::Api::RES = [{foo => 123, name => 'kit-cat'}];
$t->send_ok({json => {op => 'listPets', id => ++$id}})->message_ok->json_message_is('/status', 500)
  ->json_message_is('/id', $id)->json_message_is('/body/errors/0/path', '/0/id')
  ->json_message_is('/body/errors/0/message', 'Missing property.', 'Missing property')
  ->json_message_is('/body/errors/1', undef);

$t::Api::RES = [{id => 123, name => 'kit-cat'}];
$t->send_ok({json => {op => 'listPets', id => ++$id}})->message_ok->json_message_is('/status', 200)
  ->json_message_is('/id', $id)->json_message_is('/body/0/id', 123)
  ->json_message_is('/body/0/name', 'kit-cat', 'listPets: kit-cat');

diag 'kit-cat with limit';
$t::Api::RES = [{id => 123, name => 'kit-cat'}];
$t->send_ok({json => {op => 'listPets', query => {limit => 'foo'}, id => ++$id}})
  ->message_ok->json_message_is('/status', 400)->json_message_is('/id', $id)
  ->json_message_is('/body/errors/0/path',    '/limit')
  ->json_message_is('/body/errors/0/message', 'Expected integer - got string.', 'listPets: Expected integer')
  ->json_message_is('/body/errors/1',         undef);

diag 'catwoman';
$t::Api::RES = {name => 'catwoman'};
$t->send_ok({json => {op => 'showPetById', path => {petId => 1940}, id => ++$id}})
  ->message_ok->json_message_is('/status', 200)->json_message_is('/id', $id)->json_message_is('/body/id', 1940)
  ->json_message_is('/body/name', 'catwoman', 'showPetById: catwoman');

$t->send_ok({json => {op => 'showPetById', path => {petId => 'foo'}, id => ++$id}})
  ->message_ok->json_message_is('/status', 400)->json_message_is('/id', $id)
  ->json_message_is('/body/errors/0/path',    '/petId')
  ->json_message_is('/body/errors/0/message', 'Expected integer - got string.', 'showPetById: Expected integer')
  ->json_message_is('/body/errors/1',         undef);

$t->finish_ok;

done_testing;
