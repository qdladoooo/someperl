#!/usr/bin/perl -w
use DBI;
use utils;
use URI::Escape;

my $dbh = utils->get_dbh();
my $sql = "select distinct name, district, address, lng, lat, postcode, city from map_final where lng is not null and address is not null and address like '上海市%' order by id asc";
my $sth = $dbh->prepare($sql);
$sth->execute();

open OP1, '>./data/cm_info.csv';

while (my @row = $sth->fetchrow_array()) {
    my $line = join('", "', @row);
    print OP1 "\"$line\"\n";
    #print $line . "\n";
}

$sth->finish();

close OP1;


