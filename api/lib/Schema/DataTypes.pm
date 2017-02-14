package Schema::DataTypes; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'data_types';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'title',
             'description',
             'type_validation'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'title' => {
                         'required' => 1,
                         'allow' => sub { "DUMMY" },
                         'defined' => 1
                       },
            'type_validation' => {
                                   'allow' => sub { "DUMMY" }
                                 },
            'description' => {
                               'allow' => sub { "DUMMY" }
                             },
            'id' => {
                      'defined' => 1,
                      'allow' => qr/^-?\d{1,20}$/x,
                      'required' => 1
                    }
          };

sub CHECKS {return $CHECKS}

__PACKAGE__->QUOTE_IDENTIFIERS(0);
#__PACKAGE__->BUILD;#build accessors during load

1;

=pod

=encoding utf8

=head1 NAME

A class for TABLE data_types in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<data_types> has an accessor method in this class.

=head2 id

=head2 title

=head2 description

=head2 type_validation

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
