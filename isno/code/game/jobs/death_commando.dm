/datum/job/death_commando
	name = "Death Commando"
	max = 0
	can_join_late = 0
	switchable_to = 0
	var/list/names
	responsibilities = "KILL! KILL! KILL!"

	speaker_color = COLOR_DEATH_COMMANDO

	New()
		..()
		names = dd_file2list("death_commando_names.txt")

	find_spawnpoint(join_status, mob/M)
		if(join_status == JOINED_ON_TIME)
			// this happens AFTER the shuttle is moved
			var/area/A = locate(/area/shuttle/commando)
			var/list/possibilities = list()
			for(var/turf/station/floor/F in A)
				if(!(locate(/mob) in F) && !(locate(/obj/machinery) in F) && F.z == SHUTTLE_CALLED_Z)
					possibilities += F
			if(possibilities.len)
				return pick(possibilities)
			else
				world.log_bug("No spawnpoint found for [src.name].")
		else if(join_status == JOINED_ALREADY)
			return get_turf(M)
		else
			return ..()

	process_name(name, mob/M)
		var/randomname = "Killiam Shakespeare"
		if(names.len)
			randomname = pick(names)
			names -= randomname
		var/newname = input(M,"You are a death commando. Would you like to change your name?", "Character Creation", randomname)
		if(!length(newname)) newname = randomname
		newname = strip_html(newname,40)
		return newname

	create(mob/M, join_status)
		return ..(M, join_status, 0, 0)

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/black(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/swat_suit/death_commando(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/mask/gasmask/death_commando(M), SLOT_MASK)
		M.equip_if_possible(new /obj/item/weapon/clothing/gloves/swat(M), SLOT_GLOVES)
		M.equip_if_possible(new /obj/item/weapon/clothing/glasses/thermal(M), SLOT_GLASSES)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/pulse_rifle(M), SLOT_R_HAND)
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
		return get_all_accesses() - access_change_ids