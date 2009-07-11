/obj/machinery/computer/gasmonitor/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				src.stat |= BROKEN
				src.icon_state = "broken"
		if(3.0)
			if (prob(25))
				src.stat |= BROKEN
				src.icon_state = "broken"
		else
	return

/obj/machinery/computer/gasmonitor/New()
	spawn(5)
		for(var/obj/machinery/gas_sensor/G in machines)
			if(G.id == src.id)
				gs = G
				break
	..()
	return

/obj/machinery/computer/gasmonitor/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)
	src.updateDialog()
	return

/obj/machinery/computer/gasmonitor/Topic(href, href_list)
	if(!..())
		return 0
	usr.machine = src
	if(href_list["close"])
		ss13_browse(usr, null, "window=computer")
	return 1

/obj/machinery/computer/gasmonitor/interact(var/mob/user as mob)
	if(!..())
		return 0
	user.machine = src
	var/dat = "<B>Gas Monitor - [tag ? tag : ""]</B><HR>"

	if(gs)
		dat += "[gs.sense_string()]<BR>\n"
	else
		dat += "No sensor found.<BR>\n"

	dat += "<A href='?src=\ref[user];mach_close=computer'>Close</A>"
	ss13_browse(user, dat, "window=computer;size=400x500")
	return 1


/obj/machinery/computer/gasmonitor/attackby(var/obj/O, mob/user)
	return src.interact(user)

/obj/machinery/computer/gasmonitor/engine/New()
	if (!engine_eject_control)
		engine_eject_control = new /datum/engine_eject(  )
	..()
	return

/obj/machinery/computer/gasmonitor/engine/interact(var/mob/user as mob)
	if(!..())
		return
	user.machine = src
	var/dat
	if (src.temp)
		dat = "<TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>"
	else
		if (engine_eject_control.status == 0)

			dat = "<B>Engine Gas Monitor</B><HR>"
			if(gs)
				dat += "[gs.sense_string()]<BR>\n"

			else
				dat += "No sensor found.<BR>\n"


			dat += "<BR><B>Engine Ejection Module</B><HR>\nStatus: Docked<BR>\n<BR>\nCountdown: [engine_eject_control.timeleft]/60 <A href='?src=\ref[src];reset=1'>\[Reset\]</A><BR>\n<BR>\n<A href='?src=\ref[src];eject=1'>Eject Engine</A><BR>\n<BR>\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"
		else
			if (engine_eject_control.status == 1)
				dat = text("<B>Engine Ejection Module</B><HR>\nStatus: Ejecting<BR>\n<BR>\nCountdown: []/60 \[Reset\]<BR>\n<BR>\n<A href='?src=\ref[];stop=1'>Stop Ejection</A><BR>\n<BR>\n<A href='?src=\ref[];mach_close=computer'>Close</A>", engine_eject_control.timeleft, src, user)
			else
				dat = text("<B>Engine Ejection Module</B><HR>\nStatus: Ejected<BR>\n<BR>\nCountdown: N/60 \[Reset\]<BR>\n<BR>\nEngine Ejected!<BR>\n<BR>\n<A href='?src=\ref[];mach_close=computer'>Close</A>", user)
	ss13_browse(user, dat, "window=computer;size=400x500")
	return

