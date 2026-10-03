#!/usr/bin/env perl

# Name:         snip.pl
# Version:      0.1.4
# Release:      1
# License:      CC BY-NC-SA (Creative Commons Attribution-NonCommercial-ShareAlike)
#               https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
# Group:        System
# Source:       Lateral Blast
# URL:          N/A
# Distribution: CMDB
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Example Perl script to process a Service Now CMDB extract

use strict;
use warnings;
use lib;

# Install any required Perl modules that are missing
# Modules are installed under ~/perl5 so root is not required

BEGIN {
  my $local_lib = "$ENV{HOME}/perl5";
  my @modules   = ("Spreadsheet::XLSX","Getopt::Std","Text::Iconv");
  my @missing;
  lib->import("$local_lib/lib/perl5");
  foreach my $module (@modules) {
    if (!eval "require $module; 1") {
      push(@missing,$module);
    }
  }
  if (@missing) {
    print STDERR "Installing missing Perl modules: @missing\n";
    local $ENV{'PERL_MM_OPT'}         = "INSTALL_BASE=$local_lib";
    local $ENV{'PERL_MB_OPT'}         = "--install_base $local_lib";
    local $ENV{'PERL_MM_USE_DEFAULT'} = 1;
    system("cpan","-T",@missing);
    lib->import("$local_lib/lib/perl5");
    foreach my $module (@missing) {
      if (!eval "require $module; 1") {
        die "Failed to install Perl module $module\n";
      }
    }
  }
}

use Spreadsheet::XLSX;
use Getopt::Std;
use Text::Iconv;

my $script_name    = $0;
my $script_version = get_version();
my $options        = "chVi:";
my %option;
my @cmdb_data;
my $cmdb_file      = "cmdb.xlsx";

if ($#ARGV == -1) {
  print_usage();
  exit 1;
}
else {
  if (!getopts($options,\%option)) {
    print_usage();
    exit 1;
  }
}

# If given -i set input file to file given

if ($option{'i'}) {
  $cmdb_file = $option{'i'};
}

# If given -h print usage

if ($option{'h'}) {
  print_usage();
  exit;
}

# Print script version

if ($option{'V'}) {
  print_version();
  exit;
}

# If given -c check CMDB data

if ($option{'c'}) {
  check_local_env();
  import_cmdb_data();
  check_cmdb_data();
  exit;
}

# Nothing to do (e.g. -i given without -c)

print_usage();
exit 1;

# Print usage

sub print_usage {
  print "\n";
  print "Usage: $script_name -$options\n";
  print "\n";
  print "-h: Display help/usage\n";
  print "-V: Display version\n";
  print "-c: Check CMDB data\n";
  print "-i: Input file (Default ./cmdb.xlsx)\n";
  print "\n";
  return;
}

# Get version from the header of this script

sub get_version {
  my $version = "unknown";
  if (open(my $fh,"<",$script_name)) {
    while (my $line = <$fh>) {
      if ($line =~ /^# Version:\s+(\S+)/) {
        $version = $1;
        last;
      }
    }
    close($fh);
  }
  return $version;
}

# Print version

sub print_version {
  print "$script_version\n";
  return;
}

# Check local environment

sub check_local_env {
  if (!-e "$cmdb_file") {
    print STDERR "File $cmdb_file does not exist\n";
    exit 1;
  }
  return;
}

# Import CMDB
# Get the information we need and put each row into an array of arrays
# All worksheets are processed, empty rows and header rows are skipped

sub import_cmdb_data {
  my $parser = Text::Iconv->new("utf-8", "windows-1251");
  my $excel  = Spreadsheet::XLSX->new($cmdb_file,$parser);
  foreach my $sheet (@{$excel->{Worksheet}}) {
    $sheet->{MaxRow} ||= $sheet->{MinRow};
    $sheet->{MaxCol} ||= $sheet->{MinCol};
    foreach my $row ($sheet->{MinRow}..$sheet->{MaxRow}) {
      my @data;
      foreach my $col ($sheet->{MinCol}..$sheet->{MaxCol}) {
        my $cell = $sheet->{Cells}[$row][$col];
        my $val  = defined($cell) && defined($cell->{Val}) ? $cell->{Val} : "";
        $val =~ s/\n/ /g;
        push(@data,$val);
      }
      if (!grep { /\S/ } @data) {
        next;
      }
      if (grep { $_ eq "OS Service Pack" } @data) {
        next;
      }
      push(@cmdb_data,\@data);
    }
  }
  return;
}

# Check CMDB data
# Name,Class,Short description,Manufacturer,Location,OS Service Pack,OS Version,OS Address Width (bits),OS Domain,Operating System,Operational status

sub check_cmdb_data {
  foreach my $row (@cmdb_data) {
    my @data = @$row;
    $data[$_] = "" for grep { !defined($data[$_]) } 0..10;
    my $host_name   = $data[0];
    my $host_info   = $data[2];
    my $loc_info    = $data[4];
    my $os_rev      = $data[5];
    my $os_ver      = $data[6];
    my $os_domain   = $data[8];
    my $os_name     = $data[9];
    my $status      = lc($data[10]);
    if ($host_name =~ /\s+-/) {
      ($host_name) = split(/\s+-/,$host_name);
      print "$host_name contains a description in the Hostname field\n";
    }
    my $env_info = lc(join(" ",$host_name,$host_info,$loc_info,$os_domain));
    if ($env_info !~ /(?<![a-z])(dev|prod|test)/) {
      print "$host_name does not contain any environment information (e.g. Dev / Prod / Test)\n";
    }
    if ($os_name !~ /[A-Za-z]/) {
      print "$host_name does not contain any OS information\n";
    }
    if ($os_ver !~ /[0-9]/) {
      print "$host_name does not contain any OS version information\n";
    }
    if ($os_rev !~ /[0-9]/) {
      print "$host_name does not contain any OS revision information\n";
    }
    if ($status !~ /operational|decom/) {
      print "$host_name does not contain any operational status information\n";
    }
  }
  return;
}
