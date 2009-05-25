/datum/mission
	var/gname = "everyone"						//	default group is everyone
	var/list/group = null						//	set of mission members
	var/list/outcasts = null					//	set of non-mission members

	New(list/group, gname)
		src.group = group
		src.gname = gname

	proc/check_success() //returns 1 if successful, 0 if unsuccessful.
		return

	proc/description()
		return

/mob/proc/tell_mission(datum/mission/M)
	var/d = capitalize(M.description())
	src << "<b>Objective:</b> [d]."
	src.store_memory("<b>Objective:</b> [d].", 0, 0)