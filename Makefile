NUM=10

REPS=$(shell seq -t'\n' -s' ' -f'brackets/%g.bracket' 1 $(NUM))

all: probabilities.tsv

probabilities.tsv: $(REPS)
	src/parse_brackets.pl $? > $@

%.bracket :
	src/sim_bracket.pl data/bracket data/teams data/ratings > $@

clean:
	rm -f brackets/*.bracket probabilities.tsv
