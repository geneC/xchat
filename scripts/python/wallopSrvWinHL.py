# -*- coding: utf-8 -*-
__module_name__ = "wallopSrvWinHL"
__module_version__ = "0.02"
__module_description__ = "Moves wallops to server window and highlights; Based on http://enigma-penguin.net/wallop.py0.1;"

import xchat

def dispwallop(word, word_eol, userdata):
        SERVER = xchat.get_info("network")
        disp = xchat.find_context(server='%s' % SERVER, channel='%s' % SERVER)
        disp.emit_print("Notice",'%s/Wallops' % word[0],'%s' % word[1])
        disp.command("gui color 3")
        return xchat.EAT_ALL

xchat.hook_print("Receive Wallops", dispwallop)
