#!/usr/bin/perl -w
use DBI;
use utils;
use URI::Escape;


my $dbh = utils->get_dbh();
open INP, '<./data/addr.txt';

while(<INP>) {
    chomp;
    m/str=([^\s]+) HTTP/gs;
    my $line = uri_unescape($1) . "\n";
    my ($name, $addr) = split(',,,,,', $line);
    $addr =~ s/(\s+)$//;
    $addr =~ s/上海市上海市/上海市/;

    print $name , $addr . "\n";

    next if($name eq '');
    $sql = "update map2 set address = '$addr' where name = '$name'";
    $dbh->do($sql);
}

close INP;

=cut
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


