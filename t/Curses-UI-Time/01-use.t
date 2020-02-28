use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('Curses::UI::Time');
}

# Test.
require_ok('Curses::UI::Time');
