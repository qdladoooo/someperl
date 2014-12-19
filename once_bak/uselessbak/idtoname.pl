#!/usr/bin/perl -w
use strict;

open FILE, 'province.txt';
my $line;
my $content = '';
while($line = <FILE>) {
    if($line =~ /(\d+)\s+(\S+)+/g) {
            $content .= "\"$1\":\"$2\",";
    }
}

open RE, '>re.txt';
print RE $content;

close RE;
close FILE;