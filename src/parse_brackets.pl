#!/usr/bin/env perl
use warnings;
use strict;
use autodie qw(:all);
###############################################################################
# By Jim Hester
# Created: 2014 Mar 19 09:51:49 AM
# Last Modified: 2014 Mar 19 10:04:39 AM
# Title:parse_brackets.pl
# Purpose:parse brackets from
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
# parse_brackets.pl
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

###############################################################################
# Help Documentation
###############################################################################

=head1 NAME

parse_brackets.pl - parse brackets from

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

B<parse_brackets.pl> parse brackets from

=cut

