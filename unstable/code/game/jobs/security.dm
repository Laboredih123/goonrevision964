/datum/job/security
	name = "Security Officer"
	priority = 2
	max = 5
	speaker_color = COLOR_SECURITY
	responsibilities = {"<html>Preserve order on the station by arresting criminals. Either release them after a
	    short time in the brig, or put them on trial if the crime is more serious. Use force only if it is
	    unavoidable. You, along with the other security officers, are third in the chain of command after the
	    captain and HoP, so be prepared to take over if necessary."}

	give_equipment(mob/carbon/M)
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
		..()

	get_access()
		return list(access_security, access_brig, access_security_lockers)
