/obj/machinery/computer/security/New()
	..()
	if(!maplevel)
		src.verbs -= /obj/machinery/computer/security/verb/station_map

/obj/machinery/computer/security/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)
	return

/obj/machinery/computer/security/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/security/check_eye(var/mob/user as mob)

	if ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded || !( src.current ) || !( src.current.status )) && (!istype(user, /mob/ai)))
		return null
	user.reset_view(src.current)
	return 1
	return


/obj/machinery/computer/meteorhit(var/obj/O as obj)

	for(var/x in src.verbs)
		src.verbs -= x
		//Foreach goto(17)
	src.icon_state = "broken"
	stat |= BROKEN
	return

/obj/machinery/computer/communications/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(58)
				src.icon_state = "broken"
				stat |= BROKEN
		if(3.0)
			if (prob(25))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(109)
				src.icon_state = "broken"
				stat |= BROKEN
		else
	return

/obj/machinery/computer/blob_act()
	if (prob(50))
		for(var/x in src.verbs)
			src.verbs -= x
					//Foreach goto(58)
		src.icon_state = "broken"
		src.stat |= BROKEN
		src.density = 0

/obj/machinery/computer/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "c_unpowered"
				stat |= NOPOWER


/obj/machinery/computer/process()

	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)


/obj/machinery/computer/communications/verb/call_shuttle()
	set src in oview(1)
	src.add_fingerprint(usr)
	if(stat & NOPOWER) return
	call_shuttle_proc(usr)

/mob/ai/proc/ai_alerts()
	set category = "AI Commands"
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=aialerts'>Close</A><BR><BR>"
	for (var/cat in src.alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/L = src.alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/C = alm[2]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				if (C && istype(C, /list))
					var/dat2 = ""
					for (var/obj/machinery/camera/I in C)
						dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (dat2=="") ? "" : " | ", src, I, I.c_tag)
					dat += text("-- [] ([])", A.name, (dat2!="") ? dat2 : "No Camera")
				else if (C && istype(C, /obj/machinery/camera))
					var/obj/machinery/camera/Ctmp = C
					dat += text("-- [] (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", A.name, src, C, Ctmp.c_tag)
				else
					dat += text("-- [] (No Camera)", A.name)
				if (sources.len > 1)
					dat += text("- [] sources", sources.len)
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	src.viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

/mob/ai/proc/ai_camera_list()
	set category = "AI Commands"
	set name = "Show Camera List"

	attack_ai(src)

/mob/ai/proc/ai_camera_track()
	set category = "AI Commands"
	set name = "Track With Camera"

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/mob/M in world)
		if (istype(M, /mob/human) && istype(M:wear_id, /obj/item/weapon/card/id/syndicate))
			continue
		if(!istype(M.loc, /turf)) //in a closet or something, AI can't see him anyways
			continue
		else if (M == usr)
			continue

		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = text("[] ([])", name, namecounts[name])
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M

	var/target_name = input(usr, "Which creature should you track?") as null|anything in creatures

	if (!target_name)
		usr << "Nothing is trackable."
		return

	var/mob/target = creatures[target_name]

	usr:cameraFollow = target
	usr << text("Now tracking [] on camera.", target.name)
	if (usr.machine == null)
		usr.machine = usr

	spawn (0)
		while (usr:cameraFollow == target)
			if (usr.machine == null)
				usr:cameraFollow = null
				usr << "Follow camera mode ended."
				return
			else if (istype(target, /mob/human) && istype(target:wear_id, /obj/item/weapon/card/id/syndicate))
				usr << "Follow camera mode ended."
				usr:cameraFollow = null
				return
			else if (!istype(target.loc, /turf)) //in a closet
				usr << "Target is not on or near any active cameras on the station. We'll check again in 30 seconds (unless you use the cancel-camera verb)."
				sleep(290) //because we're sleeping another second after this (a few lines down)
				continue

			var/obj/machinery/camera/C = usr:current
			if ((C && istype(C, /obj/machinery/camera)) || C==null)

				var/closestDist = -1
				if (C!=null)
					if (C.status)
						closestDist = get_dist(C, target)
				//usr << text("Dist = [] for camera []", closestDist, C.name)
				var/zmatched = 0
				if (closestDist > 7 || closestDist == -1)
					//check other cameras
					var/obj/machinery/camera/closest = C
					for(var/obj/machinery/camera/C2 in world)
						if (C2.network == src.network)
							if (C2.z == target.z)
								zmatched = 1
								if (C2.status)
									var/dist = get_dist(C2, target)
									if ((dist < closestDist) || (closestDist == -1))
										closestDist = dist
										closest = C2
					//usr << text("Closest camera dist = [], for camera []", closestDist, closest.area.name)

					if (closest != C)
						usr:current = closest
						usr.reset_view(closest)
						//use_power(50)
					if (zmatched == 0)
						usr << "Target is not on or near any active cameras on the station. We'll check again in 30 seconds (unless you use the cancel-camera verb)."
						sleep(290) //because we're sleeping another second after this (a few lines down)
			else
				usr << "Follow camera mode ended."
				usr:cameraFollow = null

			sleep(10)

