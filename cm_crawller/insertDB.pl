#!/usr/bin/perl -w
use DBI;
use utils;

my $dbh = utils->get_dbh();

open FH, '<cm_location.txt';


my @cm_list;
my $i = 1;
while(<FH>) {
    chomp;
    $line = $_;
    $line =~ m/(\d+####)?(.+)$/;
    next if($line eq '');

    my @ar = split('####', $2);

    if ($ar[1] =~ m/^F/) {

    } else {
    	#print $ar[0] . "\t" . $ar[2] . "\t" . $ar[3] . "\n";
        $sql = "insert into purple.communtity (id, name, lng, lat) values('', '${ar[0]}', '${ar[2]}', '${ar[3]}')";
        print $sql . "\n";

    }
}

close FH;







