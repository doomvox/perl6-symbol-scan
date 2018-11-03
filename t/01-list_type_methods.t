use v6;

use Test;
use Symbol::Scan;

my $a_few_dozen = 24;

my $test_case_1 = "SymbolScan list_core_type_names method";
subtest {
  my @types = SymbolScan.list_core_type_names;
  my $count = @types.elems;  
  cmp-ok($count, '>', $a_few_dozen, "list of core types shows over $a_few_dozen methods: $count");

  my $type = @types[3];
  is( $type.^name, 'Str', "A name should be a Str");
}, $test_case_1;

my $test_case_2 = "SymbolScan list_core_type_objects method";
subtest {
  my @objects = SymbolScan.list_core_type_objects;
  my $count = @objects.elems;  
  cmp-ok($count, '>', $a_few_dozen, "list of core objects shows over $a_few_dozen methods: $count");

  my $object_1 = @objects[3];
  my $object_type_1 = $object_1.^name;
  my $object_2 = @objects[6];
  my $object_type_2 = $object_2.^name;

  ok not( $object_type_1 eq 'Str' && $object_type_2 eq 'Str' ), 
    "List of objects should not all be of type Str";
  
}, $test_case_2;

my $test_case_3 = "SymbolScan list_all_type_names method";
subtest {
      my @types = SymbolScan.list_all_type_names;
      my $count = @types.elems;  
      cmp-ok($count, '>', $a_few_dozen,
             "list of all types shows over $a_few_dozen methods: $count");
      my $type = @types[3];
      is( $type.^name, 'Str', "A name should be a Str");

      # .Str.say for @types;

      my @hits = @types.grep(/^SymbolScan$/);
      is( @hits.elems, 1, "Found the SymbolScan class defined in Symbol::Scan.");

      my @core_types = SymbolScan.list_core_type_names;

      @hits = @core_types.grep(/^SymbolScan$/);
      is( @hits.elems, 0, "Verifying SymbolScan is not in core.");

}, $test_case_3;

done-testing();