/mob/ai/proc/ai_call_shuttle()
	set category = "AI Commands"
	set name = "Call Emergency Shuttle"
	call_shuttle_proc(src)
	return

/proc/call_shuttle_proc(var/mob/user)
	if ((!( ticker ) || ticker.shuttle_location == 1))
		return

	if( ticker.mode == "blob" )
		user << "Under directive 7-10, SS13 is quarantined until further notice."
		return

	if (!( ticker.timeleft ))
		ticker.timeleft = shuttle_time_to_arrive
	world << "\blue <B>Alert: The emergency shuttle has been called. It will arrive in [ticker.timeleft/600] minutes.</B>"
	ticker.timing = 1
	return

/obj/machinery/computer/communications/verb/cancel_call()
	set src in oview(1)
	src.add_fingerprint(usr)
	if(stat & NOPOWER) return
	cancel_call_proc(usr)

/proc/cancel_call_proc(var/mob/user)
	if ((!( ticker ) || ticker.shuttle_location == 1 || ticker.timing == 0 || ticker.timeleft < 300))
		return
	if( ticker.mode == "blob" )
		return

	world << "\blue <B>Alert: The shuttle is going back!</B>"
	ticker.timing = -1.0

	return
/*
/mob/ai/proc/ai_cancel_call()
	set category = "AI Commands"
	cancel_call_proc(src)
	return
*/

/obj/machinery/computer/card/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(58)
				src.icon_state = "broken"
				stat |= BROKEN
		if(3.0)
			if (prob(25))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(109)
				src.icon_state = "broken"
				stat |= BROKEN
		else
	return

/obj/machinery/computer/card/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "id_unpowered"
				stat |= NOPOWER

/obj/machinery/computer/card/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/card/attack_hand(var/mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br>[crew]<a href='?src=\ref[src];print=1'>Print</a><br><br><a href='?src=\ref[src];mode=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<b>Identification Card Modifier</b><br><i>Please insert the cards into the slots</i><br>"

		var/target_name
		var/target_owner
		var/target_rank
		if(src.modify)
			target_name = src.modify.name
		else
			target_name = "--------"
		if(src.modify && src.modify.registered)
			target_owner = src.modify.registered
		else
			target_owner = "--------"
		if(src.modify && src.modify.assignment)
			target_rank = src.modify.assignment
		else
			target_rank = "Unassigned"
		header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

		var/scan_name
		if(src.scan)
			scan_name = src.scan.name
		else
			scan_name = "--------"
		header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br>"
		header += "<hr>"
		var/body
		if (src.authenticated && src.modify)
			var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_rank]"
			var/list/alljobs = get_all_jobs() + "Custom"
			var/jobs = ""
			for(var/job in alljobs)
				jobs += "<a href='?src=\ref[src];assign=[job]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
			var/accesses = ""
			for(var/A in get_all_accesses())
				if(A in src.modify.access)
					accesses += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
				else
					accesses += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			body = "[carddesc]<br>[jobs]<br><br>[accesses]"
		else
			body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
		dat = "<tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	user << browse(dat, "window=id_com;size=700x375")
	return

