# Wordle Solver

[Wordle](https://www.powerlanguage.co.uk/wordle/) is all the rage, but as my co-workers will attest to, I suck at it. So I built a solver!

### Setup

```bash
git clone https://github.com/yasyf/wordle-solver.git
cd wordle-solver

bundle install
./wordle_solver.rb
```

### Usage

The solver is fully interactive. Simply run it and go!

You'll be presented with a word, which you should enter into the first row of the Wordle UI.

```bash
   Iteration  1
Search Space  176070
       Board  [?] [?] [?] [?] [?]
        Word  WHICH
```
You'll then be asked to tell the solver which color each cell in that row turns (`E` for empty, `Y` for yellow, or `G` for green). The default is `E`.

```bash
Enter the word, and let me know the color of each block!

1. W [e, y, g] (e)
2. H [e, y, g] (e)
3. I [e, y, g] (e) G
4. C [e, y, g] (e)
5. H [e, y, g] (e)
```

Based on your inputs, you'll be presented with a new word, which you should enter into the next row, and repeat! Each subsequent row will remember the color you last assigned it.


### Demo

[![asciicast](https://asciinema.org/a/gjjIhfVORcWd1wn7BQJ7tuWsn.svg)](https://asciinema.org/a/gjjIhfVORcWd1wn7BQJ7tuWsn)
