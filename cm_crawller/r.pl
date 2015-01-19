#!/usr/bin/perl -w

open FH, '<input.txt';

my @cm_list;
while(<FH>) {
    chomp $_;
    if(m/^http/) {
        my @ar = split("\t", $_);
        push(@cm_list, $ar[1]);
    }
}


close FH;

open FH, '>output.txt';
print FH join("', '", @cm_list);
close FH;

