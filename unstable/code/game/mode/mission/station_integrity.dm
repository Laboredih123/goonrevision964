/datum/mission/station_integrity
	var/datum/station_state/initial = new()
	var/datum/station_state/current = new()
	var/required_integrity
	var/max_integrity

	New(var/min_remaining=90, var/max_remaining = 100)
		required_integrity = min_remaining
		max_integrity = max_remaining
		src.initial.count()

	state()
		src.current.count()
		var/percent = 100*src.initial.score(current)
		if(percent > required_integrity && (percent <= max_integrity || max_integrity >= 100))
			return MISSION_ACTIVE
		return MISSION_COMPLETE

	conclude()
		var/percent = round(100.0 * src.initial.score(current), 0.1)
		world << "<B>The station is [percent]% intact.</B>"