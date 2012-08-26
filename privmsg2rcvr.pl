#!/usr/bin/perl
# Copyright 2012 Gene Cumm

##   Permission is hereby granted, free of charge, to any person
##   obtaining a copy of this software and associated documentation
##   files (the "Software"), to deal in the Software without
##   restriction, including without limitation the rights to use,
##   copy, modify, merge, publish, distribute, sublicense, and/or
##   sell copies of the Software, and to permit persons to whom
##   the Software is furnished to do so, subject to the following
##   conditions:
##
##   The above copyright notice and this permission notice shall
##   be included in all copies or substantial portions of the Software.
##
##   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##   OTHER DEALINGS IN THE SOFTWARE.

Xchat::register('privmsg2rcvr','0.05','Move Privmsg messages to the reciever\'s window');
# Don't eat the message UNLESS we need to move it and minimize how much logic
# is processed before aborting.

Xchat::hook_server('PRIVMSG',\&PrivMsgToReceiverWin);

# DO try to pop open the desired context window when not found
use constant PrivMsgToReceiverWinPOP => 1;

sub PrivMsgToReceiverWinDebugMsgSN {
	my $cxt = Xchat::get_context();
	Xchat::command("QUERY "."pvmsg");
	Xchat::set_context("pvmsg", $_[0]);
	Xchat::emit_print("Channel Message", $_[1], $_[2]);
	Xchat::set_context($cxt);
}

sub PrivMsgToReceiverWinDebugMsg {
	return PrivMsgToReceiverWinDebugMsgSN(Xchat::get_info("server"), Xchat::get_info("nick"), $_[0]);
}

sub PrefixToNick {
	if (($_[0] =~ s/:([^!@]+)([!@].*)?/$1/) >= 1) {
		return $_[0];
	} else {	# non-prefix arg
		return "";
	}
}

sub PrivMsgToReceiverWin {
	my @msg = @{$_[0]};
	my @msge = @{$_[1]};
	my $p1;
	if  ( (substr($msg[0], 0, 1)) ne ":") {
		$p1 = $msg[1];
	} else {
		$p1 = $msg[2];
	}
	if ( (substr($p1, 0, 1)) ne "#") {
	  my $nick = Xchat::get_info("nick");
	  my $snick = PrefixToNick($msg[0]);
	  if ($snick eq $nick) {
	    my $srv = Xchat::get_info("server");
	    my $cxt = Xchat::get_context();
	    if (!(Xchat::find_context($p1, $srv)) && (PrivMsgToReceiverWinPOP)) {
		# Attempt to open the message window first
		Xchat::command("QUERY ".$p1);
	    }
	    if (Xchat::set_context($p1, $srv)) {
		Xchat::emit_print("Channel Message", $nick, substr($msge[3], 1));
		Xchat::set_context($cxt);
		return Xchat::EAT_ALL;
	    }
	  }
	}
	return Xchat::EAT_NONE;
}
