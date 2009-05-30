/datum/termination_condition/time_limit
	var/endat

	New(length = 12000) // 20 minutes (byond uses 1/10 second units)
		endat = ss13time() + length

	check()
		return ss13time() >= endat

	conclude()
		world << "<font color='blue'>Time has run out!</font>"