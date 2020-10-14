#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use subs 'say_this';

main();

sub main {
    say 'Enter your name:';
    my $name = <STDIN>;
    chomp $name;
    my $hello = sprintf 'Hello, %s!', $name;
    say_this $hello;
}

sub say_this {
    my $str = shift;
    say $str;
}
