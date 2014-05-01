# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'TODO';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Curses-UI-Time';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Curses-UI-Time';
resources 'homepage' => 'https://github.com/tupinek/Curses-UI-Time';
resources 'repository' => 'git://github.com/tupinek/Curses-UI-Time';
test_requires 'English' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
