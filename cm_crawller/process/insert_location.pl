#!/usr/bin/perl -w
use DBI;
use utils;

my $dbh = utils->get_dbh();
open FILE, '<./data/A_done.txt';
while(<FILE>) {
    chomp;
    my @line = split("\t", $_);
    $sql = "update map2 set lng='$line[1]', lat='$line[2]' where name = '$line[0]'";
    #print $sql . "\n";
    $dbh->do($sql);
}

close FILE;

