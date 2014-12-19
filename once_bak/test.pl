#!/usr/bin/perl -w
use Encode;
use strict;
use Cwd;



my $content = "<p>中华人民共和国万岁！！1</p><p>5656565!!!@@</p>";
my $dir   =   getcwd();
while($content =~ /(<p>\S+<\/p>)/g) {
    print $1;
    out2file($1 . "\n", "$dir/haqian.log");
}


=cut
use   Cwd;
my   $dir   =   getcwd();
print "$dir\n";
my $portal = 'http://wenku.baidu.com';    #入口页面
my $agent = LWP::UserAgent->new();
my $content = autoLogin()->content;

$content = encode("utf-8" ,decode("gb2312", $content));

my $content = "find $&" if($content =~ /[^<]*退出<\/a>/);

out2file($content, "c:\\someperl\\test.txt");

#$str = "伟大的祖国他超有钱呐";
#print "find" if($str =~ /大/);
#out2file($str . "\n", "c:\\someperl\\test.txt");
#out2file(chr(0x263a) . "\n", "c:\\someperl\\test.txt");

sub autoLogin
{
    #构造自动登录header，伪装为正常访问
    $agent->default_header('Host' => 'wenku.baidu.com');
    $agent->default_header('User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12');
    $agent->default_header('Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
    $agent->default_header('Accept-Language' => "zh-cn,zh;q=0.5");
    $agent->default_header('Accept-Encoding' => "gzip, deflate");
    $agent->default_header('Accept-Charset' => "GB2312,utf-8;q=0.7,*;q=0.7");
    $agent->default_header('Keep-Alive' => '115');
    $agent->default_header('Connection' => 'Keep-Alive');
    $agent->default_header('Referer' => 'http://www.baidu.com/more/');
    $agent->default_header('Cookie' => 'BAIDUID=196E66811A0D51FABBFB193B520F0A9C:FG=1; USERID=4042d84ed805c40a49b05dfab9; J_MY=0; BDUSS=1WTE95Rlg3RGVnTXZPVDh2Rm9FWHpYQ0pKME5uZ2lmQ1JvTHl3eVpYODlsUGxNQVFBQUFBJCQAAAAAAAAAAAokNyl~ne8AUWRsYWRvb29vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAymV7AAAAAMDKZXsAAAAAuFNCAAAAAAAxMC42NS4yND0H0kw9B9JMVW');

    #请求自动登录页面
    my $request = HTTP::Request->new(GET=>$portal);
    my $response = $agent->request($request);
    $response->is_success or die "Wrong:", $response->message, "\n";

    return $response;
    #todo:在返回页面中寻找标志登陆成功的信息
}















=cut
#输出到文件
sub out2file
{
    my $content = shift @_;
    my $upath = shift @_;
    my $path = "E:\\";      #设置默认目录

    if($upath) {
        open FH, ">>$upath";
        print FH $content;
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