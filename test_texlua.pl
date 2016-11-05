#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

use Cwd 'abs_path';
use File::Basename;
use POSIX;

my $basedir = abs_path(dirname __FILE__);
$ENV{'LUAINPUTS'} = "$basedir//";
my $runner = "$basedir/texlua_runner.lua";

my $texlua = join(' ', @ARGV) || 'texlua';

chdir 'Penlight';
my $success = 1;
foreach my $file ( glob 'tests/*.lua' ) {
    my $name = basename $file, '.lua';
    my $cmd = "$texlua $runner $name $file";
    print "$cmd\n";
    my $status = system $cmd;
    ($status & 255) and die;
    $success &= $status == 0;
}
$success or die;
