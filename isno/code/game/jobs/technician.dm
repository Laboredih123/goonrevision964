/datum/job/technician
	name = "Technician"
	max = INFINITY // actually only 10^99, but if we ever get to the point where there are 10^99 technicians there
	// will be bigger things to worry about than new arrivals not getting a job
	priority = 2
	responsibilities = {"<html>Keep the station in one piece. If the engine starts to run out of fuel, add more.
	    Maintain proper atmospheric pressure and composition throughout the station. Set up the solar panels. If you
	    run out of things to do, add new rooms to the outside of the station.</html>"}

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/yellow(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/storage/toolbox(M), SLOT_L_HAND)
		M.equip_if_possible(new /obj/item/weapon/crowbar(M), SLOT_IN_BACKPACK)
		M.equip_if_possible(new /obj/item/weapon/t_scanner(M), SLOT_BELT)
		..()

	get_access()
		return list(access_engine, access_eject_engine, access_maint_tunnels, access_external_airlocks,
		            access_apcs, access_tech_storage, access_atmospherics)
