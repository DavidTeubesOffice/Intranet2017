package Schema; #The schema/base class
use 5.010001;
use strict;
use warnings;
use utf8;
use parent qw(DBIx::Simple::Class);

our $VERSION = '0.01';
sub is_base_class{return 1}
sub dbix {

  # Singleton DBIx::Simple instance
  state $DBIx;
  return ($_[1] ? ($DBIx = $_[1]) : $DBIx)
    || Carp::croak('DBIx::Simple is not instantiated. Please first do '
      . $_[0]
      . '->dbix(DBIx::Simple->connect($DSN,$u,$p,{...})');
}

1;


=pod

=encoding utf8

=head1 NAME

Schema - the base schema class.

=head1 DESCRIPTION

This is the base class for using table records as plain Perl objects.
The subclassses are:

=over

=item L<Schema::AuthenticationEntities> - A class for TABLE authentication_entities in schema db_Intranet2017

=item L<Schema::AuthenticationSessions> - A class for TABLE authentication_sessions in schema db_Intranet2017

=item L<Schema::CalendarEventData> - A class for TABLE calendar_event_data in schema db_Intranet2017

=item L<Schema::CalendarEvents> - A class for TABLE calendar_events in schema db_Intranet2017

=item L<Schema::DataAttributes> - A class for TABLE data_attributes in schema db_Intranet2017

=item L<Schema::DataTypes> - A class for TABLE data_types in schema db_Intranet2017

=item L<Schema::ModuleData> - A class for TABLE module_data in schema db_Intranet2017

=item L<Schema::ModuleGroups> - A class for TABLE module_groups in schema db_Intranet2017

=item L<Schema::Modules> - A class for TABLE modules in schema db_Intranet2017

=item L<Schema::NotificationTemplateData> - A class for TABLE notification_template_data in schema db_Intranet2017

=item L<Schema::NotificationTemplates> - A class for TABLE notification_templates in schema db_Intranet2017

=item L<Schema::SystemSettings> - A class for TABLE system_settings in schema db_Intranet2017

=item L<Schema::SystemStatuses> - A class for TABLE system_statuses in schema db_Intranet2017

=item L<Schema::UserAuthenticationEntities> - A class for TABLE user_authentication_entities in schema db_Intranet2017

=item L<Schema::UserData> - A class for TABLE user_data in schema db_Intranet2017

=item L<Schema::UserModulePrivileges> - A class for TABLE user_module_privileges in schema db_Intranet2017

=item L<Schema::Users> - A class for TABLE users in schema db_Intranet2017

=back

=head1 GENERATOR

L<DBIx::Simple::Class::Schema>


=head1 SEE ALSO


L<DBIx::Simple::Class::Schema>, L<DBIx::Simple::Class>, L<DBIx::Simple>, L<Mojolicious::Plugin::DSC>

=head1 AUTHOR

david

=cut