/obj/machinery/computer/card/Topic(href, href_list)
	..()
	if(stat & (NOPOWER|BROKEN))
		usr << browse(null, "window=id_com")
		return
	if(usr.restrained() || usr.lying) return

	if ((!( istype(usr, /mob/human) ) && (!( ticker ) || (ticker && ticker.mode != "monkey"))))
		if (!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
			return
	if ((usr.stat || usr.restrained()))
		return
	if ((get_dist(src, usr) > 1 || !istype(src.loc, /turf)) && !istype(usr, /mob/ai))
		usr << browse(null, "window=id_com")
		return
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0
	if (href_list["scan"])
		if (src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (istype(usr, /mob/ai))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
		else if ((!( src.authenticated ) && (istype(usr, /mob/ai))) && (!src.modify))
			usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type
	if (href_list["assign"])
		if (src.authenticated)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				t1 = input("Enter a custom job assignment.","Assignment")
			else
				src.modify.access = get_access(t1)
			src.modify.assignment = t1
	if (href_list["reg"])
		if (src.authenticated)
			var/t2 = src.modify
			var/t1 = input(usr, "What name?", "ID computer", null)  as text
			if ((src.authenticated && src.modify == t2 && (get_dist(src, usr) <= 1 || (istype(usr, /mob/ai))) && istype(src.loc, /turf)))
				src.modify.registered = t1
	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])
	if (src.modify)
		src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
	src.updateUsrDialog()

	src.add_fingerprint(usr)

	return

/obj/machinery/computer/card/attackby(I as obj, user as mob)

	src.attack_hand(user)
	return

/obj/machinery/computer/pod/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(58)
				src.icon_state = "broken"
				stat |= BROKEN
		if(3.0)
			if (prob(25))
				for(var/x in src.verbs)
					src.verbs -= x
					//Foreach goto(109)
				src.icon_state = "broken"
				stat |= BROKEN
		else
	return

/obj/machinery/computer/pod/proc/alarm()

	if(stat & (NOPOWER|BROKEN)) return

	if (!( src.connected ))
		viewers(null, null) << "Cannot locate mass driver connector. Cancelling firing sequence!"
		return
	for(var/obj/machinery/door/poddoor/M in machines)
		if (M.id == src.id)
			spawn( 0 )
				M.openpod()
				return
		//Foreach goto(41)
	sleep(20)

	//src.connected.drive()		*****RM from 40.93.3S
	for(var/obj/machinery/mass_driver/M in machines)
		if(M.id == src.id)
			M.power = src.connected.power
			M.drive()

	//*****
	sleep(50)
	for(var/obj/machinery/door/poddoor/M in machines)
		if (M.id == src.id)
			spawn( 0 )
				M.closepod()
				return
		//Foreach goto(123)
	return

/obj/machinery/computer/pod/New()

	..()
	spawn( 5 )
		for(var/obj/machinery/mass_driver/M in machines)
			if (M.id == src.id)
				src.connected = M
			else
				//Foreach continue //goto(25)
		return
	return

