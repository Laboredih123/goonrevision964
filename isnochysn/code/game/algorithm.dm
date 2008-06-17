/world/New()

	..()
	spawn( 0 )
		SetupOccupationsList()
		return
	return

/mob/human/verb/char_setup()
	set name = "Character Setup"

	if (src.start)
		return
	src.ShowChoices()
	return

/mob/human/proc/ShowChoices()

	var/list/destructive = assistant_occupations.Copy()
	var/dat = "<html><body>"
	dat += text("<b>Name:</b> <a href=\"byond://?src=\ref[];rname=input\"><b>[]</b></a><br>", src, src.rname)
	dat += text("<b>Gender:</b> <a href=\"byond://?src=\ref[];gender=input\"><b>[]</b></a><br>", src, (src.gender == "male" ? "Male" : "Female"))
	dat += text("<b>Age</b> - <a href='byond://?src=\ref[];age=input'>[]</a><hr>", src, src.age)
	dat += "<hr><b>Occupation Choices</b>:<br>"
	if (destructive.Find(src.occupation1))
		dat += text("\t<a href=\"byond://?src=\ref[];occ=1\"><b>[]</b></a><br>", src, src.occupation1)
	else
		if (src.occupation1 != "No Preference")
			dat += text("\tFirst Choice: <a href=\"byond://?src=\ref[];occ=1\"><b>[]</b></a><br>", src, src.occupation1)
			if (destructive.Find(src.occupation2))
				dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\"><b>[]</b></a><BR>", src, src.occupation2)
			else
				if (src.occupation2 != "No Preference")
					dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\"><b>[]</b></a><BR>", src, src.occupation2)
					if (destructive.Find(src.occupation3))
						dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\"><b>[]</b></a><BR>", src, src.occupation3)
					else
						if (src.occupation3 != "No Preference")
							dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\"><b>[]</b></a><BR>", src, src.occupation3)
						else
							dat += text("\tLast Choice: <a href=\"byond://?src=\ref[];occ=3\">No Preference</a><br>", src)
				else
					dat += text("\tSecond Choice: <a href=\"byond://?src=\ref[];occ=2\">No Preference</a><br>", src)
		else
			dat += text("\t<a href=\"byond://?src=\ref[];occ=1\">No Preference</a><br>", src)
	dat += "<hr><b>Body Data</b><br>"
	dat += text("<b>Blood Type:</b> <a href='byond://?src=\ref[];b_type=input'>[]</a><br>", src, src.b_type)
	dat += text("<b>Skin Tone:</b> <a href='byond://?src=\ref[];ns_tone=input'>[]/220</a><br>", src,  -src.ns_tone + 35)
	dat += text("<b>Hair Color:</b> <font color=\"#[][][]\">test</font><br>", num2hex(src.nr_hair, 2), num2hex(src.ng_hair, 2), num2hex(src.nb_hair))
	dat += text(" <b><font color=\"#[]0000\">Red</font></b> - <a href='byond://?src=\ref[];nr_hair=input'>[]</a>", num2hex(src.nr_hair, 2), src, src.nr_hair)
	dat += text(" <b><font color=\"#00[]00\">Green</font></b> - <a href='byond://?src=\ref[];ng_hair=input'>[]</a>", num2hex(src.ng_hair, 2), src, src.ng_hair)
	dat += text(" <b><font color=\"#0000[]\">Blue</font></b> - <a href='byond://?src=\ref[];nb_hair=input'>[]</a>", num2hex(src.nb_hair, 2), src, src.nb_hair)
	dat += text("<br> <b>Style</b> - <a href='byond://?src=\ref[];h_style=input'>[]</a>", src, src.h_style)
	dat += text("<br><b>Eye Color:</b> <font color=\"#[][][]\">test</font><br>", num2hex(src.r_eyes, 2), num2hex(src.g_eyes, 2), num2hex(src.b_eyes, 2))
	dat += text(" <b><font color=\"#[]0000\">Red</font></b> - <a href='byond://?src=\ref[];r_eyes=input'>[]</a>", num2hex(src.r_eyes, 2), src, src.r_eyes)
	dat += text(" <b><font color=\"#00[]00\">Green</font></b> - <a href='byond://?src=\ref[];g_eyes=input'>[]</a>", num2hex(src.g_eyes, 2), src, src.g_eyes)
	dat += text(" <b><font color=\"#0000[]\">Blue</font></b> - <a href='byond://?src=\ref[];b_eyes=input'>[]</a>", num2hex(src.b_eyes, 2), src, src.b_eyes)
	dat += "<hr><b>Disabilities</b><br>"
	dat += "<hr><i>It is more than likely pretty fucking stupid to enable any of these.</i><br>"
	dat += text("Need Glasses: <a href=\"byond://?src=\ref[];n_gl=1\"><b>[]</b></a><br>", src, (src.need_gl ? "Yes" : "No"))
	dat += text("Epileptic: <a href=\"byond://?src=\ref[];b_ep=1\"><b>[]</b></a><br>", src, (src.be_epil ? "Yes" : "No"))
	dat += text("Tourette Syndrome: <a href=\"byond://?src=\ref[];b_tur=1\"><b>[]</b></a><br>", src, (src.be_tur ? "Yes" : "No"))
	dat += text("Chronic Cough: <a href=\"byond://?src=\ref[];b_co=1\"><b>[]</b></a><br>", src, (src.be_cough ? "Yes" : "No"))
	dat += text("Stutter: <a href=\"byond://?src=\ref[];b_stut=1\"><b>[]</b></a><br>", src, (src.be_stut ? "Yes" : "No"))
	dat += "<hr>"
	dat += text("<a href='byond://?src=\ref[];load=1'>Load Setup</a><br>", src)
	dat += text("<a href='byond://?src=\ref[];save=1'>Save Setup</a><br>", src)
	dat += text("<a href='byond://?src=\ref[];reset_all=1'>Reset Setup</a><br>", src)
	dat += "</body></html>"
	src << browse(dat, "window=mob_occupations;size=300x600")
	return

