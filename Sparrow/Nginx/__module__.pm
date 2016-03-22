package Sparrow::Nginx;

use Rex -base;
use Rex::Misc::ShellBlock;

sub prepare {

  my ( $params ) = @_;

  my $pkg_list = case operating_system, {
     CentOS  => [ "perl-devel", "perl-Data-Dumper" ],
     default => [ ],
  };

  install package => 'curl';

  for my $pkg (@{$pkg_list}) {
     pkg $pkg, ensure => 'installed';
  }

  my $output = run "curl -fkL http://cpanmin.us/ -o /bin/cpanm && chmod +x /bin/cpanm";  
  say $output;

  my $output = run "cpanm Digest::MD5 Test::More Sparrow";
  say $output;

};

task setup => sub {

  my ( $params ) = @_;

  prepare();

  my $output = run "sparrow index update && sparrow plg install nginx-check";  

  say $output;

};

task run => sub {

  my $output = run "sparrow plg run nginx-check 2>&1";

  my $status = $?;

  say $output;

  die "sparrow plg run nginx-check returned bad exit code" unless  $status == 0;

};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Sparrow::Nginx/;

 task yourtask => sub {
    Sparrow::Nginx::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
