/obj/machinery/computer/secure_data/interact(mob/user as mob)
	if(!..()) return 0

	if(src.temp)
		var/dat = 	"<TT><HEAD><TITLE>Security Records</TITLE></HEAD></TT><BR>"
		dat += text("<TT>[src.temp]</TT><BR><A href='?src=\ref[src];temp=1'>Back</A>")
		ss13_browse(user, dat, "window=secure_rec")
		return 1

	var/dat = text("Confirm Identity: <A href='?src=\ref[];scan=1'>[]</A><HR>", src, (src.scan ? text("[]", src.scan.name) : "----------"))
	if(!src.authenticated)
		dat += text("<A href='?src=\ref[];login=1'>{Log In}</A>", src)
		ss13_browse(user, text("<HEAD><TITLE>Security Records</TITLE></HEAD><TT>[]</TT>", dat), "window=secure_rec")
		return 1

	switch(src.screen)
		if(1)
			dat += text({"<A href='?src=\ref[src];search=1'>Search Records</A><BR>
						  <A href='?src=\ref[src];search_f=1'>Search Fingerprints</A><BR>
						  <A href='?src=\ref[src];rec_m=1'>Records Maintenance</A><BR>
						  <A href='?src=\ref[src];list=1'>List Records</A><BR>
						  <A href='?src=\ref[src];new_r=1'>New Record</A><BR>
						  <BR>
						  <A href='?src=\ref[src];logout=1'>{Log Out}</A><BR>"})
		if(2)
			dat += "<B>Record List</B>:<HR>"
			for(var/datum/data/record/R in data_core.general)
				dat += text("<A href='?src=\ref[];d_rec=\ref[]'>[]: []<BR>", src, R, R.fields["id"], R.fields["name"])
			dat += text("<HR><A href='?src=\ref[];main=1'>Back</A>", src)
		if(3)
			dat += text({"<B>Records Maintenance</B><HR>
						  <A href='?src=\ref[src];back=1'>Backup To Disk</A><BR>
						  <A href='?src=\ref[src];u_load=1'>Upload From Disk</A><BR>
						  <A href='?src=\ref[src];del_all=1'>Delete All Records</A><BR>
						  <BR>
						  <A href='?src=\ref[src];main=1'>Back</A>"})
		if(4)
			dat += "<CENTER><B>Security Record</B></CENTER><BR>"
			if((istype(src.active1, /datum/data/record) && data_core.general.Find(src.active1)))
				dat += text({"Name: <A href='?src=\ref[];field=name'>[]</A> ID: <A href='?src=\ref[];field=id'>[]</A><BR>
							  Sex: <A href='?src=\ref[];field=sex'>[]</A><BR>
							  job: <A href='?src=\ref[];field=job'>[]</A><BR>
							  Fingerprint: <A href='?src=\ref[];field=fingerprint'>[]</A><BR>
							  Physical Status: []<BR>
							  Mental Status: []<BR>"},
							  src, src.active1.fields["name"],	src, src.active1.fields["id"],
							  src, src.active1.fields["sex"],	src, src.active1.fields["job"],
							  src, src.active1.fields["fingerprint"],
							  src.active1.fields["p_stat"],
							  src.active1.fields["m_stat"])
			else
				dat += "<B>General Record Lost!</B><BR>"
			if((istype(src.active2, /datum/data/record) && data_core.security.Find(src.active2)))
				dat += text({"<BR><CENTER><B>Security Data</B></CENTER><BR>
							  Criminal Status: <A href='?src=\ref[];field=criminal'>[]</A><BR><BR>
							  Minor Crimes: <A href='?src=\ref[];field=mi_crim'>[]</A><BR>
							  Details: <A href='?src=\ref[];field=mi_crim_d'>[]</A><BR><BR>
							  Major Crimes: <A href='?src=\ref[];field=ma_crim'>[]</A><BR>
							  Details: <A href='?src=\ref[];field=ma_crim_d'>[]</A><BR><BR>
							  Important Notes:<BR>
							  <A href='?src=\ref[];field=notes'>[]</A><BR><BR>
							  <CENTER><B>Comments/Log</B></CENTER><BR>"},
							  src, src.active2.fields["criminal"],	src, src.active2.fields["mi_crim"],
							  src, src.active2.fields["mi_crim_d"],	src, src.active2.fields["ma_crim"],
							  src, src.active2.fields["ma_crim_d"],	src, src.active2.fields["notes"])
				var/counter = 1
				while(src.active2.fields[text("com_[]", counter)])
					dat += text("[]<BR><A href='?src=\ref[];del_c=[]'>Delete Entry</A><BR><BR>", src.active2.fields[text("com_[]", counter)], src, counter)
					counter++
				dat += text("<A href='?src=\ref[];add_c=1'>Add Entry</A><BR><BR>", src)
				dat += text("<A href='?src=\ref[];del_r=1'>Delete Record (Security Only)</A><BR><BR>", src)
			else
				dat += "<B>Security Record Lost!</B><BR>"
				dat += text("<A href='?src=\ref[];new=1'>New Record</A><BR><BR>", src)
			dat += text({"\n<A href='?src=\ref[src];dela_r=1'>Delete Record (ALL)</A><BR><BR>
							<A href='?src=\ref[src];print_p=1'>Print Record</A><BR>
							<A href='?src=\ref[src];list=1'>Back</A><BR>"})

	ss13_browse(user, text("<HEAD><TITLE>Security Records</TITLE></HEAD><TT>[]</TT>", dat), "window=secure_rec")
	return

/obj/machinery/computer/secure_data/Topic(href, href_list)
	if(!..()) return 0
	if(!data_core.general.Find(src.active1))	src.active1 = null
	if(!data_core.security.Find(src.active2))	src.active2 = null

	usr.machine = src
	if(href_list["temp"])	src.temp = null
	if(href_list["scan"])
		if(src.scan)
			src.scan.loc = src.loc
			src.scan = null
		else if(istype(usr, /mob/carbon))
			var/obj/item/I = usr:equipped()
			if(istype(I, /obj/item/weapon/card/id))
				usr:drop_item()
				I.loc = src
				src.scan = I
	else if(href_list["logout"])
		src.screen = null
		src.active1 = null
		src.active2 = null
		src.authenticated = null
	else if(href_list["login"])
		if(istype(usr, /mob/silicon/ai))
			src.job = "AI"
			src.screen = 1
			src.active1 = null
			src.active2 = null
			src.can_change_id = 1
			src.authenticated = 1
		else if(istype(src.scan, /obj/item/weapon/card/id))
			src.active1 = null
			src.active2 = null
			if(src.check_access(src.scan))
				src.screen = 1
				src.job = src.scan.assignment
				src.authenticated = src.scan.registered
				if(access_change_ids in src.scan.access)
					src.can_change_id = 1

	src.add_fingerprint(usr)
	if(!src.authenticated)
		src.updateUsrDialog()
		return 1

	if(href_list["list"])
		src.screen = 2
		src.active1 = null
		src.active2 = null
	else if(href_list["rec_m"])
		src.screen = 3
		src.active1 = null
		src.active2 = null
	else if(href_list["del_all"])
		src.temp = text("Are you sure you wish to delete all records?<br>\n\t<A href='?src=\ref[];temp=1;del_all2=1'>Yes</A><br>\n\t<A href='?src=\ref[];temp=1'>No</A><br>", src, src)
	else if(href_list["del_all2"])
		for(var/datum/data/record/R in data_core.security)
			del(R)
		src.temp = "All records deleted."
	else if(href_list["main"])
		src.screen = 1
		src.active1 = null
		src.active2 = null
	else if(href_list["field"])
		var/a1 = src.active1
		var/a2 = src.active2
		switch(href_list["field"])
			if("name")
				if(istype(src.active1, /datum/data/record))
					var/t1 = input("Please input name:", "Secure. records", src.active1.fields["name"], null)  as text
					if(t1 && a1 == src.active1) src.active1.fields["name"] = t1
			if("id")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please input id:", "Secure. records", src.active1.fields["id"], null)  as text
					if(t1 && a1 == src.active1) src.active1.fields["id"] = t1
			if("fingerprint")
				if(istype(src.active1, /datum/data/record))
					var/t1 = input("Please input fingerprint hash:", "Secure. records", src.active1.fields["fingerprint"], null)  as text
					if(t1 && a1 == src.active1) src.active1.fields["fingerprint"] = t1
			if("sex")
				if(istype(src.active1, /datum/data/record))
					if(src.active1.fields["sex"] == "Male")
						src.active1.fields["sex"] = "Female"
					else
						src.active1.fields["sex"] = "Male"
			if("mi_crim")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please input minor disabilities list:", "Secure. records", src.active2.fields["mi_crim"], null)  as text
					if(t1 && a2 == src.active2) src.active2.fields["mi_crim"] = t1
			if("mi_crim_d")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please summarize minor dis.:", "Secure. records", src.active2.fields["mi_crim_d"], null)  as message
					if(t1 && a2 == src.active2) src.active2.fields["mi_crim_d"] = t1
			if("ma_crim")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please input major diabilities list:", "Secure. records", src.active2.fields["ma_crim"], null)  as text
					if(t1 && a2 == src.active2) src.active2.fields["ma_crim"] = t1
			if("ma_crim_d")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please summarize major dis.:", "Secure. records", src.active2.fields["ma_crim_d"], null)  as message
					if(t1 && a2 == src.active2) src.active2.fields["ma_crim_d"] = t1
			if("notes")
				if(istype(src.active2, /datum/data/record))
					var/t1 = input("Please summarize notes:", "Secure. records", src.active2.fields["notes"], null)  as message
					if(t1 && a2 == src.active2) src.active2.fields["notes"] = t1
			if("criminal")
				if(istype(src.active2, /datum/data/record))
					src.temp = text("<B>Criminal Status:</B><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=none'>None</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=arrest'>*Arrest*</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=incarcerated'>Incarcerated</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=parolled'>Parolled</A><BR>\n\t<A href='?src=\ref[];temp=1;criminal2=released'>Released</A><BR>", src, src, src, src, src)
			if("job")
				if(istype(src.active1, /datum/data/record) && src.can_change_id)
					src.temp = "<B>job:</B><BR>\n"
					var/list/alljobs = get_all_job_instances()
					for(var/job in alljobs)
						src.temp += "<A HREF='?src=\ref[src];temp=1;job=[job]'>[dd_replacetext(job, " ", "&nbsp")]</A><BR>\n"
			else
	else if(href_list["job"])
		if(src.can_change_id)
			src.active1.fields["job"] = href_list["job"]
	else if(href_list["criminal2"])
		if(src.active2)
			switch(href_list["criminal2"])
				if("none")				src.active2.fields["criminal"] = "None"
				if("arrest")			src.active2.fields["criminal"] = "*Arrest*"
				if("incarcerated")		src.active2.fields["criminal"] = "Incarcerated"
				if("parolled")			src.active2.fields["criminal"] = "Parolled"
				if("released")			src.active2.fields["criminal"] = "Released"

	else if(href_list["del_r"])
		if(src.active2)
			src.temp = text({"Are you sure you wish to delete the record (Security Portion Only)?<br>
							  <A href='?src=\ref[src];temp=1;del_r2=1'>Yes</A><br>
							  <A href='?src=\ref[src];temp=1'>No</A><br>"})
	else if(href_list["del_r2"])
		if(src.active2)
			del(src.active2)
	else if(href_list["dela_r"])
		if(src.active1)
			src.temp = text({"Are you sure you wish to delete the record (ALL)?<br>
							  <A href='?src=\ref[src];temp=1;dela_r2=1'>Yes</A><br>
							  <A href='?src=\ref[src];temp=1'>No</A><br>"})
	else if(href_list["dela_r2"])
		for(var/datum/data/record/R in data_core.medical)
			if((R.fields["name"] == src.active1.fields["name"] || R.fields["id"] == src.active1.fields["id"]))
				del(R)
		if(src.active2)	del(src.active2)
		if(src.active1)	del(src.active1)
	else if(href_list["d_rec"])
		var/datum/data/record/R = locate(href_list["d_rec"])
		var/S = locate(href_list["d_rec"])
		if(!data_core.general.Find(R))
			src.temp = "Record Not Found!"
			return 1
		for(var/datum/data/record/E in data_core.security)
			if((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
				S = E
		src.active1 = R
		src.active2 = S
		src.screen = 4
	else if(href_list["new_r"])
		var/datum/data/record/G = new /datum/data/record()
		G.fields["name"]	= "New Record"
		G.fields["id"]		= text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
		G.fields["job"]	= "Unassigned"
		G.fields["sex"]		= "Male"
		G.fields["fingerprint"]	= "Unknown"
		G.fields["p_stat"]	= "Active"
		G.fields["m_stat"]	= "Stable"
		data_core.general += G
		src.active1 = G
		src.active2 = null
	else if(href_list["new"])
		if((istype(src.active1, /datum/data/record) && !( istype(src.active2, /datum/data/record))))
			var/datum/data/record/R = new /datum/data/record(  )
			R.name = text("Security Record #[]", R.fields["id"])
			R.fields["name"]		= src.active1.fields["name"]
			R.fields["id"]			= src.active1.fields["id"]
			R.fields["criminal"]	= "None"
			R.fields["mi_crim"]		= "None"
			R.fields["mi_crim_d"]	= "No minor crime convictions."
			R.fields["ma_crim"]		= "None"
			R.fields["ma_crim_d"]	= "No minor crime convictions."
			R.fields["notes"]		= "No notes."
			data_core.security += R
			src.active2 = R
			src.screen = 4
	else if(href_list["add_c"])
		if(!( istype(src.active2, /datum/data/record)))
			return 1
		var/a2 = src.active2
		var/t1 = input("Add Comment:", "Secure. records", null, null)  as message
		if(!t1 || a2 != src.active2) return 1
		var/counter = 1
		while(src.active2.fields[text("com_[]", counter)]) counter++
		src.active2.fields[text("com_[]", counter)] = text("Made by [] ([]) on [], 2053<BR>[]", src.authenticated, src.job, time2text(world.realtime, "DDD MMM DD hh:mm:ss"), t1)
	else if(href_list["del_c"])
		if((istype(src.active2, /datum/data/record) && src.active2.fields[text("com_[]", href_list["del_c"])]))
			src.active2.fields[text("com_[]", href_list["del_c"])] = "<B>Deleted</B>"
	else if(href_list["search_f"])
		var/t1 = input("Search String: (Fingerprint)", "Secure. records", null, null)  as text
		if(!t1) return 1
		src.active1 = null
		src.active2 = null
		t1 = lowertext(t1)
		for(var/datum/data/record/R in data_core.general)
			if(lowertext(R.fields["fingerprint"]) == t1)
				src.active1 = R
		if(!src.active1)
			src.temp = text("Could not locate record [].", t1)
		else
			for(var/datum/data/record/E in data_core.security)
				if((E.fields["name"] == src.active1.fields["name"] || E.fields["id"] == src.active1.fields["id"]))
					src.active2 = E
			src.screen = 4
	else if(href_list["search"])
		var/t1 = input("Search String: (Name or ID)", "Secure. records", null, null)  as text
		if(!t1) return 1
		src.active1 = null
		src.active2 = null
		t1 = lowertext(t1)
		for(var/datum/data/record/R in data_core.general)
			if((lowertext(R.fields["name"]) == t1 || t1 == lowertext(R.fields["id"])))
				src.active1 = R
		if(!src.active1)
			src.temp = text("Could not locate record [].", t1)
		else
			for(var/datum/data/record/E in data_core.security)
				if((E.fields["name"] == src.active1.fields["name"] || E.fields["id"] == src.active1.fields["id"]))
					src.active2 = E
			src.screen = 4
	else if(href_list["print_p"])
		if(!src.printing)
			src.printing = 1
			sleep(50)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
			P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
			if((istype(src.active1, /datum/data/record) && data_core.general.Find(src.active1)))
				P.info += text("Name: [] ID: []<BR>\nSex: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src.active1.fields["name"], src.active1.fields["id"], src.active1.fields["sex"], src.active1.fields["fingerprint"], src.active1.fields["p_stat"], src.active1.fields["m_stat"])
			else
				P.info += "<B>General Record Lost!</B><BR>"
			if((istype(src.active2, /datum/data/record) && data_core.security.Find(src.active2)))
				P.info += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: []<BR>\n<BR>\nMinor Crimes: []<BR>\nDetails: []<BR>\n<BR>\nMajor Crimes: []<BR>\nDetails: []<BR>\n<BR>\nImportant Notes:<BR>\n\t[]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", src.active2.fields["criminal"], src.active2.fields["mi_crim"], src.active2.fields["mi_crim_d"], src.active2.fields["ma_crim"], src.active2.fields["ma_crim_d"], src.active2.fields["notes"])
				var/counter = 1
				while(src.active2.fields[text("com_[]", counter)])
					P.info += text("[]<BR>", src.active2.fields[text("com_[]", counter)])
					counter++
			else
				P.info += "<B>Security Record Lost!</B><BR>"
			P.info += "</TT>"
			P.name = "paper- 'Security Record - [src.active1.fields["name"]]'"
			src.printing = null

	src.updateUsrDialog()
	return 1
