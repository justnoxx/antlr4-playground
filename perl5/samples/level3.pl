use strict;
use warnings;
use Data::Dumper;

if (!$ARGV[0]) {
    die "Argument is expected";
}
my $username = "Username";

# if username equals something that comes from args[0] print with OK
if ($username eq $ARGV[0]) {
    print "The same name $username\n";
}
else {
    print "The name is different.\nGot: $ARGV[0], expected: $username\n";
}
