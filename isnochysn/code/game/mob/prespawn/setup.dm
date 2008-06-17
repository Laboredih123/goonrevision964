/mob/prespawn/var
	most_recent_changelog //md5 hash of /var/changes - easiest way ot tell if they've seen this changelog before or not
	//assumes that you never roll back to an earlier version or switch between two parallel ones

	const/SAVEFILE_EXTENSION = "ss13.sav"

/mob/prespawn/proc/setup()



// loads the savefile corresponding to the ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did not exist

/mob/prespawn/proc/savefile_load(var/silent = 1)
	if (fexists("players/[src.ckey].[SAVEFILE_EXTENSION]"))
		var/savefile/F = new /savefile( text("players/[].sav", src.ckey) )
		var/test = null
		F["version"] >> test
		if (test != savefile_ver)
			fdel(text("players/[].sav", src.ckey))
			if(!silent)
				alert("Your savefile was incompatible with this version and was deleted.")
			return 1
		F["rname"] >> src.rname
		F["gender"] >> src.gender
		F["age"] >> src.age
		F["occupation1"] >> src.occupation1
		F["occupation2"] >> src.occupation2
		F["occupation3"] >> src.occupation3
		F["nr_hair"] >> src.nr_hair
		F["ng_hair"] >> src.ng_hair
		F["nb_hair"] >> src.nb_hair
		F["ns_tone"] >> src.ns_tone
		F["h_style"] >> src.h_style
		F["h_style_r"] >> src.h_style_r
		F["r_eyes"] >> src.r_eyes
		F["g_eyes"] >> src.g_eyes
		F["b_eyes"] >> src.b_eyes
		F["b_type"] >> src.b_type
		F["need_gl"] >> src.need_gl
		F["be_epil"] >> src.be_epil
		F["be_tur"] >> src.be_tur
		F["be_cough"] >> src.be_cough
		F["be_stut"] >> src.be_stut
		return 1
	else
		return 0



