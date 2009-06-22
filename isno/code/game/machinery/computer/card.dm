/obj/machinery/computer/card/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
		return
	if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
		return
	spawn(rand(0, 15))
		src.icon_state = "id_unpowered"
		stat |= NOPOWER

/obj/machinery/computer/card/interact(var/mob/user as mob)
	if(!..())	return 0
	user.machine = src

	if(src.mode) // accessing crew manifest
		var/crew = ""
		for(var/datum/data/record/t in data_core.general)
			crew += "[t.fields["name"]] - [t.fields["job"]]<br>"
		var/dat = {"<tt><b>Crew Manifest:</b><br>
					Please use security record computer to modify entries.<br>
					[crew]<a href='?src=\ref[src];print=1'>Print</a><br>
					<br>
					<a href='?src=\ref[src];mode=0'>Access ID modification console.</a></tt><br>"}
		ss13_browse(user, dat, "window=id_com;size=700x375")
		return

	var/header = {"<b>Identification Card Modifier</b><br>
				   <i>Please insert the cards into the slots</i><br>"}

	var/target_name = "--------"
	var/target_job = "--------"
	var/target_owner= "Unassigned"

	if(src.modify)
		target_name = src.modify.name
		if(src.modify.assignment)	target_job = src.modify.assignment
		if(src.modify.registered)	target_owner = src.modify.registered

	header += "Target: <a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

	var/scan_name
	if(src.scan)	scan_name = src.scan.name
	else			scan_name = "--------"

	header += "Confirm Identity: <a href='?src=\ref[src];scan=1'>[scan_name]</a><br><hr>"

	var/body = "<a href='?src=\ref[src];auth=1'>{Log in}</a>"
	if(src.authenticated && src.modify)
		var/jobs = ""
		var/access = ""
		var/carddesc = "Registered: <a href='?src=\ref[src];reg=1'>[target_owner]</a><br>Assignment: [target_job]"
		for(var/datum/job/j in get_all_job_instances())
			if(!j.switchable_to)
				continue
			jobs += "<a href='?src=\ref[src];assign=\ref[j]'>[dd_replacetext(j.name, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job
		for(var/A in get_all_accesses())
			if(A in src.modify.access)
				access += "<a href='?src=\ref[src];access=[A];allowed=0'><font color=\"red\">[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
			else
				access += "<a href='?src=\ref[src];access=[A];allowed=1'>[dd_replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
		body = "[carddesc]<br>[jobs]<br><br>[access]"

	var/dat = "<tt>[header][body]<hr><a href='?src=\ref[src];mode=1'>Access Crew Manifest</a><br></tt>"
	ss13_browse(user, dat, "window=id_com;size=700x375")
	return

/obj/machinery/computer/card/Topic(href, href_list)
	if(!..())	return 0

	usr.machine = src
	var/mob/carbon/M = usr
	if(href_list["modify"])
		if(src.modify)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
			src.modify.loc = src.loc
			src.modify = null
		else if(istype(M, /mob/carbon))
			var/obj/item/I = M.equipped()
			if(istype(I, /obj/item/weapon/card/id))
				M.drop_item()
				I.loc = src
				src.modify = I
		src.authenticated = 0

	if(href_list["scan"])
		if(src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else if(istype(M, /mob/carbon))
			var/obj/item/I = M.equipped()
			if(istype(I, /obj/item/weapon/card/id))
				M.drop_item()
				I.loc = src
				src.scan = I
		src.authenticated = 0

	if(href_list["auth"])
		if(!src.authenticated)
			if(istype(usr,/mob/silicon/ai) || src.scan)
				if(src.modify || src.mode)
					src.authenticated = 1

	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses())
				src.modify.access -= access_type
				if(access_allowed == 1) src.modify.access += access_type

	if(href_list["assign"])
		if(src.authenticated)
			var/datum/job/j = locate(href_list["assign"])
			var/name = j.name
			if(j.get_access() == null) // custom job
				name = sanitize(input("Enter a custom job assignment.","Assignment"))
			else
				var/list/L = j.get_access()
				src.modify.access = L.Copy()
			src.modify.assignment = name

	if(href_list["reg"])
		if(src.authenticated)
			var/t2 = src.modify
			var/t1 = sanitize(input(usr, "What name?", "ID computer", null) as text)
			if((src.authenticated && src.modify == t2 && (get_dist(src, usr) <= 1 || (istype(usr, /mob/silicon/ai))) && istype(src.loc, /turf)))
				src.modify.registered = t1

	if(href_list["mode"])
		src.mode = text2num(href_list["mode"])

	if(href_list["print"])
		if(!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["job"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null

	if(href_list["mode"])
		src.authenticated = 0
		src.mode = text2num(href_list["mode"])

	if(src.modify)
		if(src.modify.registered)
			src.modify.name = text("[]'s ID Card ([])", src.modify.registered, src.modify.assignment)
		else
			src.modify.name = "Blank ID"

	src.updateUsrDialog()
	return

