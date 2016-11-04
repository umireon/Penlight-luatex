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
foreach my $file ( glob 'tests/*.lua' ) {
    my $name = basename $file, '.lua';
    print $name."\n";
    system("texlua $runner $name $file") and die;
}
