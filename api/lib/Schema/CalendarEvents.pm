package Schema::CalendarEvents; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'calendar_events';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'system_status_id',
             'dbdate_created'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'id' => {
                      'required' => 1,
                      'allow' => qr/^-?\d{1,20}$/x,
                      'defined' => 1
                    },
            'dbdate_created' => {
                                  'required' => 1,
                                  'default' => 'CURRENT_TIMESTAMP',
                                  'defined' => 1
                                },
            'system_status_id' => {
                                    'required' => 1,
                                    'allow' => qr/^-?\d{1,20}$/x,
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

A class for TABLE calendar_events in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<calendar_events> has an accessor method in this class.

=head2 id

=head2 system_status_id

=head2 dbdate_created

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
