/datum/mission/evacuate
	var/const/percentage_station_evacuate = 80 // what percentage of people gotta leave

	description()
		return "cause the death or evacuation of [percentage_station_evacuate]% of the crew"

	check_success()
		var/gone = 0
		var/stayed = 0
		for(var/mob/carbon/M in world)
			if (M.client)
				if (M.is_dead || on_shuttle(M) || istype(M.loc, /obj/machinery/vehicle/pod) || istype(M.loc, /turf/space))
					gone++
				else
					stayed++
		var/total = gone + stayed
		if (stayed > total * percentage_station_evacuate / 100)
			return MISSION_FAILURE
		else
			return MISSION_SUCCESS