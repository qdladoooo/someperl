#!/usr/bin/perl -w
#ʹ���ѹ��ʿ⵼���ʿ⣨utf8��txt��,ת��Ϊ�ʵ��ʽ���Ƚϼ򵥣���ɺ�����

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









