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
Readonly::Scalar our $HEIGHT => 5;
Readonly::Scalar our $WIDTH_BASE => 32;
Readonly::Scalar our $WIDTH_SEC => 52;

# Version.
our $VERSION = 0.02;

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
	$args{'-height'} = height_by_windowscrheight($HEIGHT, %args);
	if ($args{'-second'}) {
		$args{'-width'} = width_by_windowscrwidth($WIDTH_SEC, %args);
	} else {
		$args{'-width'} = width_by_windowscrwidth($WIDTH_BASE, %args);
	}

	# Create the widget.
	my $self = $class->SUPER::new(%args);

	# Parse time.
	my ($sec, $min, $hour) = map { sprintf '%02d', $_ } localtime $args{'-time'};

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
			localtime $time;
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

__END__

=pod

=encoding utf8

=head1 NAME

Curses::UI::Time - Create and manipulate time widgets.

=head1 CLASS HIERARCHY

 Curses::UI::Widget
 Curses::UI::ContainerWidget
    |
    +----Curses::UI::ContainerWidget
       --Curses::UI::Label
       --Curses::UI::Number
            |
            +----Curses::UI::Time

=head1 SYNOPSIS

 use Curses::UI;
 my $win = $cui->add('window_id', 'Window');
 my $time = $win->add(
         'mynum', 'Curses::UI::Time',
         -time => 1400609240,
 );
 $time->draw;

=head1 DESCRIPTION

Curses::UI::Time is a widget that shows a time in graphic form.

=head1 STANDARD OPTIONS

C<-parent>, C<-x>, C<-y>, C<-width>, C<-height>, 
C<-pad>, C<-padleft>, C<-padright>, C<-padtop>, C<-padbottom>,
C<-ipad>, C<-ipadleft>, C<-ipadright>, C<-ipadtop>, C<-ipadbottom>,
C<-title>, C<-titlefullwidth>, C<-titlereverse>, C<-onfocus>,
C<-onblur>.

For an explanation of these standard options, see 
L<Curses::UI::Widget|Curses::UI::Widget>.

=head1 WIDGET-SPECIFIC OPTIONS

=over 8

=item * C<-colon> < NUMBER >

 View colon flag.
 Default value is '1'.

=item * C<-fg> < CHARACTER >

 Foreground color.
 Possible values are defined in Curses::UI::Color.
 Default value is '-1'.

=item * C<-time> < TIME >

 Time.
 Default value is actual time.

=item * C<-second> < SECOND_FLAG >

 View second flag.
 Default value is 0.

=back

=head1 STANDARD METHODS

C<layout>, C<draw>, C<intellidraw>, C<focus>, C<onFocus>, C<onBlur>.

For an explanation of these standard methods, see
L<Curses::UI::Widget|Curses::UI::Widget>.

=head1 WIDGET-SPECIFIC METHODS

=over 8

=item * C<new(%parameters)>

 Constructor.
 Create widget with volume in graphic form, defined by -volume number.
 Returns object.

=item * C<colon()>

 Get or set colon flag.
 Returns colon flag.

=item * C<time()>

 Get or set time.
 Returns time in seconds.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Curses::UI;

 # Object.
 my $cui = Curses::UI->new;
 
 # Main window.
 my $win = $cui->add('window_id', 'Window');
 
 # Add volume.
 $win->add(
         undef, 'Curses::UI::Time',
         '-time' => 1400609240,
 );
 
 # Binding for quit.
 $win->set_binding(\&exit, "\cQ", "\cC");
 
 # Loop.
 $cui->mainloop;

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Curses::UI;

 # Object.
 my $cui = Curses::UI->new(
         -color_support => 1,
 );
 
 # Main window.
 my $win = $cui->add('window_id', 'Window');

 # Add time.
 my $time = $win->add(
         undef, 'Curses::UI::Time',
         '-border' => 1,
         '-second' => 1,
         '-time' => time,
 );
 
 # Binding for quit.
 $win->set_binding(\&exit, "\cQ", "\cC");

 # Timer.
 $cui->set_timer(
         'timer',
         sub {
                 $time->time(time);
                 $cui->draw(1);
                 return;
         },
         1,
 );
 
 # Loop.
 $cui->mainloop;

=head1 DEPENDENCIES

L<Curses>,
L<Curses::UI::Common>,
L<Curses::UI::Label>,
L<Curses::UI::Number>,
L<Curses::UI::Widget>,
L<Encode>,
L<Readonly>.

=head1 SEE ALSO

L<Curses::UI>,
L<Curses::UI::Widget>.

=head1 REPOSITORY

L<https://github.com/tupinek/Curses-UI-Time>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 DEDICATION

To Czech Perl Workshop 2014 and their organizers.

=head1 VERSION

0.02

=cut
