#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Czar"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Player Status",
	author = PLUGIN_AUTHOR,
	description = "Displays status of players ip/steamid",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ip", statuscommand, ADMFLAG_ROOT);
}

public Action statuscommand(int client, int args)
{
	Menu menu = CreateMenu(MenuHandler1, MENU_ACTIONS_ALL);
	SetMenuTitle(menu, "Select a Player");
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			char player[64];
			char id[4];
			IntToString(i, id, sizeof(id));
			GetClientName(i, player, sizeof(player));
			AddMenuItem(menu, id, player);
		}
	}
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 0);
}

public int MenuHandler1(Handle menu, MenuAction action, int client, int temp)
{
	if ( action == MenuAction_Select ) 
	{
		char name[64];
		char id[4];
		char ip[64];
		char steamid[64];
		GetMenuItem(menu, temp, id, sizeof(id));
		int clientid = StringToInt(id);
		GetClientIP(clientid, ip, sizeof(ip), true);
		GetClientName(clientid, name, sizeof(name));
		GetClientAuthId(clientid, AuthId_Steam2, steamid, sizeof(steamid), true);
		PrintToChat(client, " \x02Name: %s", name);
		PrintToChat(client, " \x02IP: %s", ip);
		PrintToChat(client, " \x02SteamID: %s", steamid);
	}
	else if (action == MenuAction_Cancel) 
	{ 
		PrintToServer("Client %d's menu was cancelled.  Reason: %d", client, temp); 
	} 
		
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}

}
