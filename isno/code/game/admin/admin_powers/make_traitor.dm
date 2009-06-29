/datum/admin_power/make_traitor
	name = "Make Traitor"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		..()
		if(href_list["mob"])
			var/dat = {"<html><head><title>Make Traitor</title></head><body><form action='byond://' method='get'>
					<input type='hidden' name='src' value='\ref[src]'>
			        <input type='hidden' name='mob-traitor' value=[href_list["mob"]]>
			        <p>Mission: <input type='text' name='mission' value='kill a whole bunch of people' size=40/></p>
			        <input type='submit' value='Submit'>
			        </body></html>"}
			ss13_browse(usr, dat, "window=maketraitor;size=400x500")
		else if(href_list["mob-traitor"])
			var/mob/M = locate(href_list["mob-traitor"])
			if(!M)
				ss13_browse(usr, null, "window=maketraitor")
				return
			M << "\red<h2>You are a traitor now!</h2>"
			var/traitorname = "[M.client.key] ([M.spawn_name])"
			var/datum/mission/freeform/mission = new (list(M), traitorname, href_list["mission"])
			config.current_mode.add_mission(mission)
			M.tell_mission(mission)

			if(istype(M, /mob/carbon))
				new /datum/effect/traitor_radio(M)
			else if(istype(M, /mob/silicon/ai))
				new /datum/effect/law_zero(M)
			var/dat = "<html><head><title>Traitor made!</title></head><body>"
			dat += "<p>[traitorname] given mission to [href_list["mission"]]!</p>"
			dat += "<p><a href='?src=\ref[src];close=1'>Close</a>"
			world.log_admin("[usr.ckey] made [M] ([M.ckey]) a traitor with mission to [href_list["mission"]]")
			ss13_browse(usr, dat, "window=maketraitor")
		else
			ss13_browse(usr, null, "window=maketraitor")

	get_desc(mob/M)
		if(game_started)
			return "<a href='?src=\ref[src];mob=\ref[M]'>Make Traitor</a>"
		else
			return null