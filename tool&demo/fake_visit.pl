#!/usr/perl -w
#使用chrome接口，换ip模拟访问
use strict;
use warnings;
use WWW::Mechanize::GZip;

#可以在此处切换代理 --proxy-server=10.0.0.1:8080
my $cmd = 'start chrome --proxy-server=58.254.201.7:8080 --user-data-dir="c:/for_chrome/cookie_dir_#num#" -user-agent="#UA#" #url# ';


while(1) {
	make_a_visit();
}

sub make_a_visit
{
	#关闭chrome，清空user_data_dir
	#win
	system('taskkill /IM chrome.exe');

	#一个新用户，随机访问若干目标页面;
	my $user_cmd = produce_user($cmd);
	my @url = produce_url();
	my $url = join " ", @url;

	$user_cmd =~ s/#url#/$url/;
	print $user_cmd;
	system($user_cmd);


	sleep(60);
}

#产生一个满足条件的用户
sub produce_user
{
	my $cmd = shift @_;
	my $num = int(rand(100000));
	$cmd =~ s/#num#/$num/;

	#用户代理列表  ie : ff : chrome = 8 : 1 : 1
	my %ua_list = ('ff'=>'Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20100101 Firefox/8.0',  
					 'chrome'=>'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.120 Safari/535.2',
					 'ie'=>'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
					 'ipad'=>'Mozilla/5.0 (iPad; U; CPU OS 3_2_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B500 Safari/531.21.10'
					  );
	my $ua;
	if($num >=0 && $num < 10000) {
		$ua = $ua_list{ff};
	} elsif ($num >= 10000 && $num < 20000) {
		$ua = $ua_list{chrome};
	} elsif ($num>= 20000 && $num < 21000) {
		$ua = $ua_list{ipad};
	} else {
		$ua = $ua_list{ie};
	}

	$cmd =~ s/#UA#/$ua/;

	return $cmd;
}

#产生2-7个满足条件的网址
sub produce_url
{
	my $min = 2;
	my $max = 7;

	#portal
	my $base_url = 'http://www.tudou.com/top/csc27c2705a-1y-1o1p3h0p#page#.html';
	my $page = int(rand(30));
	$page++;
	$base_url =~ s/#page#/$page/;

	#抓取页面，获取网址列表
	my $mech = WWW::Mechanize::GZip->new();
	my $response = $mech->get( $base_url );
	my $content = $response->content;
	die 'response nothing' if !$content;

	my @match = $content =~ /(http:\/\/www.tudou.com\/programs\/view\/[^\/]+\/)/gs;
	#去重
	my %saw;
	undef %saw;
	#网址列表
	my @url = grep(!$saw{$_}++, @match);

	#随机抽取2-7个网址
	return @url if (scalar(@url) <= $max);

	my @chosen_url;
	my $sum = int(rand($max-1));
	$sum += $min;
	while($sum) {
		my $one = int(rand(25));
		if(exists($url[$one])) {
			push @chosen_url, $url[$one];
		}

		$sum -= 1;
	}

	return @chosen_url;
}