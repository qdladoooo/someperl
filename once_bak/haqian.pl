#!/usr/bin/perl -w
use strict;
use LWP;
use Cwd;
use Encode;
$| = 1;

my $start = 1;
my $end = 3;
for (my $i=$start; $i<=$end; $i++) {
    getHQ($i);
}

sub getHQ
{
    my $page = shift @_;

    my $dir   =   getcwd();
    my $agent = LWP::UserAgent->new();
    my $request = HTTP::Request->new(GET=>'http://www.dapenti.com/blog/blog.asp?name=xilei&subjectid=137&page=' . $page);
    my $response = $agent->request($request);
    $response->is_success or die "Wrong:", $response->message, "\n";

    my $content;
    $content = $response->content;
    $content = encode("utf-8", decode("gb2312", $content));
    
    my $pageDesc = "第{$page}页\n";
    $pageDesc = encode("utf-8", decode("gb2312",  $pageDesc));
    out2file($pageDesc, "$dir/today.txt");
    while($content =~ /oblog_text>\s+<P>(\S+)<\/P>/g) {
        out2file($1 . "\n", "$dir/today.txt");
    }
    out2file("=================================================", "$dir/today.txt");
}


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