/datum/job/death_commando
	name = "Death Commando"
	max = 10000000
	priority = 10000000
	can_join_late = 1 // OH GOD NO TODO: FIX
	switchable_to = 0
	var/list/names

	speaker_color = COLOR_DEATH_COMMANDO

	New()
		..()
		names = dd_file2list("death_commando_names.txt")

	find_spawnpoint()
		var/area/A = locate(/area/death_commando_shuttle)
		var/list/possibilities = list()
		for(var/turf/station/floor/F in A)
			if(!locate(/mob) in F && !locate(/obj/machinery) in F)
				possibilities += F
		if(possibilities.len)
			return pick(possibilities)
		else
			world << "WARNING: NO SPAWNPOINT FOUND! JOB IS [src.name]."

	process_name(name, mob/M)
		var/randomname = "Killiam Shakespeare"
		if(names.len)
			randomname = pick(names)
			names -= randomname
		var/newname = input(M,"You are a death commando. Would you like to change your name?", "Character Creation", randomname)
		if(!length(newname)) newname = randomname
		newname = strip_html(newname,30)
		return newname

	create(mob/M)
		..(M, 0, 0, 0)

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/black(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/swat_suit/death_commando(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/mask/gasmask/death_commando(M), SLOT_MASK)
		M.equip_if_possible(new /obj/item/weapon/clothing/gloves/swat(M), SLOT_GLOVES)
		M.equip_if_possible(new /obj/item/weapon/clothing/glasses/thermal(M), SLOT_GLASSES)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/pulse_rifle(M), SLOT_L_HAND)
		M.equip_if_possible(new /obj/item/weapon/m_pill/cyanide(M), SLOT_L_STORE)
		M.equip_if_possible(new /obj/item/weapon/flashbang(M), SLOT_R_STORE)

		var/obj/item/weapon/camera_jammer/J = new(M)
		J.on = 1
		J.icon_state = "jammer1"
		M.equip_if_possible(J, SLOT_BELT)

		var/obj/item/weapon/tank/oxygentank/O = new(M)
		M.equip_if_possible(O, SLOT_BACK)
		M.internal = O
		..()

	get_access()
		return get_all_accesses()