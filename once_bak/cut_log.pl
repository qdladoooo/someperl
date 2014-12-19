#!/usr/bin/perl -w

($sec, $min, $hour, $mday, $mon, $year) = localtime();
my $current_time = sprintf("%04d%02d%02d_%02d%02d%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);

#your log path and location where ftp can reach
my $log_path = '/var/log/stat.access.log';
my $log_for_analysis = '/home/liyaohui/ws/' . $current_time;
my $op_move = 'mv ' . $log_path . ' ' . $log_for_analysis;

system($op_move);
system "kill -HUP `cat /var/run/httpd.pid`";
