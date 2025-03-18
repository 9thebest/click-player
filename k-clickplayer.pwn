#include	<YSI_Coding\y_hooks>

/*
	Programmer, Developer
ผู้จัดทำ : ._BeSt]Dev_. (THe BeSt)
website: www.sa-mp.mp
*/

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
  new string[128];
  if (playerData[playerid][pAdmin] >= 6)
  {
        new listitems3[] = "1\tเทเลพอร์ตไปหาเขา/เธอ\n2\tเทเลพอร์ตเขามาหาคุณ\n3\tเตะ (ออกจากเซิฟเวอร์)\n4\tแบน (ออกจากเซิฟเวอร์)\n";
        format(string, sizeof(string), "คุณต้องการทำอะไรกับ %s' ?", GetPlayerNameEx(clickedplayerid));
		Dialog_Show(playerid, DIALOG_CLICK, DIALOG_STYLE_LIST, string, listitems3, "ตกลง", "ยกเลิก");
  }
  return 1;
}

Dialog:DIALOG_CLICK(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
  		{
			case 0:
			{
				static
					string[128],
	    			userid;
				if (!IsPlayerSpawnedEx(userid))
					return SendClientMessage(playerid, COLOR_RED, "[!] {FFFFFF}: ผู้เล่นไอดีนี้ยังไม่ได้อยู่ในสถานะปกติ");

				SendPlayerToPlayer(playerid, userid);

				format(string, sizeof(string), "You have ~y~teleported~w~ to %s.", GetPlayerNameEx(playerid));
				GameTextForPlayer(playerid, string, 5000, 1);
				return 1;
			}
			case 1:
			{
				static
	    			userid;
				SendPlayerToPlayer(userid, playerid);
				SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ดึงผู้เล่น %s มาหา", GetPlayerNameEx(userid));
				return 1;
			}
			case 2:
			{
				static
					reason[128],
	    			userid;
				SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกเตะโดยแอดมิน %s", GetPlayerNameEx(userid), GetPlayerNameEx(playerid));
				DelayedKick(userid);
				return 1;
			}
			case 3:
			{
				static
					reason[128], 
					query[256],
	    			userid;

				SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดยแอดมิน %s,", GetPlayerNameEx(userid), GetPlayerNameEx(playerid));

				playerData[userid][pBan] = 1;
				
				mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerBan` = %d  WHERE `playerID` = %d",
				playerData[userid][pBan], playerData[userid][pID]);
                mysql_tquery(g_SQL, query);

				Ban(userid);
				DelayedKick(userid);
				return 1;
			}
		}
	}
	return 1;
}
