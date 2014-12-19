#!/usr/bin/perl -w
use strict;
use warnings;
use Bloom::Filter;

my $filter = Bloom::Filter->new(capacity => 10000, error_rate => 0.0001);
$filter->add( 'shine_2@163.com' );


print $filter->check('qdladoooo@gmail.com') . "\n";
print $filter->check('shine_2@163.com') . "\n";    
print $filter->key_count() . "\n";   



$filter->add( 'qdladoooo@gmail.com' );

print $filter->check('qdladoooo@gmail.com') . "\n";
print $filter->check('shine_2@163.com') . "\n";    
print $filter->key_count() . "\n";   
