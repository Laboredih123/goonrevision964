var/const/MISSION_ACTIVE = 0
var/const/MISSION_COMPLETE = 1
var/const/MISSION_FAILURE = 2
var/const/MISSION_SUCCESS = 3

//----------------------------------------------------------------------------
/datum/mission
	var/gname = "everyone"						//	default group is everyone
	var/critical = 1							//	missions affects scenario state
	var/list/group = null						//	set of mission members
	var/list/outcasts = null					//	set of non-mission members
	var/state = MISSION_ACTIVE					//	storage for mission results
	proc/state() return MISSION_ACTIVE			//	current state of the mission
	proc/conclude() return MISSION_COMPLETE		//	game message due to completion
	proc/store(var/result)						//	simple store and return proc
		src.state = result
		return src.state