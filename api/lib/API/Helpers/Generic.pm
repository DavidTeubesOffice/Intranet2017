package API::Helpers::Generic;
use Mojo::Base 'Mojolicious::Plugin';
# use Digest::SHA2;
use Data::Dumper;
use DateTime;
use JSON;
# use Validator::LIVR;

our $log = Log::Log4perl->get_logger;

sub register {
  my ($self, $app) = @_;


  # $app->helper(id_to_guid => sub {
  #   my ($c, @args) = @_;
  #   my $sha2obj = new Digest::SHA2 256;
  #   return unless scalar(@args) == 2;

  #   # $app->log->debug("HashStrings: ". Dumper @args);

  #   $sha2obj->add(@args);
  #   return $sha2obj->hexdigest;
  # });

  # $app->helper('DateTime.object' => sub {
  #   my $c = shift;
  #   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  #   return DateTime->new(
  #     year       => $year+1900,
  #     month      => $mon+1,
  #     day        => $mday,
  #     hour       => $hour,
  #     minute     => $min,
  #     second     => $sec,
  #     time_zone  => 'Africa/Johannesburg'
  #   );
  # });

  # $app->helper('DateTime.now' => sub {
  #   my $c = shift;
  #   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  #   return DateTime->new(
  #     year       => $year+1900,
  #     month      => $mon+1,
  #     day        => $mday,
  #     hour       => $hour,
  #     minute     => $min,
  #     second     => $sec,
  #     time_zone  => 'Africa/Johannesburg'
  #   )->strftime('%F %T');
  # });

}


1;