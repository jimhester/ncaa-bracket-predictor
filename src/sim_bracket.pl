#!/usr/bin/env perl
use warnings;
use strict;
use autodie qw(:all);
###############################################################################
# By Jim Hester
# Created: 2014 Mar 19 08:38:59 AM
# Last Modified: 2014 Mar 19 09:50:48 AM
# Title:sim_bracket.pl
# Purpose:blah
###############################################################################
# Code to handle help menu and man page
###############################################################################
use Getopt::Long;
use Pod::Usage;
my %args = ();
GetOptions(\%args, 'help|?', 'man') or pod2usage(2);
pod2usage(2) if exists $args{help};
pod2usage(-verbose => 2) if exists $args{man};
pod2usage("$0: No files given.")  if ((@ARGV == 0) && (-t STDIN));
###############################################################################
# Automatically extract compressed files
###############################################################################
@ARGV = map { s/(.*\.gz)\s*$/pigz -dc < $1|/; s/(.*\.bz2)\s*$/pbzip2 -dc < $1|/;$_ } @ARGV;
###############################################################################
# sim_bracket.pl
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

###############################################################################
# Help Documentation
###############################################################################

=head1 NAME

sim_bracket.pl - blah

=head1 VERSION

0.0.1

=head1 USAGE

Options:
      -help
      -man               for more info

=head1 OPTIONS

=over

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<sim_bracket.pl> blah

=cut

