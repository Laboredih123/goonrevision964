/datum/mission/time_limit
	var/timer = 12000

/datum/mission/time_limit/New(var/time)
	if(time!=null) timer = time
	timer += world.timeofday

/datum/mission/time_limit/state()
	if(world.timeofday >= timer) return MISSION_COMPLETE
	return MISSION_ACTIVE

/datum/mission/time_limit/conclude()
	world << "<font color='blue'>Time has run out!</font>"