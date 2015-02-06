#!/usr/bin/perl -w
use DBI;
use utils;
use Data::Dumper;

my @name = ("浦东","闵行","徐汇","普陀","长宁","静安","黄浦","卢湾","虹口","闸北","杨浦","宝山","松江","嘉定","青浦","奉贤","金山","崇明","上海周边");
my @href = ("http://www.anjuke.com/shanghai/cm/pudong/","http://www.anjuke.com/shanghai/cm/minhang/","http://www.anjuke.com/shanghai/cm/xuhui/","http://www.anjuke.com/shanghai/cm/putuo/","http://www.anjuke.com/shanghai/cm/changning/","http://www.anjuke.com/shanghai/cm/jingan/","http://www.anjuke.com/shanghai/cm/huangpu/","http://www.anjuke.com/shanghai/cm/luwan/","http://www.anjuke.com/shanghai/cm/hongkou/","http://www.anjuke.com/shanghai/cm/zhabei/","http://www.anjuke.com/shanghai/cm/yangpu/","http://www.anjuke.com/shanghai/cm/baoshan/","http://www.anjuke.com/shanghai/cm/songjiang/","http://www.anjuke.com/shanghai/cm/jiading/","http://www.anjuke.com/shanghai/cm/qingpu/","http://www.anjuke.com/shanghai/cm/fengxian/","http://www.anjuke.com/shanghai/cm/jinshan/","http://www.anjuke.com/shanghai/cm/chongming/","http://www.anjuke.com/shangha
i/cm/shanghaizhoubian/");

my $i;
my $count = $#name;
for($i=0; $i<=$count; $i++) {
    $district = $name[$i];
    $district_href = $href[$i];

    my $page;
    for($page = 1 ; $page < 193; $page++) {
        my $url = $district_href . "p${page}/";
        fetchCM($url, $page, $district);
    }
}

sub fetchCM {
    my $url = shift;
    my $page = shift;
    my $district = shift;

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
    print FILE "#####PAGE${page}#####${district}\n";

    my $dbh = utils->get_dbh();
    my $url;
    my $name;
    $flag = 1;
    foreach my $cm_info (@cm_list) {
        print FILE $cm_info;

        if ( ($flag++)%2 == 1) {
            $url = $cm_info;
            print FILE "\t";
        } else {
            $name = $cm_info;
            print FILE "\n";
        
            my $sql = "insert into purple.map value('', '${name}', '${district}', '${url}');";
            print $sql . "\n";
            $dbh->do( $sql );
        }
         
    }

    close FILE;

    return true;
}



