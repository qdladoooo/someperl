#!/usr/bin/perl -w
use DBI;
use utils;

my $dbh = utils->get_dbh();
my $sql = "select name,lng,lat from map2 where lng is not null";
my $sth = $dbh->prepare($sql);
$sth->execute();

open OP1, '>./data/name.txt';
open OP2, '>./data/location.txt';

while (my @row = $sth->fetchrow_array()) {
    my ($name, $lng, $lat) = @row;
    print OP1 "'$name', \n";
    print OP2 "new BMap.Point($lng, $lat), \n";
    print $name, $lng, $lat , "\n";
}

$sth->finish();


close OP2;
close OP1;


