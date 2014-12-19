#!/usr/bin/perl -w
#target : 尝试写一个用以形成词库的分词程序,提高对数据的分析能力
#coding : utf-8
#author : qdladoooo@gmail.com

use utf8;
use encoding "utf-8";

my @ssss = split //, 'MISSHA谜尚水漾亲肤 抚痕唤颜精华素 20ml（超值套装 内赠水漾亲肤水乳中样30ml）';
foreach $_ (@ssss) {
    print $_ . "\n";
}
exit;


use strict;
use warnings;
use DBI;
use Encode;


my $dbh = DBI->connect("DBI:mysql:database=part;host=localhost", "root", '789@#$', {"RaiseError"=>1});
$dbh->do("set names utf8");

my $limit = 0;
my $step = 1000;
my $rowNum;

do {
    #取一条未处理数据
    my $sth = $dbh->prepare("select id,product_name_full from source order by id asc limit $limit, $step;");
    $sth->execute();
    
    $rowNum = 0;
    while(my $ref = $sth->fetchrow_hashref()) {
        $rowNum++;
   
        my $id = $ref->{'id'} . "\n";
        my $str = $ref->{'product_name_full'};
        
        #处理该数据
        $str =~ /([\x80-\xff])/;
        print $str . "\n";

        $1 = encode(decode($1, 'utf-8'), 'utf-8');
        print $1 . "\n";
        exit;
        
        #将数据标志为已处理
        $dbh->do("update source set status = status+1 where id = $id");
    }

    $limit += $step;
} while(0 != $rowNum);

