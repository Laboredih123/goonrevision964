/datum/mission
	var/gname = "everyone"						//	default group is everyone
	var/list/group = null						//	set of mission members
	var/list/outcasts = null					//	set of non-mission members

	proc/conclude() //called upon completion of game
		return