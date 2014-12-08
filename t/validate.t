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

my @err = $swagger->validate;
is_deeply \@err, [], 'petstore.json' or diag Data::Dumper::Dumper(\@err);

$swagger->tree->data->{foo} = 123;
is_deeply [$swagger->validate], ['Properties not allowed: foo.'], 'petstore.json with foo';

done_testing;