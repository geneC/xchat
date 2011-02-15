# -*- coding: utf-8 -*-
__module_name__ = "wallopSrvWinHL"
__module_version__ = "0.04"
__module_description__ = "Moves wallops to server window and highlights; Based on http://enigma-penguin.net/wallop.py0.1;"

import xchat

def dispwallop_dbg(disp, string):
	DBG_DISPWALLOP = 0
	if DBG_DISPWALLOP == 1:
		disp.prnt(string)

def dispwallop_dbgEmit(disp, event_name, *args):
	DBG_DISPWALLOP = 0
	if DBG_DISPWALLOP == 1:
		disp.emit_print(event_name, *args)

def dispwallop(word, word_eol, userdata):
	DBG_DISPWALLOP = 0
	NET = xchat.get_info("network")
	srvWin = xchat.find_context(server='%s' % NET)
	for i in xchat.get_list("channels"):
		dispwallop_dbg(xchat, "Server: %s; Network: %s; Name: %s; Type: %d" % (i.server, i.network, i.channel, i.type))
		if i.type == 1 and i.server == xchat.get_info("server"):
			#srvWin = xchat.find_context(i.server,i.channel)
			srvWin = i.context
	dispwallop_dbg(srvWin, "Here's srvWin")
        #disp = xchat.find_context(server='%s' % SERVER)
        # , channel='%s' % SERVER
        # disp.emit_print("Notice",'%s/Wallops@%s' % (word[0], NETWORK),'%s' % word[1])
        #xchat.emit_print("Notice",'%s/Wallops@%s' % (word[0], SERVER),'%s' % word[1])
        dispwallop_dbgEmit(srvWin, "Notice",'%s/Wallops@%s' % (word[0], NET),'%s' % word[1])
        srvWin.emit_print("Notice",'%s/Wallops' % word[0],'%s' % word[1])
        #disp.command("gui color 3")
        srvWin.command("gui color 3")
        #return
        return xchat.EAT_ALL

xchat.hook_print("Receive Wallops", dispwallop)
