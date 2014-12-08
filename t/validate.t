BEGIN {
  use File::Spec;
  $ENV{SWAGGER2_CACHE_DIR} = File::Spec->catdir(qw( t data cache ));
}

use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use File::Spec::Functions 'catfile';
use Swagger2;

my $json_file = catfile qw( t data petstore.json );
my $swagger   = Swagger2->new($json_file);

plan skip_all => "Cannot read $json_file"           unless -r $json_file;
plan skip_all => "Cannot read $Swagger2::SPEC_FILE" unless -r $Swagger2::SPEC_FILE;

my $res = $swagger->validate;
is_deeply $res, [], 'petstore.json' or diag Data::Dumper::Dumper($res);

$swagger->tree->data->{foo} = 123;
is_deeply $swagger->validate, [], 'petstore.json with foo';

done_testing;