/mob/prespawn/Topic(href, href_list)

	if ((src == usr && !( src.start )))
		if (findtext(href, "occ", 1, null))
			if (findtext(href, "cancel", 1, null))
				usr << browse(null, text("window=\ref[]occupation", src))
				return
			if (!( findtext(href, "job", 1, null) ))
				src.SetChoices(text2num(href_list["occ"]))
			else
				src.SetJob(arglist(list("occ" = text2num(href_list["occ"]), "job" = href_list["job"])))
		else if (findtext(href, "rname", 1, null))
			var/t1 = href_list["rname"]
			if (t1 == "input")
				t1 = input("Please select a name:", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				if (length(t1) >= 26)
					t1 = copytext(t1, 1, 26)
				t1 = dd_replacetext(t1, ">", "'")
				src.rname = t1
		else if (findtext(href, "age", 1, null))
			var/t1 = href_list["age"]
			if (t1 == "input")
				t1 = input("Please select type in age: 20-45", "Character Generation", null, null)  as num
			if ((!( src.start ) && t1))
				src.age = max(min(round(text2num(t1)), 45), 20)
		else if (findtext(href, "b_type", 1, null))
			var/t1 = href_list["b_type"]
			if (t1 == "input")
				t1 = input("Please select a blood type:", "Character Generation", null, null)  as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )
			if ((!( src.start ) && t1))
				src.b_type = t1
		else if (findtext(href, "nr_hair", 1, null))
			var/t1 = href_list["nr_hair"]
			if (t1 == "input")
				t1 = input("Please select red hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nr_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "ng_hair", 1, null))
			var/t1 = href_list["ng_hair"]
			if (t1 == "input")
				t1 = input("Please select green hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.ng_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "nb_hair", 1, null))
			var/t1 = href_list["nb_hair"]
			if (t1 == "input")
				t1 = input("Please select blue hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nb_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "r_eyes", 1, null))
			var/t1 = href_list["r_eyes"]
			if (t1 == "input")
				t1 = input("Please select red eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.r_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "ns_tone", 1, null))
			var/t1 = href_list["ns_tone"]
			if (t1 == "input")
				t1 = input("Please select skin tone level: 1-220 (1=albino,35=caucasian, 150=black220='very' black)", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.ns_tone = max(min(round(text2num(t1)), 220), 1)
				src.ns_tone =  -src.ns_tone + 35
		else if (findtext(href, "g_eyes", 1, null))
			var/t1 = href_list["g_eyes"]
			if (t1 == "input")
				t1 = input("Please select green eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.g_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "b_eyes", 1, null))
			var/t1 = href_list["b_eyes"]
			if (t1 == "input")
				t1 = input("Please select blue eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.b_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "h_style", 1, null))
			var/t1 = href_list["h_style"]
			if (t1 == "input")
				t1 = input("Please select hair style", "Character Generation", null, null)  as null|anything in list( "Cut Hair", "Short Hair (M)", "Long Hair (F)", "Bald" )
			if ((!( src.start ) && t1))
				src.h_style = t1
				switch(t1)
					if("Short Hair (M)")
						src.h_style_r = "hair_a"
					if("Long Hair (F)")
						src.h_style_r = "hair_b"
					if("Cut Hair")
						src.h_style_r = "hair_c"
					else
						src.h_style_r = "bald"
		else if (findtext(href, "gender", 1, null))
			if (src.gender == "male")
				src.gender = "female"
			else
				src.gender = "male"
			src.stand_icon = new /icon( 'human.dmi', text("[]", src.gender) )
			src.lying_icon = new /icon( 'human.dmi', text("[]-d", src.gender) )
		else if (findtext(href, "n_gl", 1, null))
			src.need_gl = !( src.need_gl )
		else if (findtext(href, "b_ep", 1, null))
			src.be_epil = !( src.be_epil )
		else if (findtext(href, "b_tur", 1, null))
			src.be_tur = !( src.be_tur )
		else if (findtext(href, "b_co", 1, null))
			src.be_cough = !( src.be_cough )
		else if (findtext(href, "b_stut", 1, null))
			src.be_stut = !( src.be_stut )
		else if (findtext(href, "save", 1, null))
			var/savefile/F = new /savefile( text("players/[].sav", src.ckey) )
			F["version"] << savefile_ver
			F["rname"] << src.rname
			F["gender"] << src.gender
			F["age"] << src.age
			F["occupation1"] << src.occupation1
			F["occupation2"] << src.occupation2
			F["occupation3"] << src.occupation3
			F["nr_hair"] << src.nr_hair
			F["ng_hair"] << src.ng_hair
			F["nb_hair"] << src.nb_hair
			F["ns_tone"] << src.ns_tone
			F["h_style"] << src.h_style
			F["h_style_r"] << src.h_style_r
			F["r_eyes"] << src.r_eyes
			F["g_eyes"] << src.g_eyes
			F["b_eyes"] << src.b_eyes
			F["b_type"] << src.b_type
			F["need_gl"] << src.need_gl
			F["be_epil"] << src.be_epil
			F["be_tur"] << src.be_tur
			F["be_cough"] << src.be_cough
			F["be_stut"] << src.be_stut
		else if (findtext(href, "load", 1, null))
			if (!src.savefile_load(0))
				alert("You do not have a savefile.")

		else if (findtext(href, "reset_all", 1, null))

			rname = key
			gender = MALE
			age = 30
			occupation1 = "No Preference"
			occupation2 = "No Preference"
			occupation3 = "No Preference"
			need_gl = 0
			be_epil = 0
			be_cough = 0
			be_tur = 0
			be_stut = 0
			r_hair = 0.0
			g_hair = 0.0
			b_hair = 0.0
			h_style = "Short Hair (M)"
			nr_hair = 0.0
			ng_hair = 0.0
			nb_hair = 0.0
			ns_tone = 0.0
			r_eyes = 0.0
			g_eyes = 0.0
			b_eyes = 0.0
			s_tone = 0.0
			b_type = "A+"


		if(!href_list["priv_msg"])
			src.ShowChoices()

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)
	if ((href_list["item"] && !( usr.stat ) && usr.canmove && !( usr.restrained() ) && get_dist(src, usr) <= 1))
		var/obj/equip_e/human/O = new /obj/equip_e/human(  )
		O.source = usr
		O.target = src
		O.item = usr.equipped()
		O.s_loc = usr.loc
		O.t_loc = src.loc
		O.place = href_list["item"]
		src.requests += O
		spawn( 0 )
			O.process()
			return
	..()
	return