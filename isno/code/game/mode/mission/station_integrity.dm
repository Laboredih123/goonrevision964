/datum/mission/station_integrity
	var/datum/station_state/initial = new()
	var/datum/station_state/current = new()
	var/required_integrity
	var/max_integrity

	description()
		if(max_integrity >= 100)
			return "ensure that at least [required_integrity]% of the station survives"
		else if(required_integrity <= 0)
			return "ensure that at most [max_integrity]% of the station survives"
		else
			return "ensure that between [required_integrity]% and [max_integrity]% of the station survives"

	New(group, gname, min_remaining=90, max_remaining = 100)
		..()
		required_integrity = min_remaining
		max_integrity = max_remaining
		src.initial.count()

	check_success()
		src.current.count()
		var/percent = round(100.0 * src.initial.score(current), 0.1)
		world << "<B>The station is [percent]% intact.</B>"
		if(percent > required_integrity && (percent <= max_integrity || max_integrity >= 100))
			return MISSION_SUCCESS
		else
			return MISSION_FAILURE