# -*- coding: utf-8 -*-
__module_name__ = "wallopSrvWinHL"
__module_version__ = "0.07"
__module_description__ = "Moves wallops to server window and highlights"
# ; Based on http://enigma-penguin.net/wallop.py0.1;"

import xchat

def dispwallop_dbg(disp, string):
	DBG_DISPWALLOP = 1
	if DBG_DISPWALLOP == 1:
		disp.prnt(string)

def dispwallop_dbgEmit(disp, event_name, *args):
	DBG_DISPWALLOP = 1
	if DBG_DISPWALLOP == 1:
		disp.emit_print(event_name, *args)

def dispwallop(word, word_eol, userdata):
	SRV = xchat.get_info("server")
	srvWin = xchat.find_context(server='%s' % SRV)
	for i in xchat.get_list("channels"):
		dispwallop_dbg(xchat, ("Server: %s; Network: %s; Name: %s; Type: %d" %
			(i.server, i.network, i.channel, i.type)))
		if i.type == 1 and i.server == xchat.get_info("server"):
			srvWin = i.context
			#srvWin = xchat.find_context(i.server,i.channel)
	dispwallop_dbg(srvWin, "Here's srvWin")
	dispwallop_dbgEmit(srvWin, "Notice",'%s/Wallops@%s' % (word[0], SRV),'%s' % word[1])
	srvWin.emit_print("Notice",'%s/Wallops' % word[0],'%s' % word[1])
	srvWin.command("gui color 3")
	return xchat.EAT_ALL

xchat.hook_print("Receive Wallops", dispwallop)
