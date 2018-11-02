class SymbolScan {
    # groups of pseudo-packages we scan to find defined symbols
    my $core := CORE::;
    my $all  := (|CORE::, |UNIT::, |OUTERS::, |MY::);

    method list_type_pairs( $src ) {
        my %seen;
        my @pairs = gather for  |$src  -> $pair {  # e.g. ( |CORE:: )
            try {
                my $key    = $pair.key;
                my $object = $pair.value;
                next if %seen{ $key };
                %seen{ $key } = 1;
                # calling gist because experience shows it helps filter 
                # weird objects (like NQP?) throwing a trappable error
                my $whatever = $object.gist; 
                my $object_name = $object.^name;
                if $key eq $object_name { # if so, this is a type
                    take $pair;
                }
                # trap any errors and skip to next pair
                CATCH { default {
                              # say .Str; # TODO turn on with a verbose flag?
                                } }
            }
        }
        return @pairs;  
    }

    method list_core_type_pairs {
        my @pairs =self.list_type_pairs( $core );
        return @pairs;
    }

    method list_all_type_pairs {
        my @pairs =self.list_type_pairs( $all );
        return @pairs;
    }

    method list_core_type_names {
        return self.list_core_type_pairs().map(*.key);
    }

    method list_core_type_objects {
        return self.list_core_type_pairs().map(*.value);
    }

    method list_all_type_names {
        return self.list_all_type_pairs().map(*.key);
    }

    method list_all_type_objects {
        return self.list_all_type_pairs().map(*.value);
    }

    method list_class_pairs( $src ) {
        my %seen;
        my @pairs = gather for  |$src  -> $pair {  # e.g. ( |CORE:: )
            try {
                my $key    = $pair.key;
                my $object = $pair.value;
                next if %seen{ $key };
                %seen{ $key } = 1;
                # calling gist because experience shows it helps filter 
                # weird objects (like NQP?) throwing a trappable error
                my $whatever = $object.gist; 
                my $object_name = $object.^name;
                if $key eq $object_name { # if so, this is a type...
                    if $object.HOW.^name eq 'Perl6::Metamodel::ClassHOW'  { # ... and a class
                        take $pair;                    
                    }
                }
                # trap any errors and skip to next pair
                CATCH { default {
                              # .Str.say  # TODO why n.g.?
                                } }
            }
        }
        return @pairs;  
    }

    method list_core_class_pairs {
        my @pairs =self.list_class_pairs( $core );
        return @pairs;
    }

    method list_all_class_pairs {
        my @pairs =self.list_class_pairs( $all );
        return @pairs;
    }

    method list_core_class_names {
        return self.list_core_class_pairs().map(*.key);
    }

    method list_core_class_objects {
        return self.list_core_class_pairs().map(*.value);
    }

    method list_all_class_names {
        return self.list_all_class_pairs().map(*.key);
    }

    method list_all_class_objects {
        return self.list_all_class_pairs().map(*.value);
    }
}


=begin pod

=head1 NAME

Symbol::Scan - list types or classes currently in use

=head1 SYNOPSIS

   use Symbol::Scan;
   my @type_names    = SymbolScan.list_core_type_names;
   my @type_objects  = SymbolScan.list_core_type_objects;

=head1 DESCRIPTION

The SymbolScan class provides a number of methods that 
list things currently defined for your perl6-- types or classes,
either just for CORE:: or including the user defined ones, in
the form of either objects or names (or pairs of both):

    list_core_type_pairs 
    list_all_type_pairs 
    list_core_type_names 
    list_core_type_objects 
    list_all_type_names 
    list_all_type_objects 
    list_core_class_pairs 
    list_all_class_pairs 
    list_core_class_names 
    list_core_class_objects 
    list_all_class_names 
    list_all_class_objects 

These two act to filter a given sequence of pairs (they're
primarily for internal use):

    list_type_pairs
    list_class_pairs

=head1 SEE ALSO

This module is essentially a repackaging of a solution by
"smis", posted to stackoverflow:

  https://stackoverflow.com/questions/44861432/is-there-a-way-to-get-a-list-of-all-known-types-in-a-perl-6-program


Brandon Allerby offers an opinion as to why trapping errors from
gratuitous *.gist calls can improve reliability:

  https://www.mail-archive.com/perl6-users@perl.org/msg06266.html


=head1 NOTES

=head2 motivation

This is needed for the Augment::Util recompose_core routine which
in turn is needed to cover for a bug in using augment.

=head2 implementation

There are 12 main entry-point methods that cover all permutations
of these three choices:

   what we list:     'type',  'class'
   scope we search:  'core',  'all'
   form we report:   'objects', 'names', 'pairs',

A few more options might justify a different interface where you
expicitly set options on the SymbolScan object.    

=head1 AUTHOR

Joseph Brenner, doomvox@gmail.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2018 by Joseph Brenner

Released under "The Artistic License 2.0".

=end pod
