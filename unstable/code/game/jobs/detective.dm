/datum/job/detective
	name = "Detective"
	max = 1
	responsibilities = {"Investigate crimes after they occur with your scanners, and report any that you see
	    happening with your thermal goggles. Your responsibilities do not include subduing or arresting criminals."}

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/red(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/brown(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/gloves/latex(M), SLOT_GLOVES)
		M.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/fcardholder(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/f_print_scanner(M), SLOT_IN_BACKPACK)
		..()

	get_access()
		return list(access_security, access_forensics_lockers, access_morgue, access_maint_tunnels)