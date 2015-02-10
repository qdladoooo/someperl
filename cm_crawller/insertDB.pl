#!/usr/bin/perl -w
use DBI;
use utils;
use URI::Escape;

my $dbh = utils->get_dbh();

open FH, '<./data/addr_location.txt';


my @cm_list;
my $i = 1;
while(<FH>) {
    chomp;
    $_ =~ m/str=(.*)$/;
    my $line = uri_unescape($1);
    
    my @ar = split(',,,', $line);
    $sql = "insert into purple.map_final (id, name, lng, lat, address) values('${ar[0]}', '${ar[1]}', '${ar[3]}', '${ar[4]}', '${ar[5]}')";
    #print $sql . "\n";
    $dbh->do( $sql );

}

close FH;







