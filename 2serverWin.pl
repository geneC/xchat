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

Xchat::register('2serverWin','0.01','Move WALLOPS and Global Notices to the server window');

Xchat::hook_print('Notice',\&PrntMsgToServerWinNotice, {data=>'Notice'});
Xchat::hook_server('NOTICE',\&SrvMsgToServerWinNotice, {data=>'Notice'});
# Xchat::hook_server('Notice',\&MsgToServerWin);
# Xchat::hook_server('Notice',\&MsgToServerWin, {data=>'Notice'});
Xchat::hook_print('Receive Wallops',\&PrntMsgToServerWinWallops, {data=>'WALLOPS'});
# Xchat::hook_server('WALLOPS',\&MsgToServerWin);
# Xchat::hook_server('WALLOPS',\&SrvMsgToServerWin, {data=>'Receive Wallops'});
# Xchat::hook_server('Server Notice',\&MsgToServerWin);

sub PrefixToNick {
	my $n = $_[0];
	if (($n =~ s/:([^!@]+)([!@].*)?/$1/) >= 1) {
		return $n;
	} else {	# non-prefix arg
		return "";
	}
}

sub FindServerWinContext {
	my $cid = $_[0];
	my $c;
	foreach $c (Xchat::get_list('channels')) {
	  if ((${$c}{id} eq $cid)) {	# connection ID
		if (${$c}{type} == 1) {	# server
			return ${$c}{context};
		}
	  }
	}
}

sub SrvMsgToServerWinNotice {
	my @msg = @{$_[0]};
	my @msge = @{$_[1]};
	my $evt = $_[2];
	if  ( (substr($msg[0], 0, 1)) ne ":") {
		$p1 = 1;
	} else {
		$p1 = 2;
	}
# 	if ($p1 =~ /^.*\*.*$/) {
	if (index($msg[$p1], '*') >= 0) {
		my $srv = Xchat::get_info('server');
		my $cid = Xchat::get_info('id');
		my $cxt = Xchat::get_context();
		Xchat::set_context(FindServerWinContext($cid));
		Xchat::emit_print($evt, PrefixToNick($msg[0]), substr($msge[$p1+1], 1));
		Xchat::command('GUI COLOR 3');
		Xchat::command('GUI FLASH');
		Xchat::set_context($cxt);
		return Xchat::EAT_ALL;
	}
	return Xchat::EAT_NONE;
}

sub PrntMsgToServerWinNotice {
	my @msg = @{$_[0]};
	my $evt = $_[1];
	if ($msg[1] =~ /^\[Global Notice\] .*$/) {
		my $cid = Xchat::get_info('id');
		my $cxt = Xchat::get_context();
		Xchat::set_context(FindServerWinContext($cid));
# 		Xchat::emit_print('Notice', $msg[0], 'TN-'.$msg[1]);
		Xchat::emit_print($evt, $msg[0], $msg[1]);
		Xchat::command('GUI COLOR 3');
	# 	Xchat::command('GUI FLASH');
		Xchat::set_context($cxt);
		return Xchat::EAT_ALL;
# 	return Xchat::EAT_NONE;
	}
}

sub PrntMsgToServerWinWallops {
	my @msg = @{$_[0]};
	my $evt = $_[1];
	my $cid = Xchat::get_info('id');
	my $cxt = Xchat::get_context();
	Xchat::set_context(FindServerWinContext($cid));
	Xchat::emit_print('Notice', $msg[0].'/Wallops', $msg[1]);
	Xchat::command('GUI COLOR 3');
# 	Xchat::command('GUI FLASH');
	Xchat::set_context($cxt);
		return Xchat::EAT_ALL;
# 	return Xchat::EAT_NONE;
}

sub SrvMsgToServerWin {
	my @msg = @{$_[0]};
	my @msge = @{$_[1]};
	my $evt = $_[2];
	my $srv = Xchat::get_info('server');
	my $cid = Xchat::get_info('id');
	my $cxt = Xchat::get_context();
	Xchat::set_context(FindServerWinContext($cid));
# 	Xchat::emit_print("Channel Message", "srv", "-srv-".$msge[0].'-opt-'.$_[2].":");
	Xchat::emit_print($evt, PrefixToNick($msg[0]), substr($msge[2], 1));
	Xchat::command('GUI COLOR 3');
	Xchat::command('GUI FLASH');
	Xchat::set_context($cxt);
		return Xchat::EAT_ALL;
	return Xchat::EAT_NONE;
}
