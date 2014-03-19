# NCAA bracket prediction #
Some code to simulate a NCAA bracket.

- Use teams [Pomeroy Ratings](http://kenpom.com/).
- Simulate game outcomes by `rand() < log(rating2)/(log(rating1) + log(rating2))`
- Run X simulations of the bracket (defaults to 1000)

## Example Usage ##
```bash
# Creates tab delimited output file probabilities.tsv
make

# With more simulations
make NUM=10000
```

## Prereqs ##
- perl
- interest in college basketball
