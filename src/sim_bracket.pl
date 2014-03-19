#!/usr/bin/env perl
use warnings;
use strict;
###############################################################################
# By Jim Hester
# Created: 2014 Mar 19 08:38:59 AM
# Last Modified: 2014 Mar 19 11:10:30 AM
# Title:sim_bracket.pl
# Purpose:Simulate a NCAA bracket
###############################################################################

my $bracket = shift;
my $teams = shift;
my $ratings = shift;

my @bracket = ();
open my($bracket_in), "<", "$bracket";
while(<$bracket_in>){
  chomp;
  my($first, $second, $final) = split /\t/;
  push @bracket, {home => $first, away => $second, prize => $final};
}

my %teams = ();
open my($teams_in), "<", "$teams";
while(<$teams_in>){
  chomp;
  my($location, $team) = split /\t/;
  $teams{$location} = $team;
}

my %ratings = ();
open my($ratings_in), "<", "$ratings";
while(<$ratings_in>){
  chomp;
  my($team, $rating) = split /\t/;
  $team =~ s/\.//g;
  $ratings{$team}=$rating;
}

for my $game (sort by_round @bracket){

  my $home_team = $teams{$game->{home}};
  my $away_team = $teams{$game->{away}};
  my $winner = choose_winner($home_team, $away_team);
  $teams{$game->{prize}}=$winner;
  print join("\t", $game->{prize}, $winner),"\n";
}

sub by_round {
  my($a_round) = $a->{home} =~ /(\d+)/;
  my($b_round) = $b->{home} =~ /(\d+)/;
  return $b_round <=> $a_round;
}

sub choose_winner {
  my($team1, $team2) = @_;

  #log odds of the pomeroy ratings
  die "No rating for $team1" if not exists $ratings{$team1};
  die "No rating for $team2" if not exists $ratings{$team2};
  my $rating1 = $ratings{$team1};
  my $rating2 = $ratings{$team2};
  my $odds = log($rating2) / (log($rating1) + log($rating2));

  #print "$odds\t";
  if(rand() < $odds){
    return $team1;
  }
  return $team2;
}
