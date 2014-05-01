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
		'-colon' => 1,
		'-fg' => -1,
		'-time' => time,
		'-second' => 0,
		%userargs,
		-focusable => 0,
	);

	# Width and height.
	$args{'-height'} = height_by_windowscrheight(5, %args);
	if ($args{'-second'}) {
		$args{'-width'} = width_by_windowscrwidth(52, %args);
	} else {
		$args{'-width'} = width_by_windowscrwidth(32, %args);
	}

	# Create the widget.
	my $self = $class->SUPER::new(%args);

	# Parse time.
	my ($sec, $min, $hour) = map { sprintf '%02d', $_ } localtime($args{'-time'});

	# Widgets.
	$self->add(
		'hour1', 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $hour, 0, 1),
		'-x' => 0,
	);
	$self->add(
		'hour2', 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $hour, 1, 1),
		'-x' => 7,
	);
	$self->add(
		'colon1', 'Label',
		'-fg' => $args{'-fg'},
		'-hidden' => ! $self->{'-colon'},
		'-text' => $COLON,
		'-x' => 14,
	);
	$self->add(
		'min1', 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $min, 0, 1),
		'-x' => 19,
	);
	$self->add(
		'min2', 'Curses::UI::Number',
		'-fg' => $args{'-fg'},
		'-num' => (substr $min, 1, 1),
		'-x' => 26,
	);
	if ($self->{'-second'}) {
		$self->add(
			'colon2', 'Label',
			'-fg' => $args{'-fg'},
			'-hidden' => ! $self->{'-colon'},
			'-text' => $COLON,
			'-x' => 33,
		);
		$self->add(
			'sec1', 'Curses::UI::Number',
			'-fg' => $args{'-fg'},
			'-num' => (substr $sec, 0, 1),
			'-x' => 38,
		);
		$self->add(
			'sec2', 'Curses::UI::Number',
			'-fg' => $args{'-fg'},
			'-num' => (substr $sec, 1, 1),
			'-x' => 45,
		);
	}

	# Layout.
	$self->layout;

	# Return object.
	return $self;
}

# Get or set colon flag.
sub colon {
	my ($self, $colon) = @_;
	if (defined $colon) {
		$self->{'-colon'} = $colon;
		if ($colon) {
			$self->getobj('colon1')->show;
		} else {
			$self->getobj('colon1')->hide;
		}
		if ($self->{'-second'}) {
			if ($colon) {
				$self->getobj('colon2')->show;
			} else {
				$self->getobj('colon2')->hide;
			}
		}
	}
	return $self->{'-colon'};
}

# Get or set time.
sub time {
	my ($self, $time) = @_;
	if (defined $time) {
		$self->{'-time'} = $time;
		my ($sec, $min, $hour) = map { sprintf '%02d', $_ }
			localtime($time);
		$self->getobj('hour1')->num(substr $hour, 0, 1);
		$self->getobj('hour2')->num(substr $hour, 1, 1);
		$self->getobj('min1')->num(substr $min, 0, 1);
		$self->getobj('min2')->num(substr $min, 1, 1);
		if ($self->{'-second'}) {
			$self->getobj('sec1')->num(substr $sec, 0, 1);
			$self->getobj('sec2')->num(substr $sec, 1, 1);
		}
	}
	return $self->{'-time'};
}

1;
