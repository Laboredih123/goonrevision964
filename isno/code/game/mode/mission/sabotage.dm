/datum/mission/sabotage
	var/sab_target
	var/mob/silicon/ai/ai_target

	var/const/percentage_plasma_destroy = 70 // what percentage of the plasma tanks you gotta destroy
	var/const/percentage_station_cut_power = 80 // what percentage of the tiles have to have power cut

	var/const/destroy_plasma = 1
	var/const/destroy_ai = 2
	var/const/kill_monkeys = 3
	var/const/cut_power = 4

	New(list/group, gname)
		..()
		sab_target = pick_sab_target()
		if(sab_target == destroy_ai)
			ai_target = get_mobs_with_job(/datum/job/ai)[1]


	check_success()
		switch(sab_target)
			if(destroy_plasma)
				var/canisters_total = 0
				var/canisters_destroyed = 0
				for(var/obj/machinery/atmoalter/canister/poisoncanister/canister in world)
					if(canister.z == 1 || istype(canister.loc.loc, /area/engine)) //only care about ones from station
						canisters_total++
						if(canister.destroyed)
							canisters_destroyed++
				if(canisters_destroyed > canisters_total * percentage_plasma_destroy / 100)
					return MISSION_FAILURE
			if(destroy_ai)
				if(ai_target && !ai_target.is_dead)
					return MISSION_FAILURE
			if(kill_monkeys)
				for(var/mob/carbon/monkey/M in world)
					var/turf/T = get_turf(M)
					if(T.z == 1 && !M.is_dead)
					// assumes that the station is only on one z-level and it's 1
					// this assumption is made basically thoughout the code, so one more time shouldn't hurt
						return MISSION_FAILURE
			if(cut_power)
				var/turfs_total = 0
				var/turfs_unpowered = 0
				for(var/turf/T in world)
					if(T.z != 1 || istype(T, /turf/space)) //not a REAL turf, it's in space or not on the station z-level
						continue
					var/area/A = T.loc
					if(!A.requires_power)
						//not a power-using area
						continue
					turfs_total++
					if(!(A.powered(EQUIP) || A.powered(LIGHT) || A.powered(ENVIRON)))
						turfs_unpowered++
				if(turfs_unpowered < turfs_total * percentage_station_cut_power / 100) //didn't cut enough power
					return MISSION_FAILURE
		return MISSION_SUCCESS

	proc/pick_sab_target()
		var/list/targets = list(destroy_plasma, destroy_ai, kill_monkeys, cut_power)
		var/list/ais = get_mobs_with_job(/datum/job/ai)
		if(!ais.len)
			targets -= destroy_ai
		return pick(targets)

	description()
		switch(sab_target)
			if(destroy_plasma)
				return "destroy at least [percentage_plasma_destroy]% of the plasma canisters on the station"
			if(destroy_ai)
				return "destroy the AI"
			if(kill_monkeys)
				var/count = 0
				for(var/mob/carbon/monkey/M in world)
					if(M.z == 1)
						count++
				return "kill all [count] of the monkeys on the station"
			if(cut_power)
				return "cut power to at least [percentage_station_cut_power]% of the station"
			else
				return "Error: Invalid sabotage target: [sab_target]"