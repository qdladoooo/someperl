#!/usr/bin/perl -w
use strict;
use LWP;
use Cwd;
use Encode;
$| = 1;
my $dir   =   getcwd();

my $agent = LWP::UserAgent->new();
my $request = HTTP::Request->new(GET=>'http://search.51job.com/list/co,c,206270,0000,10,1.html');
my $response = $agent->request($request);
$response->is_success or die "Wrong:", $response->message, "\n";

my $content;
$content = $response->content;

while ($content =~ /<a href="([^"]+)" class="blue" target="_blank">/g)  {
    print $1 . "\n";
    
    ss($1);
}













sub ss
{
    my $url = shift @_;
    
    my $poname;
    my $pubdate;
    my $workarea;
    my $num;
    my $workyear;
    my $lang;
    my $edu;
    my $desc;


    my $agentN = LWP::UserAgent->new();
    my $requestN = HTTP::Request->new(GET=>$url);
    my $responseN = $agentN->request($requestN);
    $responseN->is_success or die "Wrong:", $responseN->message, "\n";

    my $contentN = $responseN->content;

    if($contentN =~ /<td class="sr_bt" colspan="2" >([^>]+)<\/td>/g)  {
        $poname = $1;
    }

    if($contentN =~ /�������ڣ�<\/td><td class="txt_2">([^>]+)<\/td>/g)  {
        $pubdate =  $1;
    }

    if($contentN =~ /�����ص㣺<\/td><td class="txt_2">([^>]+)<\/td>/g)  {
        $workarea = $1;
    }

    if($contentN =~ /��Ƹ������<\/td><td class="txt_2">([^>]+)<\/td>/g)  {
        $num = $1;
    }

    if($contentN =~ /�������ޣ�<\/td><td class="txt_2">([^>]+)<\/td>/g)  {
        $workyear =  $1;
    }

    if($contentN =~ /����Ҫ��<\/td><td class="txt_2">([^>]+)<\/td>/g)  {
        $lang = $1;
    }

    if($contentN =~ /ѧ&nbsp;&nbsp;&nbsp;&nbsp;����<\/td><td class="txt_2">(\S+)<\/td>/g)  {
        $edu = $1;
    }

    if($contentN =~ /<td colspan="6" class="txt_4 wordBreakNormal job_detail">(.+)<\/td>/g)  {
        $desc = $1;
    }

    my $str = "$poname******$workarea******$num******$workyear******$lang******$edu\n";
    $str .= "====================================================\n";
    $str .= $desc;

    out2file($str .  "\n\n\n\n\n", "$dir/daoru5533.txt");
}


#������ļ�
sub out2file
{
    my $content = shift @_;
    my $upath = shift @_;
    my $path = "C:\\";      #����Ĭ��Ŀ¼

    if($upath) {
        open FH, ">>$upath";
        print FH $content . "\n";
        close FH;
    } else {
        #pc��ʱ��
        my $ymd = qx(date /T);
        my @ymd = split(" ", $ymd);
        my $hms = qx(time /T);
        $hms = substr($hms, 0, 5);
        $hms =~ s/(\s*):(\s*)/$1-$2/;
        $path = $path . $ymd[0] . "_" . $hms . "_" . int(1000000*rand()) . ".html";

        #д���ļ�
        open FH, ">$path";
        print FH $content;
        close FH;
    }
}