/mob/human/proc/SetChoices(occ)

	if (occ == null)
		occ = 1
	var/HTML = "<body>"
	HTML += "<tt><center>"
	switch(occ)
		if(1.0)
			HTML += "<b>Which occupation would you like most?</b><br><br>"
		if(2.0)
			HTML += "<b>Which occupation would you like if you couldn't have your first?</b><br><br>"
		if(3.0)
			HTML += "<b>Which occupation would you like if you couldn't have the others?</b><br><br>"
		else
	for(var/job in uniquelist(occupations + assistant_occupations) )
		if (job!="AI" || config.allow_ai)
			HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=[]\">[]</a><br>", src, occ, job, job)
		//Foreach goto(105)
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=Captain\">Captain</a><br>", src, occ)
	HTML += "<br>"
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];job=No Preference\">\[No Preference\]</a><br>", src, occ)
	HTML += text("<a href=\"byond://?src=\ref[];occ=[];cancel\">\[Cancel\]</a>", src, occ)
	HTML += "</center></tt>"
	usr << browse(HTML, "window=mob_occupation;size=320x500")
	return

/mob/human/proc/SetJob(occ, job)
	if (occ == null)
		occ = 1
	if (job == null)
		job = "Captain"
	if ((!( occupations.Find(job) ) && !( assistant_occupations.Find(job) ) && job != "Captain"))
		return
	if (job=="AI" && (!config.allow_ai))
		return
	switch(occ)
		if(1.0)
			if (job == src.occupation1)
				usr << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					src.occupation1 = "No Preference"
				else
					if (job == src.occupation2)
						job = src.occupation1
						src.occupation1 = src.occupation2
						src.occupation2 = job
					else
						if (job == src.occupation3)
							job = src.occupation1
							src.occupation1 = src.occupation3
							src.occupation3 = job
						else
							src.occupation1 = job
		if(2.0)
			if (job == src.occupation2)
				src << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					if (src.occupation3 != "No Preference")
						src.occupation2 = src.occupation3
						src.occupation3 = "No Preference"
					else
						src.occupation2 = "No Preference"
				else
					if (job == src.occupation1)
						if (src.occupation2 == "No Preference")
							src << browse(null, "window=mob_occupation")
							return
						job = src.occupation2
						src.occupation2 = src.occupation1
						src.occupation1 = job
					else
						if (job == src.occupation3)
							job = src.occupation2
							src.occupation2 = src.occupation3
							src.occupation3 = job
						else
							src.occupation2 = job
		if(3.0)
			if (job == src.occupation3)
				usr << browse(null, "window=mob_occupation")
				return
			else
				if (job == "No Preference")
					src.occupation3 = "No Preference"
				else
					if (job == src.occupation1)
						if (src.occupation3 == "No Preference")
							src << browse(null, "window=mob_occupation")
							return
						job = src.occupation3
						src.occupation3 = src.occupation1
						src.occupation1 = job
					else
						if (job == src.occupation2)
							if (src.occupation3 == "No Preference")
								src << browse(null, "window=mob_occupation")
								return
							job = src.occupation3
							src.occupation3 = src.occupation2
							src.occupation2 = job
						else
							src.occupation3 = job
		else
	src.ShowChoices()
	src << browse(null, "window=mob_occupation")
	return

