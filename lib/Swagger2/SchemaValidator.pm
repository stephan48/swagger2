package Swagger2::SchemaValidator;

=head1 NAME

Swagger2::SchemaValidator - DEPRECATED

=head1 DESCRIPTION

L<Swagger2::SchemaValidator> has been replaced by the generic validator
L<JSON::Validator>.

=cut

use Mojo::Base 'JSON::Validator';

my $WARNED = 0;
warn 'This module is replaced by JSON::Validator.' unless $WARNED++;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014-2015, Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
