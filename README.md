# Thermometer

[![Build Status](https://travis-ci.org/petertseng/thermometer.svg?branch=master)](https://travis-ci.org/petertseng/thermometer)

A simple Thermometer solver.

Just iterates all columns/rows.
Guesses if necessary.

I got tired of doing these by hand.

A good source of Thermometer puzzles is http://www.janko.at/Raetsel/Thermometer.

# Usage

`thermometer.cr` takes its inputs on ARGF since it's too hard to specify the inputs on ARGV.

```
$ crystal build --release thermometer.cr
$ ./thermometer janko/001
Col 0 (2) has only 2 true left: Thermometer 1 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 1 (4) has only 2 false left: Thermometer 3 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 4 (5) has only 1 false left: Thermometer 9 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 0 (4) has only 2 false left: Thermometer 2 first 3 are true
Row 0 (4) has only 4 true left: Thermometer 2 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 1 (2) has only 4 false left: Thermometer 8 first 1 are true
Row 1 (2) has only 2 true left: Thermometer 8 last 3 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 2 (2) has only 4 false left: Thermometer 5 first 1 are true
Row 2 (2) has only 2 true left: Thermometer 5 last 3 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 5 (5) has only 1 false left: Thermometer 7 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 0 (2) has only 1 false left: Thermometer 1 first 1 are true
Col 0 (2) has only 1 true left: Thermometer 1 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 1 (4) has only 0 false left: Thermometer 3 first 2 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 2 (3) has only 1 false left: Thermometer 4 first 2 are true
Col 2 (3) has only 2 true left: Thermometer 4 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 4 (5) has only 0 false left: Thermometer 9 first 1 are true
Col 4 (5) has only 0 false left: Thermometer 7 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 5 (5) has only 0 true left: Thermometer 11 last 1 are false
Thermometer 11 after 1 are all false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Col 5 (3) has only 0 false left: Thermometer 10 first 3 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 0 (4) has only 0 true left: Thermometer 2 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 1 (2) has only 0 true left: Thermometer 8 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 2 (2) has only 0 true left: Thermometer 5 last 1 are false
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 3 (3) has only 0 false left: Thermometer 6 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
Row 4 (4) has only 0 false left: Thermometer 6 first 1 are true
     2    4    3    3    5    3
4  2.1  2.2  2.3  2.4  2.5 10.3
2  8.5  8.4  8.3  8.2  8.1 10.2
2  5.5  5.4  5.3  5.2  5.1 10.1
3  1.3  3.1  4.3  6.1  9.1 11.3
4  1.2  3.2  4.2  6.2  9.2 11.2
5  1.1  3.3  4.1  7.1  7.2 11.1
```

# Future directions

* Instead of scanning all rows + all columns each time, only scan where anything changed in the last pass (is speedup worth the extra code?).
