/datum/termination_condition/shuttle
	check()
		return !blobs.len

	conclude()
		world << "<font color='blue'>All blobs have been destroyed!</font>"