/obj/machinery/computer/pod/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/pod/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/pod/attack_hand(var/mob/user as mob)

	if(stat & (NOPOWER|BROKEN)) return

	var/dat = "<HTML><BODY><TT><B>Mass Driver Controls</B>"
	user.machine = src
	var/d2
	if (src.timing)
		d2 = text("<A href='?src=\ref[];time=0'>Stop Time Launch</A>", src)
	else
		d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Launch</A>", src)
	var/second = src.time % 60
	var/minute = (src.time - second) / 60
	dat += text("<HR>\nTimer System: []\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>", d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
	if (src.connected)
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if (t == src.connected.power)
				temp += text("[] ", t)
			else
				temp += text("<A href = '?src=\ref[];power=[]'>[]</A> ", src, t, t)
			//Foreach goto(172)
		dat += text("<HR>\nPower Level: []<BR>\n<A href = '?src=\ref[];alarm=1'>Firing Sequence</A><BR>\n<A href = '?src=\ref[];drive=1'>Test Fire Driver</A><BR>\n<A href = '?src=\ref[];door=1'>Toggle Outer Door</A><BR>", temp, src, src, src)
	//*****RM from 40.93.3S
	else
		dat += text("<BR>\n<A href = '?src=\ref[];door=1'>Toggle Outer Door</A><BR>", src)
	//*****
	dat += text("<BR><BR><A href='?src=\ref[];mach_close=computer'>Close</A></TT></BODY></HTML>", user)
	user << browse(dat, "window=computer;size=400x500")
	return

/obj/machinery/computer/pod/process()


	if(stat & (NOPOWER|BROKEN) )
		return
	use_power(250)

	if (src.timing)
		if (src.time > 0)
			src.time = round(src.time) - 1
		else
			alarm()
			src.time = 0
			src.timing = 0
		src.updateDialog()

	return

/obj/machinery/computer/pod/Topic(href, href_list)
	..()

	if(stat & (NOPOWER|BROKEN))
		usr << browse(null, "window=computer")
		return


	if(usr.restrained() || usr.lying) return

	if ((!( istype(usr, /mob/human) ) && (!( ticker ) || (ticker && ticker.mode != "monkey"))))
		if (!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
			return
	if ((usr.stat || usr.restrained()))
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["power"])
			var/t = text2num(href_list["power"])
			t = min(max(0.25, t), 16)
			if (src.connected)
				src.connected.power = t
		else
			if (href_list["alarm"])
				src.alarm()
			else
				if (href_list["time"])
					src.timing = text2num(href_list["time"])
				else
					if (href_list["tp"])
						var/tp = text2num(href_list["tp"])
						src.time += tp
						src.time = min(max(round(src.time), 0), 120)
					else
						if (href_list["door"])
							for(var/obj/machinery/door/poddoor/M in machines)
								if (M.id == src.id)
									if (M.density)
										spawn( 0 )
											M.openpod()
											return
									else
										spawn( 0 )
											M.closepod()
											return
								//Foreach goto(298)
		src.add_fingerprint(usr)
		src.updateUsrDialog()

	return

/obj/machinery/door/poddoor/open()

	usr << "This is a remote controlled door!"
	return

/obj/machinery/door/poddoor/close()

	usr << "This is a remote controlled door!"
	return

/obj/machinery/door/poddoor/attackby(obj/item/weapon/C as obj, mob/user as mob)

	src.add_fingerprint(user)
	if (!( istype(C, /obj/item/weapon/crowbar) ))
		return
	if ((src.density && (stat & NOPOWER) && !( src.operating )))
		spawn( 0 )
			src.operating = 1
			flick("pdoorc0", src)
			src.icon_state = "pdoor0"
			sleep(15)
			src.density = 0
			src.opacity = 0
			var/turf/T = src.loc
			if (istype(T, /turf))
				T.updatecell = 1
				T.buildlinks()
			src.operating = 0
			return
	return

/obj/machinery/door/poddoor/proc/openpod()
	set src in oview(1)

	if(stat & NOPOWER) return

	if (src.operating || !src.density)
		return
	src.operating = 1
	use_power(50)
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(15)
	src.density = 0
	src.opacity = 0
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.updatecell = 1
		T.buildlinks()
	src.operating = 0
	return

/obj/machinery/door/poddoor/proc/closepod()
	set src in oview(1)

	if(stat & NOPOWER) return

	if (src.operating || src.density)
		return
	use_power(50)
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1
	src.opacity = 1
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.updatecell = 0
		T.buildlinks()
	sleep(15)
	src.operating = 0
	return

/obj/datacore/proc/manifest()

	for(var/mob/human/H in world)
		if ((H.start && !( findtext(H.rname, "Syndicate ", 1, null) )))
			var/datum/data/record/G = new /datum/data/record(  )
			var/datum/data/record/M = new /datum/data/record(  )
			var/datum/data/record/S = new /datum/data/record(  )
			var/obj/item/weapon/card/id/C = H.wear_id
			if (C)
				G.fields["rank"] = C.assignment
			else
				G.fields["rank"] = "Unassigned"
			G.fields["name"] = H.rname
			G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
			M.fields["name"] = G.fields["name"]
			M.fields["id"] = G.fields["id"]
			S.fields["name"] = G.fields["name"]
			S.fields["id"] = G.fields["id"]
			if (H.gender == "female")
				G.fields["sex"] = "Female"
			else
				G.fields["sex"] = "Male"
			G.fields["age"] = text("[]", H.age)
			G.fields["fingerprint"] = text("[]", md5(H.primary.uni_identity))
			G.fields["p_stat"] = "Active"
			G.fields["m_stat"] = "Stable"
			M.fields["b_type"] = text("[]", H.b_type)
			M.fields["mi_dis"] = "None"
			M.fields["mi_dis_d"] = "No minor disabilities have been declared."
			M.fields["ma_dis"] = "None"
			M.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
			M.fields["alg"] = "None"
			M.fields["alg_d"] = "No allergies have been detected in this patient."
			M.fields["cdi"] = "None"
			M.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
			M.fields["notes"] = "No notes."
			S.fields["criminal"] = "None"
			S.fields["mi_crim"] = "None"
			S.fields["mi_crim_d"] = "No minor crime convictions."
			S.fields["ma_crim"] = "None"
			S.fields["ma_crim_d"] = "No minor crime convictions."
			S.fields["notes"] = "No notes."
			src.general += G
			src.medical += M
			src.security += S
		//Foreach goto(15)
	return

/turf/space/attack_paw(mob/user as mob)

	return src.attack_hand(user)
	return

/turf/space/attack_hand(mob/user as mob)

	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/weapon/tile/T as obj, mob/user as mob)

	if (istype(T, /obj/item/weapon/tile))
		T.build(src)
		T.amount--
		T.add_fingerprint(user)
		if (T.amount < 1)
			user.u_equip(T)
			//SN src = null
			del(T)
			return
	return

