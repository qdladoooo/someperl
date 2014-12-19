#!/usr/bin/perl -w
my $path = "D:\\www\\src\\trunk\\enterprise\\application\\models";

open LOG, '>C:\\log';
opendir DBD, $path;


while (readdir DBD) {
    next if /^\./;
    print LOG $_;
    open DBF, $path .  "\\" . $_;
    
    while($line = <DBF>) {
        if($line =~ /^\s*(public|private)?\s*function([^)]+\))/) {
            print LOG "\n\t" . $2;
        }

        if($line =~ /new\s+Application_Model/) {
            $line =~ s/^\s//;
            chomp($line);
            print LOG "\n\t\t" . $line;
        }
    }
    
    print LOG "\n";
    close(DBF);
}


closedir DBD;
close LOG;