/obj/machinery/computer/gasmonitor/engine/Topic(href, href_list)
	if(!..())
		return
	usr.machine = src

	if (href_list["eject"])
		if (engine_eject_control.status == 0)
			src.temp = "Eject Engine?<BR><BR><B><A href='?src=\ref[src];eject2=1'>\[Swipe ID to initiate eject sequence\]</A></B><BR><A href='?src=\ref[src];temp=1'>Cancel</A>"

	else if (href_list["eject2"])
		if(!istype(usr, /mob/carbon))
			return
		var/mob/carbon/M = usr
		var/obj/item/weapon/card/id/I = M.equipped()
		if (istype(I))
			if(src.check_access(I))
				if (engine_eject_control.status == 0)
					engine_eject_control.ejectstart()
					src.temp = null
			else
				usr << "\red Access Denied."
	else if (href_list["stop"])
		if (engine_eject_control.status > 0)
			src.temp = text("Stop Ejection?<BR><BR><A href='?src=\ref[];stop2=1'>Yes</A><BR><A href='?src=\ref[];temp=1'>No</A>", src, src)

	else if (href_list["stop2"])
		if (engine_eject_control.status > 0)
			engine_eject_control.stopcount()
			src.temp = null

	else if (href_list["reset"])
		if (engine_eject_control.status == 0)
			engine_eject_control.resetcount()

	else if (href_list["temp"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/turf/station/engine/interact(var/mob/user as mob)

	if ((!( user.canmove ) || user.is_handcuffed() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/station/engine/floor/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ReplaceWithSpace()
			src.levelupdate()
		if(2.0)
			if (prob(50))
				src.ReplaceWithSpace()
				src.levelupdate()
	return

/turf/station/engine/floor/blob_act()
	return

/datum/engine_eject/proc/ejectstart()
	if (!src.status)
		if (src.timeleft <= 0)
			src.timeleft = 60
		station_announce("<B>Alert: Ejection sequence for engine module has been engaged.</B>")
		station_announce("<B>Ejection in [src.timeleft] seconds!</B>")
		src.resetting = 0

		var/list/EA = engine_areas()

		for(var/area/A in EA)
			A.eject = 1
			A.updateicon()

		src.status = 1
		for(var/obj/machinery/computer/gasmonitor/engine/E in machines)
			E.icon_state = "engaging"
		spawn( 0 )
			src.countdown()
			return
	return

/datum/engine_eject/proc/resetcount()
	if (!src.status)
		src.resetting = 1
	sleep(50)
	if (src.resetting)
		src.timeleft = 60
		station_announce("<B>Alert: Ejection sequence countdown for engine module has been reset.</B>")
	return

/datum/engine_eject/proc/countdone()
	src.status = -1.0

	var/list/E = engine_areas()

	var/list/engineturfs = list()
	for(var/area/EA in E)
		EA.eject = 0
		EA.updateicon()
		for(var/turf/ET in EA)
			engineturfs += ET

	defer_powernet_rebuild = 1
	for(var/turf/T in engineturfs)
		var/turf/S = new T.type( locate(T.x, T.y, ENGINE_EJECT_Z) )

		var/area/A = T.loc

		for(var/atom/movable/AM as mob|obj in T)
			AM.loc = S
			S.match_gasses(T)
			S.buildlinks()

		A.contents += S
		var/turf/P = new T.type( locate(T.x, T.y, T.z) )
		var/area/D = locate(/area/dummy)
		D.contents += P


		del(T)
		P.buildlinks()
	defer_powernet_rebuild = 0
	makepowernets()
	station_announce("<B>Engine Ejected!</B>")
	for(var/obj/machinery/computer/gasmonitor/engine/CE in machines)
		CE.icon_state = "engaged"
	return

/datum/engine_eject/proc/stopcount()
	if (src.status > 0)
		src.status = 0
		station_announce("<B>Alert: Ejection sequence for engine module has been disengaged!</B>")

		var/list/E = engine_areas()

		for(var/area/A in E)
			A.eject = 0
			A.updateicon()

		for(var/obj/machinery/computer/gasmonitor/engine/CE in machines)
			CE.icon_state = null
	return

/datum/engine_eject/proc/countdown()
	if (src.timeleft <= 0)
		spawn( 0 )
			countdone()
			return
		return
	if (src.status > 0)
		src.timeleft--
		if ((src.timeleft <= 15 || src.timeleft == 30))
			station_announce("<B>[src.timeleft] seconds until engine ejection.</B>")
		spawn( 10 )
			src.countdown()
			return
	return


//returns a list of areas that are under /area/engine
/datum/engine_eject/proc/engine_areas()
	var/list/L = list()
	for(var/area/A in world)
		if(istype(A, /area/engine))
			L += A
	return L


/obj/machinery/gas_sensor/proc/sense_string()

	var/t = ""

	var/turf/T = src.loc

	var/turf_total = T.gas.total()

	var/t1 = add_tspace("[round(turf_total / CELLSTANDARD * 100, 0.1)]%",6)
	t += "<PRE>Pressure: [t1] Temperature: [round(T.gas.temp - T0C,0.1)]&deg;C<BR>"

	if(turf_total == 0)
		t+="O2: 0 N2: 0 CO2: 0><BR>Plasma: 0 N20: 0"
	else
		t1 = add_tspace(round(T.gas.oxygen/turf_total * 100, 0.1),5)

		t += "O2: [t1] "

		t1 = add_tspace(round(T.gas.nitrogen/turf_total * 100, 0.1),5)

		t += "N2: [t1] "

		t1 = add_tspace(round(T.gas.co2/turf_total * 100, 0.01),5)

		t += "CO2: [t1]<BR>"

		t1 = add_tspace(round(T.gas.plasma/turf_total * 100, 0.001),5)

		t += "Plasma: [t1] "

		t1 = add_tspace(round(T.gas.no2/turf_total * 100, 0.001),5)

		t += "N2O: [t1]"

	t += "</PRE>"

	return t
