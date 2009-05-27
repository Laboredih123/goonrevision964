

/world/New()
	..()
	SetupOccupationsList()
	jobban_loadbanfile()

/mob/prespawn/proc/Assign_Rank(rank, joined_late)
	var/startloc = null
	if(!joined_late)
		var/obj/S = null
		for(var/obj/start/sloc in world)
			if (sloc.name != rank)
				continue
			if (locate(/mob) in sloc.loc)
				continue
			S = sloc
			break
		if (!S)
			S = locate("start*[rank]") // use old stype
		if (istype(S, /obj/start) && istype(S.loc, /turf))
			startloc = S.loc

	if (rank == "AI")
		var/mob/silicon/ai/A = new()
		A.client = src.client
		A.loc = startloc
		A.spawn_rank = rank
		del(src)
		return

	var/name = src.client.prefs.name
	if (rank == "Medical Doctor")
		name = addtext("Dr. ", name)

	var/mob/carbon/human/M = new(startloc, name, src.client.prefs.hair_color, src.client.prefs.hair_style, src.client.prefs.skin_color, src.client.prefs.gender, rank = rank)

	M.equip_if_possible(new /obj/item/weapon/radio/headset(M), SLOT_HEADSET)
	M.equip_if_possible(new /obj/item/weapon/storage/backpack(M), SLOT_BACK)
	switch(rank)
		if("Chaplain")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/black(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(M), SLOT_SHOES)
		if("Assistant")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(M), SLOT_L_HAND)
		if("Station Engineer")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/storage/toolbox(M), SLOT_L_HAND)
			M.equip_if_possible(new /obj/item/weapon/crowbar(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/t_scanner(M), SLOT_BELT)
		if("Research Technician")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clipboard(M), SLOT_L_HAND)
		if("Forensic Technician")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/red(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/gloves/latex(M), SLOT_GLOVES)
			M.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/fcardholder(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/f_print_scanner(M), SLOT_IN_BACKPACK)
		if("Medical Doctor")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(M), SLOT_L_HAND)
		if("Captain")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/darkgreen(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet/swat_hel(M), SLOT_HELMET)
			M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_BELT)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/storage/id_kit(M), SLOT_IN_BACKPACK)
		if("Security Officer")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/red(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(M), SLOT_HELMET)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/handcuffs(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/handcuffs(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/storage/flashbang_kit(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/baton(M), SLOT_BELT)
			M.equip_if_possible(new /obj/item/weapon/flash(M), SLOT_L_STORE)
		if("Genetic Researcher")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
		if("Toxin Researcher")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/bio_suit(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/head/bio_hood(M), SLOT_HELMET)
			M.equip_if_possible(new /obj/item/weapon/clothing/mask/gasmask(M), SLOT_MASK)
			M.equip_if_possible(new /obj/item/weapon/tank/oxygentank(M), SLOT_L_HAND)
		if("Head of Research")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/green(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(M), SLOT_HELMET)
			M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_BELT)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/storage/id_kit(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/flash(M), SLOT_L_STORE)
		if("Head of Personnel")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/green(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(M), SLOT_HELMET)
			M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_BELT)
			M.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/storage/id_kit(M), SLOT_IN_BACKPACK)
			M.equip_if_possible(new /obj/item/weapon/flash(M), SLOT_L_STORE)
		if("Atmospheric Technician")
			M.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(M), SLOT_JUMPSUIT)
			M.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(M), SLOT_SHOES)
			M.equip_if_possible(new /obj/item/weapon/storage/toolbox(M), SLOT_L_HAND)
			M.equip_if_possible(new /obj/item/weapon/crowbar(M), SLOT_IN_BACKPACK)
		else
			//this shouldn't ever happen?
			M << "UH OH! Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."

	var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id(M)
	C.registered = M.spawn_name
	C.assignment = rank
	C.name = "[C.registered]'s ID Card ([C.assignment])"
	C.access = get_access(C.assignment)
	M.equip_if_possible(C, SLOT_ID)
	M.equip_if_possible(new /obj/item/weapon/pen(M), SLOT_R_STORE)
	M.equip_if_possible(new /obj/item/weapon/radio/signaler(M), SLOT_BELT)

	M.client = src.client
	M.update_clothing()

	world.log_game("[M] has joined the game.")
	if(rank == "Captain")
		world << "<b>[M] is the captain!</b>"
	src << "<B>Game mode is [current_mode]</B>"
	src << "<B>You are the [rank].</B>"
	if(joined_late)
		for(var/mob/silicon/ai/ai in world)
			if(!ai.is_dead)
				ai.say("[M] has arrived on the station. \He is the [rank].")
				break
	del(src)



/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/silicon/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.interact(M)
