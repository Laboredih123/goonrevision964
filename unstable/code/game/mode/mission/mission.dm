var/const
	MISSION_SUCCESS = 1
	MISSION_FAILURE = 2
	MISSION_UNKNOWN = 3

/datum/mission
	var/gname = "everyone"						//	default group is everyone
	var/list/group = null						//	set of mission members
	var/list/outcasts = null					//	set of non-mission members

	New(list/group, gname)
		src.group = group
		src.gname = gname

	proc/check_success()
		return MISSION_UNKNOWN

	proc/description()
		return

/mob/proc/tell_mission(datum/mission/M)
	var/d = capitalize(M.description())
	src << "<b>Objective:</b> [d]."
	src.store_memory("<b>Objective:</b> [d].", 0, 0)