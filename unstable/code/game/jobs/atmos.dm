/datum/job/atmos
	name = "Atmospheric Technician"
	max = 4

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/storage/toolbox(M), SLOT_L_HAND)
		M.equip_if_possible(new /obj/item/weapon/storage/backpack(M), SLOT_BACK) // TODO: better way to handle this
		M.equip_if_possible(new /obj/item/weapon/crowbar(M), SLOT_IN_BACKPACK)
		..()

	get_access()
		return list(access_maint_tunnels, access_emergency_storage, access_atmospherics)