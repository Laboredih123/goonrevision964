/datum/termination_condition/time_limit
	proc/check()
		// true if the game should end
		// if you have multiple termination conditions, the game ends as soon as any
		// of them is fulfilled, not all of them
		return false

	proc/conclude() //what happens when the termination condition is fulfilled
		return