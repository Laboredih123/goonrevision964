/datum/termination_condition/blob_destroyed
	check()
		return !blobs.len

	conclude()
		world << "<font color='blue'>All blobs have been destroyed!</font>"