use 5.008001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Posy::Plugin::Log4perl',
    VERSION_FROM      => 'lib/Posy/Plugin/Log4perl.pm', 
    PREREQ_PM         => {
                          Posy          => 0.92,
                          Posy::Core    => 0.92,
                          Log::Log4perl => 0.51,
                          Test::More    => 0
                         }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Posy/Plugin/Log4perl.pm', # retrieve abstract from module
       AUTHOR         => 'blair christensen. <blair@devclue.com>') : ()),
);
