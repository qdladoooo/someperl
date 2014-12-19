#!/usr/bin/perl -w
use strict;

open FILE, "input.txt";
my $str = "";
while(<FILE>) {
    if($_ ne "\n") { 
        $str .= $_ ;
    }
}
close FILE;

open IN, ">output.txt";
print IN $str;
close IN;