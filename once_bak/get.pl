#!/usr/bin/perl -w
use strict;
use LWP;
use Cwd;
use Encode;
$| = 1;
my $dir   =   getcwd();


my $agentN = LWP::UserAgent->new();
my $requestN = HTTP::Request->new(GET=>'http://search.51job.com/job/43848219,c.html');
my $responseN = $agentN->request($requestN);
$responseN->is_success or die "Wrong:", $responseN->message, "\n";

my $contentN = $responseN->content;



if($contentN =~ /<td colspan="6" class="txt_4 wordBreakNormal job_detail">(.+)<\/td>/g)  {
    my $edu = print $1;
}

#my $str = "$poname******$workarea******$num******$workyear******$lang******$edu";

#out2file($str .  "\n\n\n", "$dir/daoru10.txt");





#输出到文件
sub out2file
{
    my $content = shift @_;
    my $upath = shift @_;
    my $path = "C:\\";      #设置默认目录

    if($upath) {
        open FH, ">>$upath";
        print FH $content . "\n";
        close FH;
    } else {
        #pc机时间
        my $ymd = qx(date /T);
        my @ymd = split(" ", $ymd);
        my $hms = qx(time /T);
        $hms = substr($hms, 0, 5);
        $hms =~ s/(\s*):(\s*)/$1-$2/;
        $path = $path . $ymd[0] . "_" . $hms . "_" . int(1000000*rand()) . ".html";

        #写入文件
        open FH, ">$path";
        print FH $content;
        close FH;
    }
}