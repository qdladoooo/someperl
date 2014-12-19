#!/usr/bin/perl -w
#使用搜狗词库导出词库（utf8，txt）,转化为词典格式。比较简单，完成后整合

use strict;
use Encode;

open FILE, 'list';

open OUTFILE, '>out.txt';
while(<FILE>) {
	print $_;
#	my $row = encode("gb2312", decode('gb2312', $_));

	my $row = $_;
	chomp $row;
	print OUTFILE $row . "\t1\nx:1\n";
}

close OUTFILE;
close FILE;









