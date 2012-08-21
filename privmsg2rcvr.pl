#!/usr/bin/perl
# Copyright 2012 Gene Cumm

Xchat::register('privmsg2rcvr','0.04','Move Privmsg messages to the reciever\'s window');
# Don't eat the message UNLESS we need to move it and minimize how much logic
# is processed before aborting.

Xchat::hook_server('PRIVMSG',\&PrivMsgToReceiverWin);

# DO try to pop open the desired context window when not found
use constant PrivMsgToReceiverWinPOP => 1;

sub PrivMsgToReceiverWin {
	my @msg = @{$_[0]};
	my @msge = @{$_[1]};
	my $chan = $msg[2];
	if ( (substr($chan, 0, 1)) ne "#") {
	  my $nick = Xchat::get_info("nick");
	  if ($chan ne $nick) {
	    my $srv = Xchat::get_info("server");
	    if (!(Xchat::find_context($chan, $srv))) {
		# Attempt to open the message window first
		Xchat::command("QUERY ".$chan);
	    }
	    if (Xchat::set_context($chan, $srv)) {
		Xchat::emit_print("Channel Message", $nick, substr($msge[3], 1));
		return Xchat::EAT_ALL;
	    }
	  }
	}
	return Xchat::EAT_NONE;
}
