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

/mob/ai/proc/ai_camera_track()
	set category = "AI Commands"
	set name = "Track With Camera"

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/mob/M in world)
		if (istype(M, /mob/human) && istype(M:wear_id, /obj/item/weapon/card/id/syndicate))
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

	world << "\blue <B>Alert: The emergency shuttle has been called. It will arrive in T-10:00 minutes.</B>"
	if (!( ticker.timeleft ))
		ticker.timeleft = 6000
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
	return

/obj/machinery/computer/card/attack_hand(var/mob/user as mob)

	if(stat & (NOPOWER|BROKEN) ) return

	user.machine = src
	var/dat
	if (!( ticker ))
		return
	if (src.mode)
		var/d2 = text("Confirm Identity: <A href='?src=\ref[];scan=1'>[]</A>\n[]", src, (src.scan ? text("[]", src.scan.name) : "----------"), (src.authenticated ? "You are logged in!" : text("<A href='?src=\ref[];auth=1'>{Log in}</A>", src)))
		var/d1 = "Please use security Records to modify entries.<BR>"
		for(var/datum/data/record/t in data_core.general)
			d1 += text("[] - []<BR>", t.fields["name"], t.fields["rank"])
			//Foreach goto(104)
		dat = text("<HTML><HEAD></HEAD><BODY><TT>[]<BR>\n<BR>\n<B>Crew Manifest:</B><BR>\n[]\n<BR>\n<A href='?src=\ref[];print=1'>Print</A><BR>\n<BR>\n<A href='?src=\ref[];mode=0'>Access ID modification console.</A><BR>\n</TT></BODY></HTML>", d2, d1, src, src)
	else
		var/d1 = text("<A href='?src=\ref[];auth=1'>{Log in}</A>", src)
		if ((src.authenticated && src.modify))
			var/vo = null
			var/va = null
			var/vl = null
			var/ve = null
			switch(src.modify.access_level)
				if(1.0)
					vo = text("<A href='?src=\ref[];vo=-1'>0</A> 1 <A href='?src=\ref[];vo=2'>2</A> <A href='?src=\ref[];vo=3'>3</A> <A href='?src=\ref[];vo=4'>4</A> <A href='?src=\ref[];vo=5'>5</A>", src, src, src, src, src)
				if(2.0)
					vo = text("<A href='?src=\ref[];vo=-1'>0</A> <A href='?src=\ref[];vo=1'>1</A> 2 <A href='?src=\ref[];vo=3'>3</A> <A href='?src=\ref[];vo=4'>4</A> <A href='?src=\ref[];vo=5'>5</A>", src, src, src, src, src)
				if(3.0)
					vo = text("<A href='?src=\ref[];vo=-1'>0</A> <A href='?src=\ref[];vo=1'>1</A> <A href='?src=\ref[];vo=2'>2</A> 3 <A href='?src=\ref[];vo=4'>4</A> <A href='?src=\ref[];vo=5'>5</A>", src, src, src, src, src)
				if(4.0)
					vo = text("<A href='?src=\ref[];vo=-1'>0</A> <A href='?src=\ref[];vo=1'>1</A> <A href='?src=\ref[];vo=2'>2</A> <A href='?src=\ref[];vo=3'>3</A> 4 <A href='?src=\ref[];vo=5'>5</A>", src, src, src, src, src)
				if(5.0)
					vo = text("<A href='?src=\ref[];vo=-1'>0</A> <A href='?src=\ref[];vo=1'>1</A> <A href='?src=\ref[];vo=2'>2</A> <A href='?src=\ref[];vo=3'>3</A> <A href='?src=\ref[];vo=4'>4</A> 5", src, src, src, src, src)
				else
					vo = text("0 <A href='?src=\ref[];vo=1'>1</A> <A href='?src=\ref[];vo=2'>2</A> <A href='?src=\ref[];vo=3'>3</A> <A href='?src=\ref[];vo=4'>4</A> <A href='?src=\ref[];vo=5'>5</A>", src, src, src, src, src)
			switch(src.modify.lab_access)
				if(1.0)
					vl = text("<A href='?src=\ref[];vl=-1'>0</A> 1 <A href='?src=\ref[];vl=2'>2</A> <A href='?src=\ref[];vl=3'>3</A> <A href='?src=\ref[];vl=4'>4</A> <A href='?src=\ref[];vl=5'>5</A>", src, src, src, src, src)
				if(2.0)
					vl = text("<A href='?src=\ref[];vl=-1'>0</A> <A href='?src=\ref[];vl=1'>1</A> 2 <A href='?src=\ref[];vl=3'>3</A> <A href='?src=\ref[];vl=4'>4</A> <A href='?src=\ref[];vl=5'>5</A>", src, src, src, src, src)
				if(3.0)
					vl = text("<A href='?src=\ref[];vl=-1'>0</A> <A href='?src=\ref[];vl=1'>1</A> <A href='?src=\ref[];vl=2'>2</A> 3 <A href='?src=\ref[];vl=4'>4</A> <A href='?src=\ref[];vl=5'>5</A>", src, src, src, src, src)
				if(4.0)
					vl = text("<A href='?src=\ref[];vl=-1'>0</A> <A href='?src=\ref[];vl=1'>1</A> <A href='?src=\ref[];vl=2'>2</A> <A href='?src=\ref[];vl=3'>3</A> 4 <A href='?src=\ref[];vl=5'>5</A>", src, src, src, src, src)
				if(5.0)
					vl = text("<A href='?src=\ref[];vl=-1'>0</A> <A href='?src=\ref[];vl=1'>1</A> <A href='?src=\ref[];vl=2'>2</A> <A href='?src=\ref[];vl=3'>3</A> <A href='?src=\ref[];vl=4'>4</A> 5", src, src, src, src, src)
				else
					vl = text("0 <A href='?src=\ref[];vl=1'>1</A> <A href='?src=\ref[];vl=2'>2</A> <A href='?src=\ref[];vl=3'>3</A> <A href='?src=\ref[];vl=4'>4</A> <A href='?src=\ref[];vl=5'>5</A>", src, src, src, src, src)
			switch(src.modify.engine_access)
				if(1.0)
					ve = text("<A href='?src=\ref[];ve=-1'>0</A> 1 <A href='?src=\ref[];ve=2'>2</A> <A href='?src=\ref[];ve=3'>3</A> <A href='?src=\ref[];ve=4'>4</A> <A href='?src=\ref[];ve=5'>5</A>", src, src, src, src, src)
				if(2.0)
					ve = text("<A href='?src=\ref[];ve=-1'>0</A> <A href='?src=\ref[];ve=1'>1</A> 2 <A href='?src=\ref[];ve=3'>3</A> <A href='?src=\ref[];ve=4'>4</A> <A href='?src=\ref[];ve=5'>5</A>", src, src, src, src, src)
				if(3.0)
					ve = text("<A href='?src=\ref[];ve=-1'>0</A> <A href='?src=\ref[];ve=1'>1</A> <A href='?src=\ref[];ve=2'>2</A> 3 <A href='?src=\ref[];ve=4'>4</A> <A href='?src=\ref[];ve=5'>5</A>", src, src, src, src, src)
				if(4.0)
					ve = text("<A href='?src=\ref[];ve=-1'>0</A> <A href='?src=\ref[];ve=1'>1</A> <A href='?src=\ref[];ve=2'>2</A> <A href='?src=\ref[];ve=3'>3</A> 4 <A href='?src=\ref[];ve=5'>5</A>", src, src, src, src, src)
				if(5.0)
					ve = text("<A href='?src=\ref[];ve=-1'>0</A> <A href='?src=\ref[];ve=1'>1</A> <A href='?src=\ref[];ve=2'>2</A> <A href='?src=\ref[];ve=3'>3</A> <A href='?src=\ref[];ve=4'>4</A> 5", src, src, src, src, src)
				else
					ve = text("0 <A href='?src=\ref[];ve=1'>1</A> <A href='?src=\ref[];ve=2'>2</A> <A href='?src=\ref[];ve=3'>3</A> <A href='?src=\ref[];ve=4'>4</A> <A href='?src=\ref[];ve=5'>5</A>", src, src, src, src, src)
			switch(src.modify.air_access)
				if(1.0)
					va = text("<A href='?src=\ref[];va=-1'>0</A> 1 <A href='?src=\ref[];va=2'>2</A> <A href='?src=\ref[];va=3'>3</A> <A href='?src=\ref[];va=4'>4</A> <A href='?src=\ref[];va=5'>5</A>", src, src, src, src, src)
				if(2.0)
					va = text("<A href='?src=\ref[];va=-1'>0</A> <A href='?src=\ref[];va=1'>1</A> 2 <A href='?src=\ref[];va=3'>3</A> <A href='?src=\ref[];va=4'>4</A> <A href='?src=\ref[];va=5'>5</A>", src, src, src, src, src)
				if(3.0)
					va = text("<A href='?src=\ref[];va=-1'>0</A> <A href='?src=\ref[];va=1'>1</A> <A href='?src=\ref[];va=2'>2</A> 3 <A href='?src=\ref[];va=4'>4</A> <A href='?src=\ref[];va=5'>5</A>", src, src, src, src, src)
				if(4.0)
					va = text("<A href='?src=\ref[];va=-1'>0</A> <A href='?src=\ref[];va=1'>1</A> <A href='?src=\ref[];va=2'>2</A> <A href='?src=\ref[];va=3'>3</A> 4 <A href='?src=\ref[];va=5'>5</A>", src, src, src, src, src)
				if(5.0)
					va = text("<A href='?src=\ref[];va=-1'>0</A> <A href='?src=\ref[];va=1'>1</A> <A href='?src=\ref[];va=2'>2</A> <A href='?src=\ref[];va=3'>3</A> <A href='?src=\ref[];va=4'>4</A> 5", src, src, src, src, src)
				else
					va = text("0 <A href='?src=\ref[];va=1'>1</A> <A href='?src=\ref[];va=2'>2</A> <A href='?src=\ref[];va=3'>3</A> <A href='?src=\ref[];va=4'>4</A> <A href='?src=\ref[];va=5'>5</A>", src, src, src, src, src)
			var/list/L = list( "Research Assistant", "Staff Assistant", "Medical Assistant", "Technical Assistant", "Engineer", "Forensic Technician", "Research Technician", "Medical Doctor", "Captain", "Security Officer", "Medical Researcher", "Toxin Researcher", "Head of Research", "Head of Personnel", "Station Technician", "Atmospheric Technician", "Unassigned", "Systems", "Custom" )
			var/assign = ""
			if (istype(user, /mob/human) || istype(user, /mob/ai))
				var/counter = 1
				for(var/t in L)
					assign += text("<A href='?src=\ref[];assign=[]'>[]</A>  ", src, t, t)
					counter++
					if (counter >= 3)
						assign += "<BR>"
						counter = 1
					//Foreach goto(912)
				d1 = text("[] :<BR>\nGeneral Access Level: []<BR>\nLaboratory Access: []<BR>\nReactor/Engine Access: []<BR>\nMain Systems Access: []<BR>\nRegistered: <A href='?src=\ref[];reg=1'>[]</A><BR>\nAssignment: []<BR>\n[]<BR>", src.modify.name, vo, vl, ve, va, src, (src.modify.registered ? text("[]", src.modify.registered) : "{None: Click to modify}"), (src.modify.assignment ? text("[]", src.modify.assignment) : "None"), assign)
			else
				var/counter = 1
				for(var/t in L)
					assign += text("<A href='?src=\ref[];assign=[]'>[]</A>  ", src, t, stars(t))
					counter++
					if (counter >= 4)
						assign += "<BR>"
						counter = 1
					//Foreach goto(1057)
				d1 = text("[] :<BR>\n[] []<BR>\n[] []<BR>\n[] []<BR>\n[] []<BR>\n[] <A href='?src=\ref[];reg=1'>[]</A><BR>\n[] []<BR>\n[]<BR>", stars("modify.name"), stars("General Access Level:"), vo, stars("Laboratory Access:"), vl, stars("Reactor/Engine Access:"), ve, stars("Main Systems Access:"), va, stars("Registered:"), src, (src.modify.registered ? text("[]", stars(src.modify.registered)) : text("[]", stars("{None: Click to modify}"))), stars("Assignment:"), (src.modify.assignment ? text("[]", stars(src.modify.assignment)) : "None"), assign)
		if (istype(user, /mob/human) || istype(user, /mob/ai))
			dat = text("<TT><B>Identification Card Modifier</B><BR>\n<I>Please Insert the cards into the slots</I><BR>\nTarget: <A href='?src=\ref[];modify=1'>[]</A><BR>\nConfirm Identity: <A href='?src=\ref[];scan=1'>[]</A><BR>\n-----------------<BR>\n[]<BR>\n<BR>\n<BR>\n<A href='?src=\ref[];mode=1'>Access Crew Manifest</A><BR>\n</TT>", src, (src.modify ? text("[]", src.modify.name) : "----------"), src, (src.scan ? text("[]", src.scan.name) : "----------"), d1, src)
		else
			dat = text("<TT><B>[]</B><BR>\n<I>[]</I><BR>\n[] <A href='?src=\ref[];modify=1'>[]</A><BR>\n[] <A href='?src=\ref[];scan=1'>[]</A><BR>\n-----------------<BR>\n[]<BR>\n<BR>\n<BR>\n<A href='?src=\ref[];mode=1'>[]</A><BR>\n</TT>", stars("Identification Card Modifier"), stars("Please Insert the cards into the slots"), stars("Target:"), src, (src.modify ? text("[]", stars(src.modify.name)) : "----------"), stars("Confirm Identity:"), src, (src.scan ? text("[]", stars(src.scan.name)) : "----------"), d1, src, stars("Access Crew Manifest"))
	user << browse(dat, "window=id_com;size=400x500")
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
	if ((get_dist(src, usr) <= 1 && istype(src.loc, /turf)) || (istype(usr, /mob/ai)))
		usr.machine = src
		if (href_list["modify"])
			if (src.modify)
				src.modify.name = text("[]'s ID Card ([]>[]-[]-[])", src.modify.registered, src.modify.access_level, src.modify.lab_access, src.modify.engine_access, src.modify.air_access)
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
				if (istype(usr, /mob/ai))
					src.authenticated = 1
				else
					if ((src.scan.assignment == "Captain" || src.scan.assignment == "Head of Personnel"))
						src.authenticated = 1
			else
				if ((!( src.authenticated ) && (istype(usr, /mob/ai))) && (!src.modify))
					usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."

		if (href_list["vo"])
			if (src.authenticated)
				var/t1 = text2num(href_list["vo"])
				if (t1 == -1.0)
					t1 = 0
				src.modify.access_level = t1
		if (href_list["vl"])
			if (src.authenticated)
				var/t1 = text2num(href_list["vl"])
				if (t1 == -1.0)
					t1 = 0
				src.modify.lab_access = t1
		if (href_list["ve"])
			if (src.authenticated)
				var/t1 = text2num(href_list["ve"])
				if (t1 == -1.0)
					t1 = 0
				src.modify.engine_access = t1
		if (href_list["va"])
			if (src.authenticated)
				var/t1 = text2num(href_list["va"])
				if (t1 == -1.0)
					t1 = 0
				src.modify.air_access = t1
		if (href_list["assign"])
			if (src.authenticated)
				var/t1 = href_list["assign"]

				if(t1 == "Custom")
					t1 = input("Enter a custom job assignment.","Assignment")

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
					t1 += text("<B>[]</B> - []<BR>", t.fields["name"], t.fields["rank"])
					//Foreach goto(868)
				P.info = text("[]", t1)
				P.name = "paper- 'Crew Manifest'"
				src.printing = null
		if (href_list["mode"])
			src.authenticated = 0
			src.mode = text2num(href_list["mode"])
		if (src.modify)
			src.modify.name = text("[]'s ID Card ([]>[]-[]-[])", src.modify.registered, src.modify.access_level, src.modify.lab_access, src.modify.engine_access, src.modify.air_access)
		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=id_com")
		return
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

	if ((ismob(A) && src.x > 2 && src.x < (world.maxx - 2)))
		var/mob/M = A

		if ((!( M.restrained()) && M.canmove))
			var/t1 = 5

			if (locate(/obj/grille, oview(1, M)))
				if (!( M.l_hand ))
					t1 -= 2
				else
					if (M.l_hand.w_class <= 2)
						t1 -= 1

				if (!( M.r_hand ))
					t1 -= 2
				else
					if (M.r_hand.w_class <= 2)
						t1 -= 1
			else if (locate(/obj/move/wall, oview(1, M)))
				if (!( M.l_hand ))
					t1 -= 1
				else
					if (M.l_hand.w_class <= 2)
						t1 -= 0.5
				if (!( M.r_hand ))
					t1 -= 1
				else
					if (M.r_hand.w_class <= 2)
						t1 -= 0.5
			else
				if (locate(/turf/station, oview(1, M)))
					if (!( M.l_hand ))
						t1 -= 1
					else
						if (M.l_hand.w_class <= 2)
							t1 -= 0.5
					if (!( M.r_hand ))
						t1 -= 1
					else
						if (M.r_hand.w_class <= 2)
							t1 -= 0.5
			t1 = round(t1)
			if (t1 < 5)
				if (prob(t1))
					M << "\blue <B>You slipped!</B>"
				else
					spawn( 5 )
						if (src == A.loc)
							spawn( 0 )
								src.Entered(A)
								return
						return
					return 0

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
	else
		spawn (5)
			if ((A && !( A.anchored ) && A.loc == src))
				if (step(A, A.last_move))
				else
					spawn( 0 )
						src.Entered(A)
