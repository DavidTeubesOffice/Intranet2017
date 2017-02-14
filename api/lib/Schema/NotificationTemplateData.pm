package Schema::NotificationTemplateData; #A table/row class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(Schema);

sub is_base_class{return 0}
my $TABLE_NAME = 'notification_template_data';

sub TABLE {return $TABLE_NAME}
sub PRIMARY_KEY{return 'id'}
my $COLUMNS = [
             'id',
             'dbdate_created',
             'attribute_value',
             'attribute_id',
             'notification_template_id'
           ];

sub COLUMNS {return $COLUMNS}
my $ALIASES = {};

sub ALIASES {return $ALIASES}
my $CHECKS = {
            'notification_template_id' => {
                                            'defined' => 1,
                                            'required' => 1,
                                            'allow' => qr/^-?\d{1,20}$/x
                                          },
            'attribute_value' => {
                                   'allow' => sub { "DUMMY" }
                                 },
            'id' => {
                      'defined' => 1,
                      'required' => 1,
                      'allow' => qr/^-?\d{1,20}$/x
                    },
            'dbdate_created' => {
                                  'default' => 'CURRENT_TIMESTAMP',
                                  'defined' => 1,
                                  'required' => 1
                                },
            'attribute_id' => {
                                'allow' => qr/^-?\d{1,20}$/x,
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

A class for TABLE notification_template_data in schema db_Intranet2017

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 COLUMNS

Each column from table C<notification_template_data> has an accessor method in this class.

=head2 id

=head2 dbdate_created

=head2 attribute_value

=head2 attribute_id

=head2 notification_template_id

=head1 ALIASES

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>

=head1 SEE ALSO
L<Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple::Class::Schema>

=head1 AUTHOR

david

=cut