/mob/human/var/const
	SLOT_BACK = 1
	SLOT_MASK = 2
	SLOT_HANDCUFFS = 3
	SLOT_L_HAND = 4
	SLOT_R_HAND = 5
	SLOT_BELT = 6
	SLOT_ID = 7
	SLOT_GLASSES = 8
	SLOT_GLOVES = 9
	SLOT_HELMET = 10
	SLOT_SHOES = 11
	SLOT_SUIT = 12
	SLOT_JUMPSUIT = 13
	SLOT_L_STORE = 14
	SLOT_R_STORE = 15
	SLOT_HEADSET = 16
	SLOT_IN_BACKPACK = 17

/mob/human/proc/equip_if_possible(obj/item/weapon/W, slot) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	if((slot == SLOT_L_STORE || slot == SLOT_R_STORE || slot == SLOT_BELT || slot == SLOT_ID) && !src.jumpsuit)
		del(W)
		return
	switch(slot)
		if(SLOT_BACK)
			if(!src.back)
				src.back = W
				equipped = 1
		if(SLOT_MASK)
			if(!src.mask)
				src.mask = W
				equipped = 1
		if(SLOT_HANDCUFFS)
			if(!src.handcuffs)
				src.handcuffs = W
				equipped = 1
		if(SLOT_L_HAND)
			if(!src.l_hand)
				src.l_hand = W
				equipped = 1
		if(SLOT_R_HAND)
			if(!src.r_hand)
				src.r_hand = W
				equipped = 1
		if(SLOT_BELT)
			if(!src.belt)
				src.belt = W
				equipped = 1
		if(SLOT_ID)
			if(!src.id)
				src.id = W
				equipped = 1
		if(SLOT_GLASSES)
			if(!src.glasses)
				src.glasses = W
				equipped = 1
		if(SLOT_GLOVES)
			if(!src.gloves)
				src.gloves = W
				equipped = 1
		if(SLOT_HELMET)
			if(!src.head)
				src.head = W
				equipped = 1
		if(SLOT_SHOES)
			if(!src.shoes)
				src.shoes = W
				equipped = 1
		if(SLOT_SUIT)
			if(!src.suit)
				src.suit = W
				equipped = 1
		if(SLOT_JUMPSUIT)
			if(!src.jumpsuit)
				src.jumpsuit = W
				equipped = 1
		if(SLOT_L_STORE)
			if(!src.l_store)
				src.l_store = W
				equipped = 1
		if(SLOT_R_STORE)
			if(!src.r_store)
				src.r_store = W
				equipped = 1
		if(SLOT_HEADSET)
			if(!src.headset)
				src.headset = W
				equipped = 1
		if(SLOT_IN_BACKPACK)
			if (src.back && istype(src.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = src.back
				if(B.contents.len < 7 && W.w_class <= 3)
					W.loc = B
					equipped = 1
	if(equipped)
		W.layer = 20
	else
		del(W)


/mob/human/proc/Assign_Rank(rank, joined_late)
	if (rank == "AI")
		var/obj/S = locate(text("start*[]", rank))
		if ((istype(S, /obj/start) && istype(S.loc, /turf) && !( ctf )))
			src << "\blue <B>You have been teleported to your new starting location!</B>"
			src.loc = S.loc
			src.AIize()
		return
	src.equip_if_possible(new /obj/item/weapon/radio/headset(src), SLOT_HEADSET)
	src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), SLOT_BACK)
	if (src.disabilities & 1)
		src.equip_if_possible(new /obj/item/weapon/clothing/glasses/regular(src), SLOT_GLASSES)
	switch(rank)
		if("Research Assistant")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clipboard(src), SLOT_L_HAND)
		if("Technical Assistant")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), SLOT_L_HAND)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), SLOT_IN_BACKPACK)
		if("Staff Assistant")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/red(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), SLOT_L_HAND)
		if("Medical Assistant")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), SLOT_L_HAND)
		if("Engineer")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), SLOT_L_HAND)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), SLOT_IN_BACKPACK)
		if("Research Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clipboard(src), SLOT_L_HAND)
		if("Forensic Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/red(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/gloves/latex(src), SLOT_GLOVES)
			src.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/fcardholder(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/f_print_scanner(src), SLOT_IN_BACKPACK)
		if("Medical Doctor")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), SLOT_L_HAND)
		if("Captain")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/darkgreen(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/swat_hel(src), SLOT_HELMET)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), SLOT_GLASSES)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), SLOT_BELT)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), SLOT_IN_BACKPACK)
		if("Security Officer")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/red(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), SLOT_HELMET)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), SLOT_GLASSES)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/storage/flashbang_kit(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/baton(src), SLOT_BELT)
			src.equip_if_possible(new /obj/item/weapon/flash(src), SLOT_L_STORE)
		if("Genetic Researcher")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(src), SLOT_SUIT)
		if("Toxin Researcher")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/white(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/bio_suit(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/bio_hood(src), SLOT_HELMET)
			src.equip_if_possible(new /obj/item/weapon/clothing/mask/gasmask(src), SLOT_MASK)
			src.equip_if_possible(new /obj/item/weapon/tank/oxygentank(src), SLOT_L_HAND)
		if("Head of Research")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/green(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), SLOT_HELMET)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), SLOT_GLASSES)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), SLOT_BELT)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/flash(src), SLOT_L_STORE)
		if("Head of Personnel")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/green(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(src), SLOT_SUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(src), SLOT_HELMET)
			src.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(src), SLOT_GLASSES)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(src), SLOT_BELT)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/flash(src), SLOT_L_STORE)
		if("Station Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), SLOT_L_HAND)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/cable_coil(src), SLOT_IN_BACKPACK)
			src.equip_if_possible(new /obj/item/weapon/t_scanner(src), SLOT_BELT)
		if("Atmospheric Technician")
			src.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(src), SLOT_JUMPSUIT)
			src.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(src), SLOT_SHOES)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox(src), SLOT_L_HAND)
			src.equip_if_possible(new /obj/item/weapon/crowbar(src), SLOT_IN_BACKPACK)
		else
			//this shouldn't ever happen?
			src << "UH OH! Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."
	var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id(src)
	C.registered = src.rname
	C.assignment = rank
	C.name = "[C.registered]'s ID Card ([C.assignment])"
	C.access = get_access(C.assignment)
	src.equip_if_possible(C, SLOT_ID)
	src.equip_if_possible(new /obj/item/weapon/pen(src), SLOT_R_STORE)
	src.equip_if_possible(new /obj/item/weapon/radio/signaler(src), SLOT_BELT)
	if(rank == "Captain")
		world << "<b>[src] is the captain!</b>"
	src << "<B>You are the [rank].</B>"
	if(!joined_late)
		var/obj/S = locate("start*[rank]")
		if ((istype(S, /obj/start) && istype(S.loc, /turf) && !( ctf )))
			src << "\blue <B>You have been teleported to your new starting location!</B>"
			src.loc = S.loc
	return

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.attack_ai(M)
