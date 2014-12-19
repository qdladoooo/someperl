#!/usr/bin/perl -w

#生产者消费者模式
#消费者插入更新操作需要线程互斥，再写下去就复杂了，效率也没有保障，决定先回头写php版本


use strict;
use warnings;
use Encode;
use DBI;
use threads;
use threads::shared;
use Thread::Queue;

$| = 1;

#队列
my $q = Thread::Queue->new();
#生产者
my $a = threads->create(\&produce_name, '');
#单词处理
while(1) {
    if(threads->list() > 10) {
        foreach(threads->list(threads::joinable)) {
           $_->join();
        }
    } else {
        threads->create(\&process_char, '');
    }
}

#取出产品名插入队列
sub produce_name
{
    my $limit = 0;
    my $step = 1000;
    while(1) {
        if($q->pending() < 1500) {
            my $dbh = DBI->connect("DBI:mysql:database=part;host=localhost", "root", '789@#$', {"RaiseError"=>1});
            $dbh->do("set names utf8");

            my $sth = $dbh->prepare("select product_name_full as name from test.source_product_for_mapping order by id asc limit $limit, $step;");
            $sth->execute();
            
            last unless $sth;

            my @infoList;
            while(my $ref = $sth->fetchrow_hashref()) {
                push @infoList, $ref->{'name'};
            }

            $q->enqueue(@infoList);

            $limit += $step;
        } else {
            sleep(1);
        }
    }
}

sub stat_char
{
    my $char = shift @_;
    my $offset = shift @_;
    my $length = shift @_;

    if($char =~ /^\s+$/) {
        return 0;
    }

    my $dbh_g = DBI->connect("DBI:mysql:database=part;host=localhost", "root", '789@#$', {"RaiseError"=>1});
    $dbh_g->do("set names utf8");
    
    my $sth = $dbh_g->prepare("select id from dictionary where meta = '$char'");
    $sth->execute();
 
    if( $sth->fetchrow_hashref() ) {    
        #更新数据
        $dbh_g->do("update dictionary set count = count+1, $offset=$offset+1 where meta = '$char'");
    } else {
        #插入数据
        $dbh_g->do("insert dictionary values('', '$char', 1, 0, 0, 0, $length)");
    }
}


sub process_char
{
    my $str = $q->dequeue();
    $str = decode('utf8', $str);
    my @word =  split //, $str;

    my $pre = shift @word;
    stat_char($pre, 'l', '1');

    foreach $_ (@word) {
        stat_char($_, 'l', '1');
        stat_char($pre . $_, 'l', '2');

        $pre = $_;
    }
}
