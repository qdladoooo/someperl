#!/usr/local/bin/perl   
use threads;   

@domain   =   ("tom.com",   "chinadns.com",   "163.com",   "aol.com");   
for ($i=0;$i<4;$i++)
{   
    print   $i.'.'.$domain[$i].'     ';   
}   
print   "\n";   
    
my   $thr0   =   threads->new(\&checkwhois,   '0',   $domain[0]);   
my   $thr1   =   threads->new(\&checkwhois,   '1',   $domain[1]);   
my   $thr2   =   threads->new(\&checkwhois,   '2',   $domain[2]);   
my   $thr3   =   threads->new(\&checkwhois,   '3',   $domain[3]);   
    
sub   checkwhois()   
{   
    my ($l,$r)=@_;   
    my $i=0;   
    while($i<1000000)   
    {   
          $i*$i;   
          $i++;   
    }   
    print   "done  --$l\t\n";   
    print   $l.$r."   query   successful!   \n";    
}

$thr0->join;  
$thr1->join;   
$thr2->join;   
$thr3->join;
