/obj/machinery/computer/sleep_console/New()
	..()
	spawn(5)
		src.connected = locate(/obj/machinery/sleeper, get_step(src, WEST))

/obj/machinery/computer/sleep_console/interact(mob/user as mob)
	if(!..()) return
	if(!src.connected) return

	var/t1
	var/mob/carbon/occupant = src.connected.occupant
	var/dat  = text("<font color='blue'><B>Sleeper Display</B></font><BR><BR>")
	if(!occupant)	dat += text("The sleeper is empty.")
	else
		if(occupant.is_conscious())	t1 = "<font color='blue>conscious</font>"
		else if(occupant.is_dead)	t1 = "<font color='red'>*DEAD*</font>"
		else						t1 = "<font color='blue'>unconscious</font>"
		dat += text("<font color='[]'>Health: []% ([])</font><BR>",			(occupant.get_damage() < 50 ?"blue" : "red"), (occupant.death_threshold - occupant.get_damage())/occupant.death_threshold*100, t1)
		dat += text("<font color='[]'>- Respiratory Damage: []%</font><BR>",(occupant.dam.suffocation < 60 ?"blue" : "red"), occupant.dam.suffocation)
		dat += text("<font color='[]'>- Toxin Content: []%</font><BR>",		(occupant.dam.toxin < 60 ?"blue" : "red"), occupant.dam.toxin)
		dat += text("<font color='[]'>- Burn Severity: []%</font><BR>",		(occupant.dam.burn < 60 ?"blue" : "red"), occupant.dam.burn)
		dat += text("<font color='blue'>Expected time until occupant may safely awake: [] second\s", occupant.knockdown)
	dat += text("<BR><BR><A href='?src=\ref[];mach_close=sleeper'>Close</A>", user)
	ss13_browse(user, dat, "window=sleeper;size=400x500")

/obj/machinery/computer/sleep_console/Topic(href, href_list)
	if(!..()) return
	usr.machine = src
	if(href_list["rejuv"])
		if(src.connected)
			src.connected.inject(usr)
	if(href_list["refresh"])
		src.updateUsrDialog()

/obj/machinery/computer/sleep_console/process()
	src.updateDialog()

/obj/machinery/computer/sleep_console/power_change()
	return	//	no change - sleeper works without power