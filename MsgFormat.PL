# -*- perl -*-

use strict;

my $script = <<'SCRIPT';
~startperl~ 

# $Id: MsgFormat.PL,v 1.2 1998/11/18 11:20:50 msh Exp msh $
#
# (C) 1998 Mike Shoyher
#



use Locale::PGetText;
use strict;

use vars qw{$locale_dir $lang %msg $path $s $msgid};

$locale_dir=$ARGV[0];
$lang=$ARGV[1];
my $path="$locale_dir/$lang";
printUsage() unless ($locale_dir && $lang);

dbmopen(%msg,$path,0644) || die "Cannot create database $path";

for (<STDIN>){
  if (/^msgid\s+\"(.*)\"\s*$/){
      if ($msgid) {
          $msgid=~s/\\n/\n/g;
	  $s=~s/\\n/\n/g;
          $s=~s/\\"/"/g;
	  print "MSGID: $msgid\nMSGSTR: $s\n";
	  $msg{$msgid}=$s;
      }
      $s=$1
  }
  if (/^\"(.+)\"\s*$/){
      $s.=$1
  }
  if (/^msgstr\s+\"(.*)\"\s*$/){
      $msgid=$s;
      $s=$1
  }
}

$msgid=~s/\\n/\n/g;
$s=~s/\\n/\n/g;
$s=~s/\\"/"/g;
print "MSGID: $msgid\nMSGSTR: $s\n";
$msg{$msgid}=$s;

dbmclose(%msg);


sub printUsage
{
print "Usage:  MsgFormat <LocaleDir> <Language> < myprog.po\n\n";
exit(100);
}


=head1 NAME

MsgFormat - messages database compiler for PGetText

=head1 SYNOPSIS

  MsgFormat <LocaleDir> <Language> < myprog.po


=head1 DESCRIPTION

MsgFormat creates database in <LocaleDir> directory with messages from <myprog.po> for language <Language>

=head1 SEE ALSO

Locale::PGetText

=cut

SCRIPT


use Config;

my $file = __FILE__; $file =~ s/\.PL$//;

$script =~ s/\~(\w+)\~/$Config{$1}/eg;
if (!(open(FILE, ">$file"))  ||
    !(print FILE $script)  ||
    !(close(FILE))) {
    die "Error while writing $file: $!\n";
}
print "Extracted $file from ",__FILE__," with variable substitutions.\n";

