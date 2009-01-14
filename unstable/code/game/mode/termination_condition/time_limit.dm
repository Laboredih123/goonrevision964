/datum/termination_condition/time_limit
	var/endat

	New(var/length = 12000) // 20 minutes (byond uses 1/10 second units)
		endat = world.realtime + length

	check()
		return world.realtime >= endat

	conclude()
		world << "<font color='blue'>Time has run out!</font>"