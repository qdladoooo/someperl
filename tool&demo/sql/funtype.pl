#!/usr/bin/perl -w
use strict;
use Encode;
use DBI;

my $dbh = DBI->connect("DBI:mysql:database=dald;host=localhost", "root", '789@#$', {"RaiseError"=>1});
$dbh->do("set names utf8");

open FH, "tem.txt";
my $content;
my $line;
my $name;
my $jobId;
my $str = '';
while($line = <FH>) {
    if($line =~ /(\d+)\'\]=\'([^\']+)/g) {
            $name =  $2;
            #print $name . "\n";
            $name = encode("utf-8", decode("gb2312",  $name));
            $jobId = $1;

            if(index($str, "++$name++") == -1) {
                $str .= '++' . $name . '++';
                #$dbh->do("update base_positions set 51job_id= $jobId where name='$name'");
            } else {
                $name = encode("gb2312", decode("utf-8",  $name));
                print $jobId . "\t" . $name . "\n";
            }
    }
}
close FH;

=cut
my $sth = $dbh->prepare("select * from base_positions");
$sth->execute();

my $content;
my $line;
while(my $ref = $sth->fetchrow_hashref()) {
    $line = $ref->{'position_id'} . "\t" . $ref->{'original_id'} . "\t" . $ref->{'name'} . "\n";
    #$line = encode("utf-8", decode("gb2312",  $line));
    $content .= $line;
}
=cut


open LOG, ">lala.txt";
print LOG $str;
close LOG;
