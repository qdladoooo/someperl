#!/usr/bin/perl -w
use strict;



my $str = '{# ￥…………
@  ; }
{#  =   {   \}  \} ;注意这里也有个括号 
也要匹配进去。  }';

$str =~ s/\\}/##########/gs;

  while($str =~ /({#([^}])*})/sg ) {
        my $str2 = $1;
        $str2 =~ s/##########/\\}/gs;
        print $str2 . "\n";
  } 



=cut
my @wife = ('梁静茹', '萧亚轩', '金莎', 'pwd', 'ssl_agent');
print $wife[0];



my %son = ('first','孙仲谋');
print $son{'first'};

