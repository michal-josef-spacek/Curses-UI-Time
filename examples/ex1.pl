#!/usr/bin/env perl

use strict;
use warnings;

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

# Output like:
# ██████ ██████      ██████ ██████
#     ██ ██  ██  ██  ██  ██     ██
# ██████ ██  ██      ██  ██     ██
# ██     ██  ██  ██  ██  ██     ██
# ██████ ██████      ██████     ██