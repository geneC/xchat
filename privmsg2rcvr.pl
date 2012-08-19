#!/usr/bin/perl

Xchat::register('privmsg2rcvr','0.030','Move Privmsg messages to the reciever\'s window');

Xchat::hook_server('PRIVMSG',\&PrivMsgToReceiverWin);

sub PrivMsgToReceiverWin {
	my @msg = @{$_[0]};
	my @msge = @{$_[1]};
	my $chan = $msg[2];
# 	if ( ((substr($chan, 0, 1)) ne "#") && ($chan ne $nick)) {
	if ( (substr($chan, 0, 1)) ne "#") {
	  my $nick = Xchat::get_info("nick");
	  my $omsg = sprintf("%s|%s|%s|%s|%s|%s|%s", $nick, $msg[0],$msg[1],$msg[2],$msg[3],$msg[4], ($msg[5]?$msge[5]:''));
# 	  Xchat::emit_print("Generic Message","-dbg-".$chan."-", $omsg, null);
	  if (($chan ne $nick) && (1)) {
		my $srv = Xchat::get_info("server");

# 		my $chnWin = Xchat::find_context($chan, $srv);
# 		my $omsg = sprintf("%s|%s|%s|%s|%s|%s|%s", $nick, $msg[0],$msg[1],$msg[2],$msg[3],$msg[4], ($msg[5]?$msge[5]:''));

		Xchat::set_context($chan, $srv);

# 		Xchat::emit_print("Generic Message","-G\00310-\002-\002\003", $omsg, null);

# 		Xchat::emit_print("Generic Message", $nick, $msge[3], null);
		Xchat::emit_print("Channel Message", $nick, substr($msge[3], 1));

# 		Xchat::emit_print("Generic Message", "-".$nick, $msge[3], null);
# 		Xchat::print($omsg, $chan, $srv);

# 		return Xchat::EAT_ALL;
	  }
	}
	return Xchat::EAT_NONE;
}
