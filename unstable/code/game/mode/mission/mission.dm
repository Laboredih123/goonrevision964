/datum/mission
	var/gname = "everyone"						//	default group is everyone
	var/list/group = null						//	set of mission members
	var/list/outcasts = null					//	set of non-mission members

	proc/check_success() //returns 1 if successful, 0 if unsuccessful.
		return

	proc/description()
		return

/mob/proc/tell_mission(datum/mission/M)
	src << "<b>Objective:</b> [capitalize(M.description())]."
	src.store_memory("<b>Objective:</b> [capitalize(M.description())].", 0, 0)