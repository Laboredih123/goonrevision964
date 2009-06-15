/datum/admin_power/mute
	name = "Mute"
	panel_type = PANEL_TYPE_PLAYER

	New(adminlevel)
		return

	Topic(href, href_list)
		if(href_list["mob"]) //show the window
			var/mob/M = locate(href_list["mob"])
			if(!M || !M.client)
				return
			if(!M.client.muted)
				world.log_admin("[usr.key] muted [M.ckey]")
				M.client.muted = 1
				muted += M.ckey
			else
				world.log_admin("[usr.key] unmuted [M.ckey]")
				M.client.muted = 0
				muted -= M.ckey
		return ..()

	get_desc(mob/M)
		if(M && M.client)
			return "<a href='?src=\ref[src];mob=\ref[M]'>[M.client.muted ? "Unmute" : "Mute"]</a>"

/client/var/muted = 0

/client/New()
	if(src.ckey in muted)
		src.muted = 1
	return ..()

/var/list/muted = list()