#!/usr/bin/perl -w
#target : auto comment in http://wenku.baidu.com
#coding : utf-8
#author : qdladoooo@gmail.com

use strict;
use LWP;
use HTTP::Cookies;
use Encode;
use Cwd;

my $portal = 'http://wenku.baidu.com';    #���ҳ��
my $commentPage = 'http://wenku.baidu.com/submit'; #����ҳ��
my $favType = 'http://wenku.baidu.com/list/109'; #ϣ�����ֵ��б�ҳ�棬ͨ���ٶ��ĵ������ã���Ŷ�Ӧ��������
#��ʼ/��ֹ ҳ�棬����25
my $startPage = 0;
my $endPage = 750;

$| = 1;
my $agent = LWP::UserAgent->new();

#���Ե�¼cookie
#autoLogin();

my $greed = 5;
#��½�ɹ���ת���ĵ��б�ץȡ�ĵ�hash��������������
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


##########      ����Ϊ����ĺ���      ##############

sub autoLogin
{
    #�����Զ���¼header��αװΪ��������
    $agent->default_header('Host' => 'wenku.baidu.com');
    $agent->default_header('User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648)');
    $agent->default_header('Accept' => "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*");
    $agent->default_header('Accept-Language' => "zh-cn");
    #$agent->default_header('Accept-Encoding' => "gzip, deflate");
    $agent->default_header('Accept-Charset' => "GB2312,utf-8;q=0.7,*;q=0.7");
    $agent->default_header('Keep-Alive' => '115');
    $agent->default_header('Connection' => 'Keep-Alive');
    $agent->default_header('Referer' => 'http://www.baidu.com/more/');
    $agent->default_header('Cookie' => 'BAIDUID=196E66811A0D51FABBFB193B520F0A9C:FG=1; USERID=4042d84ed805c40a49b05dfab9; J_MY=0; BD_UTK_DVT=1; _ML_HIDE=1_; bdime=1; wenku_home_type=b2xkMTI5NzkwNjg4Mg%3D%3D; BDUSS=XBqVHFqaXQ1RDdicURQWDF1SjgzZkVwQTdTYjhObmFVM3h1QXNWTEhNZjZWNGxOQVFBQUFBJCQAAAAAAAAAAAoX94x~ne8AUWRsYWRvb29vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAmoV5AAAAAMCahXkAAAAAuFNCAAAAAAAxMC4yMy4yNPrKYU36ymFNQ; OPENPLATFORM_SP=7f9d51646c61646f6f6f6fef00_1297992718; bannerindex=2');

    #�����Զ���¼ҳ��
    my $request = HTTP::Request->new(GET=>$portal);
    my $response = $agent->request($request);
    $response->is_success or die "Wrong:", $response->message, "\n";

    #�ڷ���ҳ����Ѱ�ұ�־��½�ɹ�����Ϣ
    my $content = $response->content;
    #$content = encode("utf-8", decode("gb2312", $content));

    if($content =~ /�˳�<\/a>/) {
        print "login successfully...\n";
    } else {
        print "something may be wrong, check the cookie you sent\n";
        exit();
    }
}

sub comment
{
    my $fileHash = shift @_;

    #�����Զ���¼header��αװΪ��������
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
    $agent->default_header('Cookie' => 'BAIDUID=196E66811A0D51FABBFB193B520F0A9C:FG=1; USERID=4042d84ed805c40a49b05dfab9; J_MY=0; BD_UTK_DVT=1; _ML_HIDE=1_; bdime=1; wenku_home_type=b2xkMTI5NzkwNjg4Mg%3D%3D; BDUSS=XBqVHFqaXQ1RDdicURQWDF1SjgzZkVwQTdTYjhObmFVM3h1QXNWTEhNZjZWNGxOQVFBQUFBJCQAAAAAAAAAAAoX94x~ne8AUWRsYWRvb29vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAmoV5AAAAAMCahXkAAAAAuFNCAAAAAAAxMC4yMy4yNPrKYU36ymFNQ; OPENPLATFORM_SP=7f9d51646c61646f6f6f6fef00_1297992718; bannerindex=2');
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


#������ļ�
sub out2file
{
    my $content = shift @_;
    my $upath = shift @_;
    my $path = "E:\\";      #����Ĭ��Ŀ¼

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