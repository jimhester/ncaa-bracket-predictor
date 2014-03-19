#!/usr/bin/env perl
use warnings;
use strict;
###############################################################################
# By Jim Hester
# Created: 2014 Mar 19 09:51:49 AM
# Last Modified: 2014 Mar 19 11:10:00 AM
# Title:parse_brackets.pl
# Purpose:parse brackets from
###############################################################################

my @rounds = qw(64 32 16 8 4 2 1);
my %counts;
my $iterations=0;
while(<>){
  chomp;
  my($game, $team) = split /\t/;


  for my $round(@rounds){
    $counts{$team}{$round}+=0;
  }

  my($round) = $game =~ /(\d+)_/;

  $counts{$team}{$round}++;

  $iterations++ if($round == 1);
}

print join("\t", "Team", @rounds),"\n";
for my $team (reverse sort { $counts{$a}{1} <=> $counts{$b}{1} } keys %counts){
  print $team;
  for my $round (@rounds){
    printf "\t%.2f", $counts{$team}{$round} / $iterations * 100;
  }
  print "\n";
}

sub by_prob {
  $counts{$a}{1} <=> $counts{$b}{1} ||
  $counts{$a}{2} <=> $counts{$b}{2} ||
  $counts{$a}{4} <=> $counts{$b}{4} ||
  $counts{$a}{8} <=> $counts{$b}{8} ||
  $counts{$a}{16} <=> $counts{$b}{16} ||
  $counts{$a}{32} <=> $counts{$b}{32} ||
  $counts{$a}{64} <=> $counts{$b}{64}
}
