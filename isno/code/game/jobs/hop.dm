/datum/job/hop
	name = "Head of Personnel"
	priority = 5
	max = 1
	speaker_color = COLOR_HEAD
	responsibilities = {"<html>Keep an eye on security, make sure they aren't arresting innocent people and their sentences
	    are reasonable. Patrol areas they can't go into every once in a while to make sure no crimes happen there.
	    If necessary, arrest any criminals that you find (although security should be able to do it themselves).
	    Promote people when necessary to fill vacancies or provide additional access. If the captain is killed, you
	    are next in the chain of command."}

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/hopgreen(M), SLOT_JUMPSUIT)
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
		return list(access_security, access_brig, access_security_lockers, access_forensics_lockers,
					access_security_records, access_tox, access_tox_storage, access_genetics, access_engine,
					access_change_ids, access_ai_upload, access_eva, access_heads, access_all_personal_lockers,
					access_chaplain_office, access_medical_records, access_tech_storage, access_atmospherics,
					access_emergency)