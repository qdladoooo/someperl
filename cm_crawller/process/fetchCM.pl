#!/usr/bin/perl -w
use utils;
use Data::Dumper;

my $page;
for($page = 1 ; $page < 193; $page++) {
    my $url = "http://www.anjuke.com/shanghai/cm/p${page}/";

    fetchCM($url);
}

sub fetchCM {
    my $url = shift;

    #抓取页面
    my $content = utils->fetch_page($url, 'utf-8');
    if( !$content ) {
       utils->log("#####\n${url} fail to fetch\n#####"); 
    }
    
    #获取结构化数据
    $content =~ m/(上海周边.+?<ul class="P3">.+?<\/ul>)/s;
    my $cm_content = $1;
    my @cm_list = $cm_content =~ m/<em><a href="([^"]+)" target="_blank">([^<]+)<\/a><\/em>/sg;
    
    #无结构化数据，退出
    my $count = $#cm_list;
    if( $#cm_list < 2 ) {
        utils->log("#####\n${url} fail to analysis\n#####");
    }

    #小区信息存入文件
    open FILE, '>>output';
    print FILE "#####PAGE${page}\n";

    $flag = 1;
    foreach my $cm_info (@cm_list) {
        print FILE $cm_info;

        if ( ($flag++)%2 == 1) {
            print FILE "\t";
        } else {
            print FILE "\n";
        }
    }

    close FILE;
}



