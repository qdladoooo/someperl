#!/usr/bin/perl -w
#这是一个简单分发程序，作用是在多机之间同步一个需要反复执行的脚本

use strict;
use warnings;
use LWP;
use Encode;

$| = 1;

while(1) {
	my $agent = LWP::UserAgent->new();
	my $response = $agent->get('此处填写你的外网地址');
	my $cmd = $response->content;
	print $cmd . "\n";
	
	open INPUT, "<run.bat";
	my $old_cmd = <INPUT>;
	$old_cmd = <INPUT>;

	chomp($old_cmd);

	unless ($cmd eq $old_cmd) {
		open FRH, ">run.bat";
		print FRH "title fake_visit\n";
		print FRH $cmd ;
		close FRH;
		
		#杀死所有chrome进程

		#杀死所有脚本进程

		sleep(1);
		system('start run.bat');
	}

	close INPUT;

	sleep(60);
}


