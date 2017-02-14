package Schema::SystemStatuses; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'system_statuses';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'title',
             'description',
             'system_group'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'description' => {
                               'allow' => sub { "DUMMY" }
                             },
            'id' => {
                      'allow' => qr/^-?\d{1,20}$/x,
                      'required' => 1,
                      'defined' => 1
                    },
            'title' => {
                         'allow' => sub { "DUMMY" },
                         'required' => 1,
                         'defined' => 1
                       },
            'system_group' => {
                                'required' => 1,
                                'allow' => sub { "DUMMY" },
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

A class for TABLE system_statuses in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<system_statuses> has an accessor method in this class.

=head2 id

=head2 title

=head2 description

=head2 system_group

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
