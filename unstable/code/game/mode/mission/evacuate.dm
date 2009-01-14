/datum/mission/evacuate
	var/const/percentage_station_evacuate = 80 // what percentage of people gotta leave

	New(mob/M)
		return

	proc/check()
		var/gone = 0
		var/stayed = 0
		for(var/mob/carbon/M in world)
			if (M.client)
				if (M.is_dead || istype(get_area(M), /area/shuttle) || istype(M.loc, /obj/machinery/vehicle/pod) || istype(M.loc, /turf/space))
					gone++
				else
					stayed++
		var/total = gone + stayed
		if (stayed > total * percentage_station_evacuate / 100)
			return 0
		else
			return 1

	conclude()
		if(check())
			world << "<font color='blue'>Not everyone has left!</font>"
		else
			world << "<font color='blue'>Everyone has left!</font>"