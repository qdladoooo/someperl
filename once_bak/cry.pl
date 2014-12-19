#!/usr/bin/perl -w
use strict;


open FILE, 'ku.txt';

my $sum = 0;
while(<FILE>) {
	$sum += $_;
}

print $sum;
close FILE;