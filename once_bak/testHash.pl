#!/usr/bin/perl -w
use strict;



my $str = '{# ����������
@  ; }
{#  =   {   \}  \} ;ע������Ҳ�и����� 
ҲҪƥ���ȥ��  }';

$str =~ s/\\}/##########/gs;

  while($str =~ /({#([^}])*})/sg ) {
        my $str2 = $1;
        $str2 =~ s/##########/\\}/gs;
        print $str2 . "\n";
  } 



=cut
my @wife = ('������', '������', '��ɯ', 'pwd', 'ssl_agent');
print $wife[0];



my %son = ('first','����ı');
print $son{'first'};

