#!/usr/bin/perl -w

#target : 尝试写一个分词程序用以形成词库，加深对数据的理解
#coding : utf-8
#author : qdladoooo@gmail.com

use strict;
use DBI;

my $dbh = DBI->connect("DBI:mysql:database=test;host=localhost", "root", '789@#$', {"RaiseError"=>1});
$dbh->do("set names utf8");

my $sth = $dbh->prepare("select * from goods limit 10;");
$sth->execute();

my $ref = $sth->fetchrow_hashref();

print $ref->{'id'};


=cut
while(my $ref = $sth->fetchrow_hashref()) {
    $line = $ref->{'position_id'} . "\t" . $ref->{'original_id'} . "\t" . $ref->{'name'} . "\n";
    #$line = encode("utf-8", decode("gb2312",  $line));
    $content .= $line;
}