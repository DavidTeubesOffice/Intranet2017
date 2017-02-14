package Schema::Users; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'users';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'deleted',
             'dbdate_created',
             'system_status_id'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'deleted' => {
                           'allow' => qr/^-?\d{1,1}$/x
                         },
            'dbdate_created' => {
                                  'defined' => 1,
                                  'default' => 'CURRENT_TIMESTAMP',
                                  'required' => 1
                                },
            'system_status_id' => {
                                    'allow' => qr/^-?\d{1,20}$/x,
                                    'required' => 1,
                                    'defined' => 1
                                  },
            'id' => {
                      'defined' => 1,
                      'required' => 1,
                      'allow' => qr/^-?\d{1,20}$/x
                    }
          };

sub CHECKS {return $CHECKS}

__PACKAGE__->QUOTE_IDENTIFIERS(0);
#__PACKAGE__->BUILD;#build accessors during load

1;

=pod

=encoding utf8

=head1 NAME

A class for TABLE users in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<users> has an accessor method in this class.

=head2 id

=head2 deleted

=head2 dbdate_created

=head2 system_status_id

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
