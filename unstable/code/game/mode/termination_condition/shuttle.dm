/datum/termination_condition/shuttle

	var/datum/shuttle/shuttle
	New(shuttle)
		src.shuttle = shuttle

	check()
		return shuttle.status == shuttle.STATE_LEFT

	conclude()
		world << "<font color='blue'>The shuttle has left!</font>"