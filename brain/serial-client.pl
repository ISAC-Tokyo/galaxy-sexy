#!/usr/bin/perl

use strict;
use LWP::UserAgent;

my $comport = "/dev/ttyS6";
my $posturl = 'http://sushi.yuiseki.net:4444/brain';

my $ua = new LWP::UserAgent;

$posturl = $ARGV[0] || $posturl;


my $DEBUG=0;

open(FH, "<", $comport) or die("cannot open ", $comport);


while(<FH>)
{
  if(/ERROR/){ next; }
  my $line = $_;

  chop $line; 
  my $postdata = sprintf("%ld,%s", time(), $line);

  my $req = new HTTP::Request(POST => $posturl);
  $req->content_type("text/csv");
  $req->content($postdata);

  print $postdata,"\n";

  my $res = $ua->request($req);
  
  if($res->is_success){
    print $res->code, " - ", $res->content if $DEBUG
  }
  else{
    print STDERR "error: ", $res->code, "\n";
  }
}

