package Swagger2::DSL;

=head1 NAME

Swagger2::DSL - Write swagger spec in perl

=head1 DESCRIPTION

L<Swagger2::DSL> is a module for writing Swagger specification with Perl syntax
instead of JSON or YAML.

=head1 SYNOPSIS

  package MyApp::API;
  use Swagger2::DSL;

  # these can be fetched from POD in the current file
  title       "Swagger2 petstore";
  description "This is an example specification";
  contact     "Jan Henning Thorsen", "http://thorsen.pm";
  license     "Artistic License version 2.0", "http://opensource.org/licenses/Artistic-2.0";

  # define version of specification
  our $VERSION = "1.0";

  # other swagger information
  schemes   "http";
  host      "demo.convos.by";
  base_path "/1.0";
  terms     "Some terms of service";

  # defines a global parameter
  param query => limit => sub {
    INTEGER("int32");
    required;
    description "How many items to return at one time (max 100)";
  };

  # define responses
  def Pet => sub {
    required "id", "name";
    return id => INTEGER("int64"), name => STRING(), tag => STRING();
  };

  # this is automatically defined
  def Error => sub {
    required "message", "path";
    return ARRAY({message => STRING(), path STRING()});
  };

  # define a resource
  resource "/pets" => sub {
    namespace "YourApp::Controller";

    get "pets#listPets" => sub {
      summary "finds pets in the system";
      param "query", "limit"; # use the global parameter

      res 200 => sub {
        description "pet response";
        header "x-expires" => STRING();
        schema ARRAY(def "Pet");
      };
      res default => sub {
        description "unexpected error";
        schema def "Error";
      };
    };

    post "pets#addPet" => sub {
      summary "add pets to the system";

      # will throw an error if another "body" param is defined
      param body => data => sub {
        schema OBJECT({name => STRING(), tag => STRING()});
        required;
      };

      # successful response
      res 200 => sub {
        description "pet response";
        header "x-expires" => STRING();
        schema def "Pet";
      };

      # this is automatically defined unless overridden
      res default => sub {
        description "unexpected error";
        schema def "Error";
      };
    };

    # nested under /pets
    resource "/:petId" => sub {
      post "pets#showPetById" => sub {
        summary "Info for a specific pet";

        # will throw an error if "petId" is not defined
        parameter path => petId => sub {
          INTEGER;
          required;
          description "The id of the pet to receive";
        };

        # successful response
        res 200 => sub {
          description "Expected response to a valid request";
          schema def "Pet";
        };

        # this is automatically defined unless overridden
        res default => sub {
          description "unexpected error";
          schema def "Error";
        };
      };
    };
  };

  compile;

=cut

use Mojo::Base -strict;
use Exporter 'import';

=head1 FUNCTIONS

=head2 title

=cut

sub title {
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014, Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
