/datum/termination_condition/shuttle
	check()
		return shuttle_status == SHUTTLE_LEFT

	conclude()
		world << "<font color='blue'>The shuttle has left!</font>"