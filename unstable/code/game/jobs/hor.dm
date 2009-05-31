/datum/job/hor
	name = "Head of Research"
	priority = 5
	max = 1
	speaker_color = COLOR_HEAD

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/green(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/armor(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/head/helmet(M), SLOT_HELMET)
		M.equip_if_possible(new /obj/item/weapon/clothing/glasses/sunglasses(M), SLOT_GLASSES)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/taser_gun(M), SLOT_BELT)
		M.equip_if_possible(new /obj/item/weapon/gun/energy/laser_gun(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/storage/id_kit(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/flash(M), SLOT_L_STORE)
		..()

	get_access()
		return list(access_medical_supplies, access_morgue, access_tox, access_tox_storage, access_genetics,
		            access_teleporter, access_heads, access_medical_records, access_tech_storage, access_security)