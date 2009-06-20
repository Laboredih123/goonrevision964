/datum/ban/time
	var/endat = 0

	New(banclass, datum/job/banfrom, id, origckey, reason, adminckey, length) // length in 1/10 second
		..()
		endat = length + world.realtime

	still_applicable()
		if(endat < world.realtime)
			return 0
		else
			return 1

	get_duration_desc()
		return "until [time2text(endat, "Day, Month DD, YYYY, at hh:mm")]"