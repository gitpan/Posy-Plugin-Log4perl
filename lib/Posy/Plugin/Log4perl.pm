package Posy::Plugin::Log4perl;

#
# $Id: Log4perl.pm,v 1.4 2005/03/07 15:02:45 blair Exp $
#

use 5.008001;
use strict;
use warnings;
use Log::Log4perl qw();

=head1 NAME

Posy::Plugin::Log4perl - Dispatch debug messages with Log::Log4perl

=head1 VERSION

This document describes Posy::Plugin::Log4perl version B<0.2>.

=cut

our $VERSION = '0.2';

=head1 SYNOPSIS

  @plugins = qw(
    Posy::Core
    Posy::Plugin::Log4perl
  );

  Configure $config_dir/plugins/log4perl:

    log4perl.logger.posy.plugin.log4perl  = DEBUG, SCREEN
    
    log4perl.appender.SCREEN        = Log::Log4perl::Appender::Screen
    log4perl.appender.SCREEN.stderr = 1
    log4perl.appender.SCREEN.layout = PatternLayout
    log4perl.appender.SCREEN.layout.ConversionPattern = [%r] %P %p %c - %m%n

=head1 DESCRIPTION

This module overrides Posy's default I<debug()> method with a version that
dispatches debug messages with L<Log::Log4perl>.  This module can be
used in a compatible manner with the core I<debug()> method by sending
all messages to STDERR or one can choose to log in a completely
incompatible manner.

Upon initialization, this module creations a Log4perl logger named
I<posy.plugin.log4perl>.

The core Posy I<debug()> does not support logging levels directly
compatible with those understood by Log4perl.  As such, this module
(crudely) wraps Posy's integer-based debug levels to Log4perl's five
levels.

=over 4 Mappings

=item * Posy 0 maps to Log4perl FATAL

=item * Posy 1 maps to Log4perl ERROR

=item * Posy 2 maps to Log4perl WARN

=item * Posy 3 maps to Log4perl INFO

=item * All other Posy levels map to Log4perl DEBUG

=head1 INTERFACE

=cut

my $logger;

=head2 init()

  $self->init()

Initialize the Log4perl logger.

=cut
sub init {
  my $self = shift;
  $self->SUPER::init();

  # Initialize Log::Log4perl
  my $cf = File::Spec->catfile(
              $self->{config_dir}, 'plugins', 'log4perl'
           );
  if (-r $cf) {
    Log::Log4perl::init($cf);
    $logger = Log::Log4perl->get_logger('posy.plugin.log4perl');
  } else {
  }
} # init()

=head2 debug

  $self->debug($level, $message);

Dispatches debug messages to a Log4perl logger.

C<$level> is an integer value.  The higher the level the more verbose
the logging.

=cut
sub debug {
  my ($self, $level, $msg) = @_;

  if (
      defined $logger and defined $level and
      defined $self->{'debug_level'} and 
      $level =~ /^\d+$/ and 
      $level <= $self->{'debug_level'}
     ) 
  {
    if      ($level == 0) {
      $logger->fatal($msg);
    } elsif ($level == 1) {
      $logger->error($msg);
    } elsif ($level == 2) {
      $logger->warn($msg);
    } elsif ($level == 3) {
      $logger->info($msg);
    } else                {
      $logger->debug($msg);
    }
  } else {
    # Fall back to the default method for some reason
    $self->SUPER::debug($level, $msg);
  }
} # debug()

=head1 SEE ALSO

L<Perl>, L<Posy>, L<Log::Log4perl>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-Posy-Plugin-Log4perl@rt.cpan.org> or through the web interface at 
L<http://rt.cpan.org>.

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

<http://devclue.com/blog/code/posy/Posy::Plugin::Log4perl/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;

