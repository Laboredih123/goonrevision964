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
//----------------------------------------------------------------------------
/datum/mission/survival/New(var/gname, var/group, var/outcasts)
	src.gname = gname
	src.group = group
	src.outcasts = outcasts

/datum/mission/survival/state()
	var/survivors = group
	if(!group) survivors = world
	for(var/mob/M in survivors)
		if(!M.client)		continue
		if(M in outcasts)	continue
		if(!M.is_dead)		return MISSION_ACTIVE
	return MISSION_FAILURE

/datum/mission/survival/conclude()
	if(!group)				world << "<font color='blue'>Everyone has died!</font>"
	else if(group.len == 1)	world << "<font color='blue'>The [gname] has died!</font>"
	else					world << "<font color='blue'>The [gname] have died!</font>"

//----------------------------------------------------------------------------
/datum/mission/destroy/New(var/tname, var/list/targets)
	src.gname = tname
	src.group = targets

/datum/mission/destroy/state()
	if(!group.len) return MISSION_COMPLETE
	return MISSION_ACTIVE

/datum/mission/destroy/conclude()
	world << "<font color='blue'>The [gname] scourge has been eradicated!</font>"

//----------------------------------------------------------------------------
/datum/mission/timed_survival
	var/datum/mission/survival/survival = null
	var/datum/mission/time_limit/time_limit = null

/datum/mission/timed_survival/New(var/time, var/gname, var/group, var/outcast)
	if(!time)	time_limit	= new(12000)
	else		time_limit	= new(time)
	survival = new(gname,group,outcast)

/datum/mission/timed_survival/state()
	if(survival.state())	return store(MISSION_FAILURE)
	if(time_limit.state())	return store(MISSION_SUCCESS)
	return MISSION_ACTIVE

/datum/mission/timed_survival/conclude()
	switch(src.state)
		if(MISSION_SUCCESS)	return "<font color='blue'>The [survival.gname] survived the round!</font>"
		if(MISSION_FAILURE) return "<font color='blue'>The [survival.outcasts] destroyed the [survival.gname]!.</font>"