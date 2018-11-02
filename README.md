NAME
====

Symbol::Scan - list types or classes currently in use

SYNOPSIS
========

    use Symbol::Scan;
    my @type_names    = SymbolScan.list_core_type_names;
    my @type_objects  = SymbolScan.list_core_type_objects;

DESCRIPTION
===========

The SymbolScan class provides a number of methods that list things currently defined for your perl6-- types or classes, either just for CORE:: or including the user defined ones, in the form of either objects or names (or pairs of both):

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

These two act to filter a given sequence of pairs (they're primarily for internal use):

    list_type_pairs
    list_class_pairs

SEE ALSO
========

This module is essentially a repackaging of a solution by "smis", posted to stackoverflow:

    https://stackoverflow.com/questions/44861432/is-there-a-way-to-get-a-list-of-all-known-types-in-a-perl-6-program

Brandon Allerby offers an opinion as to why trapping errors from gratuitous *.gist calls can improve reliability:

    https://www.mail-archive.com/perl6-users@perl.org/msg06266.html

NOTES
=====

motivation
----------

This is needed for the Augment::Util recompose_core routine which in turn is needed to cover for a bug in using augment.

implementation
--------------

There are 12 main entry-point methods that cover all permutations of these three choices:

    what we list:     'type',  'class'
    scope we search:  'core',  'all'
    form we report:   'objects', 'names', 'pairs',

A few more options might justify a different interface where you expicitly set options on the SymbolScan object. 

AUTHOR
======

Joseph Brenner, doomvox@gmail.com

COPYRIGHT AND LICENSE
=====================

Copyright (C) 2018 by Joseph Brenner

Released under "The Artistic License 2.0".
