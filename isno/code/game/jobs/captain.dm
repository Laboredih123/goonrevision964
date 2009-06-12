/datum/job/captain
	name = "Captain"
	priority = 100
	max = 1
	speaker_color = COLOR_CAPTAIN
	responsibilities = "Keep the station running, tell people what to do, enforce the law, and don't kill people."

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/darkgreen(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet/swat_hel(M), SLOT_HELMET)
		M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_BELT)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/storage/id_kit(M), SLOT_IN_BACKPACK)
		..()

	announce(mob/M)
		..()
		world << "<b>[M] is the captain!</b>"

	get_access()
		return get_all_accesses()