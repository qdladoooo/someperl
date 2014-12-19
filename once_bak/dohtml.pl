#!/usr/bin/perl -w
use strict;

open FILE, 'html.txt';
my $line;
my $content = '';
my $id = 1;
while($line = <FILE>) {
    if($line =~ /^\s+$/) {
            
    } elsif ($line =~ /<option value="(\d+)">([^<]+)<\/option>/g) {
            $content  .= '<li id="serial_wild_' . $id . '" aid="' . $1 . '"><span>' . $2 . '</span></li>' . "\n";
            $id++;
    } else {
            $content .= $line;
    }
}

open RE, '>re.txt';
print RE $content;

close RE;
close FILE;