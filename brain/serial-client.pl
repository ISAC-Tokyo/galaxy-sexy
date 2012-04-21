		#!/usr/bin/perl

use strict;
use LWP::UserAgent;
use UUID::Random;

my $comport = "/dev/ttyS6";
my $posturl = 'http://sushi.yuiseki.net:4444/brain';
my $userid ;

my $ua = new LWP::UserAgent;

$posturl = $ARGV[0] || $posturl;


my $DEBUG=0;

$userid = getusername();

open(FH, "<", $comport) or die("cannot open ", $comport);


while(<FH>)
{
  if(/ERROR/){ next; }
  my $line = $_;

  chop $line; 
  my $postdata = sprintf("%ld,%s,%s", time(), $userid, $line);

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






sub
getusername
{
  my $file_username = ".serial-client.username";
  my $username;

  if(-f $file_username)
  {
    open(FH, $file_username) or die($file_username);
    my @content = <FH>;
    close(FH);
    return join('', @content);
  }
  else{
    my $uuid = UUID::Random::generate;
    print "my new userid: $uuid\n" ;
    open(FH, ">" . $file_username) or die($file_username);
    print FH $uuid;
    close(FH);
	return $uuid;
  }
}


