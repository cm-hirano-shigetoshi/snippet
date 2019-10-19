#!/usr/bin/env perl
use strict;
use warnings;

while (<>) {
    s/[\r\n]//g;
    # "/path/to/file:file_name:123:hogehoge fugafuga"
    my @a = split(":", $_);
    my @s = &get_text($a[0], $a[2]);
    foreach (@s) {
        print($_ . "\n");
    }
}

sub get_text {
    my ($file, $index) = @_;
    my @s = ();
    my $i = 1;
    open(IN, $file);
    foreach my $line (<IN>) {
        if ($i++ > $index) {
            $line =~ s/[\r\n]//g;
            if ($line =~ /^\S/) {
                last;
            }
            $line =~ s/^    //;
            push(@s, $line);
        }
    }
    close(IN);
    return @s;
}

