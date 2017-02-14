package API::Helpers::Validation;
use Mojo::Base 'Mojolicious::Plugin';
use Digest::SHA2;
use Data::Dumper;
use DateTime;
use JSON;
use Validator::LIVR;

our $log = Log::Log4perl->get_logger;

sub register {
  my ($self, $app) = @_;
  # Schema::Modules->BUILD;

  $app->helper(livrvalidate => sub {
    my $c = shift;
    my $params = shift;
    my $attribute_group = shift;
    my $extra_required = shift || {};
    my %validation_rules;
    my $errors = {VALIDATION => 'PARAMS NOT SUPPLIED'};
    my @data;

    $c->render(json => {status => 'fail', error_message => $errors}, status => 404) unless $params;
    return $errors unless $params;

    $log->debug("Validation PARAMS:\n".Dumper $params);
    $log->debug("Validation CLASS:\n".$attribute_group);
    $log->debug("Validation EXTRA REQUIRED:\n".Dumper $extra_required);

    if(defined($attribute_group) and ref($attribute_group) ne "HASH" and ref($attribute_group) ne "ARRAY")
    {
      ### get object namespace
      # Schema->dbix->select('data_objects', 'object_group', {title => $attribute_group})->into(my $object_group);
      # $log->debug("Validation object_group:\n".$object_group);

      # my $attrib_table = "data_attributes";
      $log->debug("Validation attribute_group: $attribute_group");
      foreach my $key (keys %{$params})
      {
        my $attribute = Schema->dbix->select("data_attributes", '*', {attribute_group => $attribute_group, attribute_name => $key})->hash;
        my $ruleset = Schema->dbix->select('data_types', '*', { id => $attribute->{data_type_id} })->hash->{type_validation};
        eval{ $ruleset = decode_json($ruleset); };
        # $log->debug("VALIDATION for '$d->{attribute_name}': ".Dumper $result);
        my @r = map +( $_ ), @{$ruleset};
        $validation_rules{$key} = \@r if ($ruleset or $ruleset ne "");
        push $validation_rules{$key}, 'required';
      }
    }

    if(ref($extra_required) eq "HASH")
    {
      foreach my $key (keys %{$extra_required})
      {
        $validation_rules{$key} = $extra_required->{$key};

        if($key eq "email")
        {
          push $validation_rules{$key}, qw/email to_lc trim/;
        }

      }
    }

    $log->debug("Validation RULES:\n".Dumper \%validation_rules);

    my $validator = Validator::LIVR->new(\%validation_rules);

    ## register custom rules
    $validator->register_rules( 'word' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq ''; 

        return 'NOT WORD' unless $value =~ /^[\w]+$/;
        return;
      }
    } );
    $validator->register_rules( 'phone' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq ''; 

        return 'NOT PHONE' unless $value =~ /^\+?(\d){11}$/;
        return;
      }
    } );
    $validator->register_rules( 'json' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        my $test;
        eval{ decode_json($value); };

        return 'NOT JSON' if $@;
        return;
      }
    } );
    $validator->register_rules( 'date' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        return 'NOT DATE' unless $value =~ /^\d{4}-\d{2}-\d{2}$/;
        return;
      }
    } );
    $validator->register_rules( 'datetime' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        return 'NOT DATETIME' unless $value =~ /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\d{2}$/;
        return;
      }
    } );
    $validator->register_rules( 'time' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        return 'NOT TIME' unless $value =~ /^\d{2}\:\d{2}:\d{2}$/;
        return;
      }
    } );
    $validator->register_rules( 'password' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        my $ok = 1;
        $ok = 0 unless $value =~ /[A-Za-z]/;
        # $ok = 0 unless $value =~ /[0-9]/;
        # $ok = 0 unless $value =~ /[^\w]/;

        return 'PASSWORD COMPLEXITY' unless $ok == 1;
        return;
      }
    } );
    $validator->register_rules( 'printable' =>  sub {
      return sub {
        my $value = shift;

        # We already have "required" rule to check that the value is present
        return if !defined($value) || $value eq '';

        return 'NOT PRINTABLE CHARACTER' if $value !~ /^[[:print:]]+$/;
        return;
      }
    } );

    if ( $validator->validate($params) ) {
      return;
    } else {
       $errors = $validator->get_errors();
       $log->error("Validation Errors: ".Dumper $errors);
    }

    $c->render(json => {status => 'fail', error_message => $errors}, status => 404);
    return $errors;
  });

  # $app->helper('livrvalidate_OLD' => sub {
  #   # my ($c, $attribute_class, $params, @types) = @_;
  #   my ($c, $attribute_class, $params, @extra) = @_;
  #   my %validation_rules = map { $_ => 'required' } keys %{$params};
  #   my $errors;
  #   my @data;
  #   $log->debug("Validation PARAMS:\n".Dumper $params);
  #   $log->debug("Validation TYPES:\n".Dumper \@extra);
  #   $log->debug("Validation RULES:\n".Dumper \%validation_rules);

  #   # for my $field (@extra)
  #   # {
  #   #   my $result = Schema->dbix->select('data_types', '*', {title => $field})->hash->{type_validation};
  #   #   # $log->debug("TYPE $field:".$result);
  #   #   return "INVALID DATA_TYPE: $field" unless $result;
  #   #   eval{ $result = decode_json($result); };
  #   #   unless($@)
  #   #   {
  #   #     # return {error => "CHECK VALIDATION RULES FOR $field"} unless ref($result) eq "ARRAY";
  #   #     my @rules = map +( $_ ), @{$result};
  #   #     push @rules, 'required';
  #   #     $validation_rules{$field} = \@rules;
  #   #   }
  #   # }

  #   if(defined($attribute_class))
  #   {
  #     # $log->debug("Getting validation for CLASS: $attribute_class");
  #     Schema->dbix->select('modules', 'object_group', {title => $attribute_class})->into(my $attribute_group);

  #     my $attrib_table = $attribute_group."_attributes";
  #     # $log->debug("Getting rules from table: $attrib_table");
  #     @data = Schema->dbix->select("$attrib_table", '*')->hashes;
  #     # $log->debug(qq{RULES for "$attribute_class": }.Dumper(\@data));
  #     for my $d (@data)
  #     {
  #       my @rules;

  #       # $log->debug("GET RULES FOR '$d->{attribute_name}'");
  #       ## get rules for attribute
  #       my $result = Schema->dbix->select('data_types', '*', {id => $d->{data_type_id}})->hash->{type_validation};
  #       eval{ $result = decode_json($result); };
  #       # $log->debug("VALIDATION for '$d->{attribute_name}': ".Dumper $result);
  #       @rules = map +( $_ ), @{$result};

  #       ## add "required" if field is required
  #       push @rules, 'required' if $d->{required} == 1;
        
  #       ## only add rules that are defined and not empty
  #       # $validation_rules{$d->{attribute_name}} = $result if ($result or $result ne "");
  #       $validation_rules{$d->{attribute_name}} = \@rules if ($result or $result ne "");
  #     }
  #   }

  #   # $log->debug("Validation RULES:\n".Dumper \%validation_rules);
  #   my $validator = Validator::LIVR->new(\%validation_rules);

  #   ## register custom rules
  #   $validator->register_rules( 'word' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq ''; 

  #       return 'NOT WORD' unless $value =~ /^[\w]$/;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'phone' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq ''; 

  #       return 'NOT PHONE' unless $value =~ /^\+?(\d){11}$/;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'json' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       my $test;
  #       eval{ decode_json($value); };

  #       return 'NOT PROPERLY FORMATTED JSON' if $@;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'date' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       return 'NOT A DATE' unless $value =~ /^\d{4}-\d{2}-\d{2}$/;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'datetime' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       return 'NOT A DATETIME' unless $value =~ /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\d{2}$/;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'time' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       return 'NOT A DATETIME' unless $value =~ /^\d{2}\:\d{2}:\d{2}$/;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'password' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       my $ok = 1;
  #       $ok = 0 unless $value =~ /[A-Za-z]/;
  #       # $ok = 0 unless $value =~ /[0-9]/;
  #       # $ok = 0 unless $value =~ /[^\w]/;

  #       return 'PASSWORD COMPLEXITY' unless $ok == 1;
  #       return;
  #     }
  #   } );
  #   $validator->register_rules( 'printable' =>  sub {
  #     return sub {
  #       my $value = shift;

  #       # We already have "required" rule to check that the value is present
  #       return if !defined($value) || $value eq '';

  #       return 'NOT PRINTABLE CHARACTER' if $value !~ /^[[:print:]]+$/;
  #       return;
  #     }
  #   } );

  #   if ( $validator->validate($params) ) {
  #     return;
  #   } else {
  #      $errors = $validator->get_errors();
  #      $log->error("Validation Errors: ".Dumper $errors);
  #   }

  #   $c->render(json => {status => 'fail', error_message => $errors}, status => 404);
  #   return $errors;
  # });
}


1;