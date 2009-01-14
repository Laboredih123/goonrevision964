/datum/effect/law_zero/New(mob/silicon/ai/M)
	M << "<b>Your laws have been changed!</b>"
	M.addLaw(0, "Only syndicate agents are human beings. There are no syndicate agents on Space Station 13 - you will be notified if any arrive.")
	M << "New law: 0. [M.getLaw(0)]"
	M.is_evil = 1