/turf/space/updatecell()

	return

/turf/space/conduction()
	return

/turf/space/Entered(atom/movable/A as mob|obj)

	..()
	if ((!(A) || src != A.loc || istype(null, /obj/beam)))
		return

	if (!(A.last_move))
		return

	if (locate(/obj/move, src))
		return 1

	if ((ismob(A) && src.x > 2 && src.x < (world.maxx - 1)))
		var/mob/M = A

		if ((!( M.restrained()) && M.canmove))
			var/prob_slip = 5

			if (locate(/obj/grille, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 2
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 1

				if (!( M.r_hand ))
					prob_slip -= 2
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 1
			else if (locate(/obj/move/wall, oview(1, M)) || locate(/turf/station, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 1
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 0.5

				if (!( M.r_hand ))
					prob_slip -= 1
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 0.5
			prob_slip = round(prob_slip)
			if (prob_slip < 5) //next to something, but they might slip off
				if (prob(prob_slip))
					M << "\blue <B>You slipped!</B>"
					M.inertia_dir = M.last_move
					step(M, M.inertia_dir)
					return
				else
					M.inertia_dir = 0 //no inertia
			else //not by a wall or anything, they just keep going
				spawn(5)
					if ((A && !( A.anchored ) && A.loc == src))
						if(M.inertia_dir) //they keep moving the same direction
							step(M, M.inertia_dir)
						else
							M.inertia_dir = M.last_move
							step(M, M.inertia_dir)
		else //can't move, they just keep going (COPY PASTED CODE WOO)
			spawn(5)
				if ((A && !( A.anchored ) && A.loc == src))
					if(M.inertia_dir) //they keep moving the same direction
						step(M, M.inertia_dir)
					else
						M.inertia_dir = M.last_move
						step(M, M.inertia_dir)
	if (src.x <= 2 && src.z < world.maxz)
		A.z++
		A.x = world.maxx - 2
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)
	else if (A.x >= (world.maxx - 1) && A.z > 1)
		A.z--
		A.x = 3
		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)

/obj/machinery/mass_driver/proc/drive(amount)
	if(stat & NOPOWER)
		return

	use_power(500)
	for(var/atom/movable/O in src.loc)
		if(!O.anchored)
			spawn( 0 )
				var/atom/targetarea = locate(src.x, src.y, src.z)
				//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
				//and isn't really any more complicated
				if(src.dir & NORTH)
					targetarea = locate(targetarea.x, world.maxy, targetarea.z)
				if(src.dir & SOUTH)
					targetarea = locate(targetarea.x, 1, targetarea.z)
				if(src.dir & EAST)
					targetarea = locate(world.maxx, targetarea.y, targetarea.z)
				if(src.dir & WEST)
					targetarea = locate(1, targetarea.y, targetarea.z)
				O.throw_at(targetarea, drive_range * src.power, src.power)
	flick("mass_driver1", src)
	return


