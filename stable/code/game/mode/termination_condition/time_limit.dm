/datum/termination_condition/time_limit
	var/endat
	var/desc

	New(length = 12000, desc = "<font color='blue'>Time has run out!</font>") // 20 minutes (byond uses 1/10 second units)
		endat = ss13time() + length
		src.desc = desc

	check()
		return ss13time() >= endat

	conclude()
		world << desc