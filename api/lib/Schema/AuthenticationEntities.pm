package Schema::AuthenticationEntities; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'authentication_entities';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'identifier',
             'secret',
             'dbdate_created',
             'data_type_id',
             'system_status_id',
             'is_super'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'id' => {
                      'allow' => qr/^-?\d{1,20}$/x,
                      'required' => 1,
                      'defined' => 1
                    },
            'system_status_id' => {
                                    'defined' => 1,
                                    'allow' => qr/^-?\d{1,20}$/x,
                                    'required' => 1
                                  },
            'is_super' => {
                            'allow' => qr/^-?\d{1,1}$/x,
                            'required' => 1,
                            'defined' => 1
                          },
            'dbdate_created' => {
                                  'defined' => 1,
                                  'default' => 'CURRENT_TIMESTAMP',
                                  'required' => 1
                                },
            'data_type_id' => {
                                'defined' => 1,
                                'required' => 1,
                                'allow' => qr/^-?\d{1,20}$/x
                              },
            'identifier' => {
                              'defined' => 1,
                              'required' => 1,
                              'allow' => sub { "DUMMY" }
                            },
            'secret' => {
                          'allow' => sub { "DUMMY" },
                          'required' => 1,
                          'defined' => 1
                        }
          };

sub CHECKS {return $CHECKS}

__PACKAGE__->QUOTE_IDENTIFIERS(0);
#__PACKAGE__->BUILD;#build accessors during load

1;

=pod

=encoding utf8

=head1 NAME

A class for TABLE authentication_entities in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<authentication_entities> has an accessor method in this class.

=head2 id

=head2 identifier

=head2 secret

=head2 dbdate_created

=head2 data_type_id

=head2 system_status_id

=head2 is_super

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
