#!/usr/bin/perl -w
use DBI;
use utils;
use URI::Escape;

my $dbh = utils->get_dbh();
my $sql = "select name, district, address, lng, lat, postcode, city from map2 where lng is not null and address is not null";
my $sth = $dbh->prepare($sql);
$sth->execute();

open OP1, '>./data/cm_info.csv';

while (my @row = $sth->fetchrow_array()) {
    my $line = join('", "', @row);
    print OP1 "\"$line\"\n";
}

$sth->finish();

close OP1;


