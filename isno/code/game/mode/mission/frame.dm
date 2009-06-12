/datum/mission/frame
	/var/const
		REVOLVER = 1
		HEATER = 2
		CAPTAIN_ID = 3
		GENERATOR = 4

	var/list/victims
	var/vname
	var/target

	New(list/group, gname, list/victims, vname)
		src.group = group
		src.gname = gname
		if(victims)
			src.victims = victims
			src.vname = vname
		else
			var/mob/carbon/V = pick_cliented_human_except(group)
			victims = list(V)
			vname = V.spawn_name
		target = pick(get_pickable_targets(victims))

	check_success()
		var/list/fingerprints = list()
		for(var/mob/carbon/M in victims)
			fingerprints += M.fingerprint
		for(var/obj/O in world) // TODO: see if this takes ridiculously long to execute, hopefully not
			if(target == REVOLVER && !istype(O, /obj/item/weapon/gun/revolver))
				continue
			if(target == HEATER && !istype(O, /obj/machinery/atmoalter/heater))
				continue
			if(target == CAPTAIN_ID)
				if(!istype(O, /obj/item/weapon/card/id))
					continue
				var/obj/item/weapon/card/id/C = O
				if(!C.access)
					continue
				for(var/A in get_all_accesses())
					if(!A in C.access)
						continue
			if(target == GENERATOR && !istype(O, /obj/machinery/power/generator))
				continue
			if(!O.fingerprints)
				continue
			for(var/fingerprint in O.fingerprints)
				if(fingerprint in fingerprints)
					return MISSION_SUCCESS
		return MISSION_FAILURE

	description()
		var/pronoun = null
		for(var/mob/M in victims)
			if(pronoun != null || M.gender == PLURAL)
				pronoun = "One of their"
			else if(M.gender == NEUTER)
				pronoun = "Its"
			else if(M.gender == MALE)
				pronoun = "His"
			else // lets be honest here this case might as well not exist
				pronoun = "Her"

		var/target_desc = ""
		switch(target)
			if(REVOLVER)
				target_desc = "a revolver"
			if(HEATER)
				target_desc = "a plasma heater"
			if(CAPTAIN_ID)
				target_desc = "an ID card with universal access"
			if(GENERATOR)
				target_desc = "an electrical generator"
		return "frame [vname] by getting [pronoun] fingerprints on [target_desc]"

	proc/get_pickable_targets(list/group)
		var/list/targets = list(REVOLVER, HEATER, CAPTAIN_ID, GENERATOR)
		for(var/mob/M in group)
			var/datum/job/killerjob = M.spawn_job
			if(istype(killerjob, /datum/job/captain))
				targets -= CAPTAIN_ID
			else if(istype(killerjob, /datum/job/plasmologist))
				targets -= HEATER
			else if(istype(killerjob, /datum/job/technician))
				targets -= GENERATOR
		return targets