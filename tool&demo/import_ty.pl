#!/usr/bin/perl -w
#天涯数据入库
use strict;
use warnings;
use DBI;
use Encode;

my $dbh = DBI->connect("DBI:mysql:database=tianya;host=localhost", "root", '789@#$', {"RaiseError"=>1});
$dbh->do("set names utf8");


for(1..50) {
    my $file = "tianya_$_.txt";
    
    open FILE,"<./data/$file";
    while(<FILE>) {
        my $account = encode('utf-8', decode('gb2312', $_));
        my @row = split('\s+', $account);
        my $name = quotemeta($row[0]);
        my $pw = quotemeta($row[1]);

        my $sql = "insert into user values('', '$name', '$pw')"; 
        $dbh->do($sql);

        print $name . "\t\t\t";
        print $pw . "\n";

        #sleep(1);
    }

    close FILE;
}




