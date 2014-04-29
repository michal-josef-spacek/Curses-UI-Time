package Curses::UI::Time;

# Pragmas.
use Curses::UI::Widget;
use base qw(Curses::UI::ContainerWidget);
use strict;
use warnings;

# Modules.
use Curses;
use Curses::UI::Common qw(keys_to_lowercase);
use Curses::UI::Label;
use Curses::UI::Number;
use Encode qw(decode_utf8);
use Readonly;

# Constants.
Readonly::Scalar our $COLON => decode_utf8(<<'END');
    
 ██ 
    
 ██ 
    
END

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, %userargs) = @_;
	keys_to_lowercase(\%userargs);
	my %args = (
		'-fg' => -1,
		'-time' => time,
		%userargs,
	);

	# Width and height.
	$args{'-height'} = height_by_windowscrheight(5, %args);
	$args{'-width'} = width_by_windowscrwidth(32, %args);

	# Create the widget.
	my $self = $class->SUPER::new(%args);

	# Parse time.
	my ($sec, $min, $hour) = map { sprintf '%02d', $_ } localtime($args{'-time'});

	# Widgets.
	$self->add(
		undef, 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $hour, 0, 1),
		'-x' => 0,
	);
	$self->add(
		undef, 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $hour, 1, 1),
		'-x' => 7,
	);
	$self->add(
		undef, 'Label',
		'-fg' => $args{'-fg'},
		'-text' => $COLON,
		'-x' => 14,
	);
	$self->add(
		undef, 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $min, 0, 1),
		'-x' => 19,
	);
	$self->add(
		undef, 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $min, 1, 1),
		'-x' => 26,
	);

	# Layout.
	$self->layout;

	# Return object.
	return $self;
}

1;
