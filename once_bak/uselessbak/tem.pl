#!/usr/bin/perl -w
use strict;

open FILE, 'fortem.txt';
my $line;
my $content = '';
while($line = <FILE>) {
    chomp $line;
    if($line ne '') {
        $content .= '\'' . $line . '\'' . ',' . "\n";
    }
}

open RE, '>temr.txt';
print RE $content;

close RE;
close FILE;


