#!/usr/bin/env perl
use strict;
use warnings;

my $first_line;
while (<>) {
    if (not defined $first_line) {
        $first_line = $_;
    } else {
        if (defined $first_line) {
            print($first_line);
            undef($first_line);
        }
        print;
    }
}

if (defined $first_line) {
    $first_line =~ s/[\r\n]//g;
    print($first_line);
}
