package Schema::UserModulePrivileges; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'user_module_privileges';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'user_id',
             'module_id',
             'c',
             'r',
             'u',
             'd'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'user_id' => {
                           'defined' => 1,
                           'required' => 1,
                           'allow' => qr/^-?\d{1,20}$/x
                         },
            'module_id' => {
                             'defined' => 1,
                             'allow' => qr/^-?\d{1,20}$/x,
                             'required' => 1
                           },
            'r' => {
                     'required' => 1,
                     'allow' => qr/^-?\d{1,1}$/x,
                     'defined' => 1
                   },
            'c' => {
                     'allow' => qr/^-?\d{1,1}$/x,
                     'required' => 1,
                     'defined' => 1
                   },
            'id' => {
                      'required' => 1,
                      'allow' => qr/^-?\d{1,20}$/x,
                      'defined' => 1
                    },
            'u' => {
                     'defined' => 1,
                     'required' => 1,
                     'allow' => qr/^-?\d{1,1}$/x
                   },
            'd' => {
                     'allow' => qr/^-?\d{1,1}$/x,
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

A class for TABLE user_module_privileges in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<user_module_privileges> has an accessor method in this class.

=head2 id

=head2 user_id

=head2 module_id

=head2 c

=head2 r

=head2 u

=head2 d

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
