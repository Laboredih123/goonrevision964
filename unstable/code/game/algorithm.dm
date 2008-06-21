

/world/New()

	..()
	spawn( 0 )
		SetupOccupationsList()
		return
	return

/mob/carbon/proc/SetJob(occ, job)
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

/mob/carbon/proc/Assign_Rank(rank, joined_late)
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
				subject.interact(M)
