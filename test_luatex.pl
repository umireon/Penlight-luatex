#!/usr/bin/env perl
use strict;
use warnings;
use autodie;

use Cwd 'abs_path';
use File::Basename;
use File::Path qw(make_path);
use POSIX;

my $basedir = abs_path(dirname __FILE__);
$ENV{'LUAINPUTS'} = "$basedir//";
my $runner = "$basedir/luatex_runner.tex";

my $luatex = join(' ', @ARGV) || 'luatex';

make_path("$basedir/log");
chdir 'Penlight';
my $success = 1;
foreach my $file ( glob 'tests/*.lua' ) {
    my $name = basename $file, '.lua';
    my $cmd = "$luatex --jobname=$name --output-directory=$basedir/log --halt-on-error --shell-escape $runner";
    print "$name\n";
    my $result = `$cmd`;
    print $result =~ /=begin(.*)=end/s;
    ($? & 255) and die;
    $success &= $? == 0;

}
$success or die;
