#!/usr/bin/env perl
use strict;
use warnings;

while (<>) {
    s/[\r\n]//g;
    my @a = split(":", $_);
    (my $file_name = $a[0]) =~ s%^.*/([^/]+)$%$1%;
    print($a[0] . ":" . $file_name . ":" . $a[1] . ":" . $a[2] . "\n");
}

