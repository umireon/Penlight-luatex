#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

use Cwd 'abs_path';
use File::Basename;

my $basedir = abs_path(dirname __FILE__);
$ENV{'LUAINPUTS'} = "$basedir//";
$ENV{'HOME'} = '' if $ENV{'USERPROFILE'};
my $runner = "$basedir/texlua_runner.lua";

chdir 'Penlight';
my $fail = 0;
foreach my $file ( glob 'tests/*.lua' ) {
    my $name = basename $file, '.lua';
    print $name."\n";
    my $code = system("texlua $runner $name $file");
    $fail = 1 if $code != 0;
}
$fail and die;
