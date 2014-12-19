#!/usr/bin/perl -w
#target : auto comment in http://wenku.baidu.com
#coding : utf-8
#author : qdladoooo@gmail.com
#Modoule: LWP

use strict;
use LWP;
use HTTP::Cookies;
use Encode;
use Cwd;

my $portal = 'http://wenku.baidu.com';    #入口页面
my $commentPage = 'http://wenku.baidu.com/submit'; #评分页面
my $favType = 'http://wenku.baidu.com/list/557'; #希望评分的列表页面，通过百度文档分类获得，编号对应内容类型
#起始/终止 页面，步长25
my $startPage = 0;
my $endPage = 750;

$| = 1;
my $agent = LWP::UserAgent->new();
autoLogin();

my $greed = 5;

#登陆成功，转入文档列表，抓取文档hash，构造评分请求
my $i;
for($i=$startPage;$i<=$endPage;$i+=25) {
    my $baseList = $favType . '?od=1&pn=' . $i;
    my $response = $agent->get($baseList);
    my $tem = $response->content;

    while ($tem =~ /\/view\/(\w{24})\.html/g) {
        last if ($greed == 0);
        my $flag = comment($1);
        $greed-- if ($flag == 0);
    }
    last if ($greed == 0);
}

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
    $agent->default_header('Cookie' => 'BAIDUID=196E66811A0D51FABBFB193B520F0A9C:FG=1; USERID=4042d84ed805c40a49b05dfab9; J_MY=0; _EXPS=0; BD_UTK_DVT=1; BDUSS=pCNlFFOFFKVkVSb1RhWWRiVGtLUm1FYkFHSzlZZUwwR29yMG5sbzgycE9veDVOQVFBQUFBJCQAAAAAAAAAAAokNyl~ne8AUWRsYWRvb29vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAymV7AAAAAMDKZXsAAAAAuFNCAAAAAAAxMC42NS40NE4W90xOFvdMOE; bannerindex=2; IM_old=0|gh775gue; OPENPLATFORM_SP=7f9d51646c61646f6f6f6fef00_1291266344; BDSP=db24fd9fa4bbf7b3a4bfd50d0ad39bc2');

    #请求自动登录页面
    my $request = HTTP::Request->new(GET=>$portal);
    my $response = $agent->request($request);
    $response->is_success or die "Wrong:", $response->message, "\n";

    #在返回页面中寻找标志登陆成功的信息
    my $dir   =   getcwd();
    my $content = $response->content;
    print $content;
    #$content = encode("utf-8", decode("gb2312", $content));

    if($content =~ /退出<\/a>/) {
        print "login successfully...\n";
    } else {
        print "something may be wrong, check the cookie you sent\n";
    }
}

sub comment
{
    my $fileHash = shift @_;

    #构造自动登录header，伪装为正常访问
    $agent->default_header('Host' => 'wenku.baidu.com');
    $agent->default_header('User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12');
    $agent->default_header('Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
    $agent->default_header('Accept-Language' => "zh-cn,zh;q=0.5");
    $agent->default_header('Accept-Encoding' => "gzip, deflate");
    $agent->default_header('Accept-Charset' => "GB2312,utf-8;q=0.7,*;q=0.7");
    $agent->default_header('Keep-Alive' => '115');
    $agent->default_header('Connection' => 'Keep-Alive');
    $agent->default_header('Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8');
    $agent->default_header('X-Request-By' => 'baidu.ajax');
    $agent->default_header('Referer' => 'http://wenku.baidu.com/view/' . $fileHash . '.html');
    $agent->default_header('Cookie' => 'BAIDUID=8505203480DFF2F00CECBBEAB5106A90:FG=1; USERID=4042d84ed805c40a49b05dfab9; J_MY=1; bdime=1; BDUSS=W9hTVJnSGtwQzNKRElob2VPV093b3pvOU5nLW1XQmp5N3FyTDB2bk5OWWpyeDVOQVFBQUFBJCQAAAAAAAAAAApBESJ~ne8AUWRsYWRvb29vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAWgV3AAAAAMBaBXcAAAAAuFNCAAAAAAAxMC42NS4yNCQi90wjIvdMa; bannerindex=2');
    $agent->default_header('Pragma' => 'no-cache');
    $agent->default_header('Cache-Control' => 'no-cache');

    my $request = HTTP::Request->new(POST=>$commentPage);
    $request->content_type('application/x-www-form-urlencoded');
    $request->content('ct=20009&doc_id=' . $fileHash . '&value_score=3');

    my $response = $agent->request($request);
    $response->is_success or die "Wrong:", $response->message, "\n";
    my $content = $response->content;

    #log
    my $dir   =   getcwd();
    out2file($content, "$dir/brob.log");

    #to be friendly
    print "$fileHash ========== ";
    if($content =~ /status\':\'(\d)/){
        if ($1 == 0){
           print "got it! \n";
        } elsif ($1 == 6){
            print "have comment \n";
        } else {
            print "failed... | code:$1 \n";
        }

        return $1;
    }
}


#输出到文件
sub out2file
{
    my $content = shift @_;
    my $upath = shift @_;
    my $path = "E:\\";      #设置默认目录

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