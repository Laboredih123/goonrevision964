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
/datum/mission/time_limit
	var/timer = 12000

/datum/mission/time_limit/New(var/time)
	if(time!=null) timer = time
	timer += world.timeofday

/datum/mission/time_limit/state()
	if(world.timeofday >= timer) return MISSION_COMPLETE
	return MISSION_ACTIVE

/datum/mission/time_limit/conclude()
	world << "<font color='blue'>Time has run out!</font>"

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

//----------------------------------------------------------------------------

/datum/mission/station_damage
	var/datum/station_state/initial = new()
	var/datum/station_state/current = new()
	var/required_integrity

/datum/mission/station_damage/New(var/min_remaining=90)
	required_integrity = min_remaining
	src.initial.count()

/datum/mission/station_damage/state()
	src.current.count()
	var/percent = 100*src.initial.score(current)
	if(percent > required_integrity) return MISSION_ACTIVE
	return MISSION_COMPLETE

/datum/mission/station_damage/conclude()
	var/percent = round(100.0 * src.initial.score(current), 0.1)
	world << "<B>The station is [percent]% intact.</B>"

//----------------------------------------------------------------------------

/datum/mission/spawn_meteors/New(var/interval, var/number=1, var/randomness=0)
	spawn(0)
		while(1)
			for(var/i=1 to number) spawn_meteor()
			sleep(interval+rand(-randomness,randomness))

//----------------------------------------------------------------------------

/datum/mission/murder
	var/client/victim = null
	var/client/attacker = null
	var/Vname = "your victim"
	var/Aname = "your attacker"

/datum/mission/murder/New(var/client/A, var/client/V)
	victim = V
	attacker = A
	if(A && A.mob)	Aname = A.mob.spawn_name
	if(V && V.mob)	Vname = V.mob.spawn_name

	A << "You have been tasked with removing [Vname] from the face of this station!"
	if(prob(25)) V << "It appears a contract has been put on your life; be wary!"

/datum/mission/murder/state()
	if(victim && victim.mob)		Vname = victim.mob.spawn_name
	if(attacker && attacker.mob)	Aname = attacker.mob.spawn_name

	if(!victim)				return store(MISSION_SUCCESS)
	if(!victim.mob)			return store(MISSION_SUCCESS)
	if(victim.mob.is_dead)	return store(MISSION_SUCCESS)
	return MISSION_ACTIVE

/datum/mission/murder/conclude()
	if(src.state == MISSION_SUCCESS)
		if(attacker)
			if(victim)		attacker << "Congratulations! [capitalize(Vname)] no longer draws breath."
			else			attacker << "Congratulations! [capitalize(Vname)] has left this world and its hardships."
		if(victim)
			if(attacker)	victim << "Your death has fulfilled the obligations of [Aname]"
			else			victim << "Your death serves the goals of those around you; too bad you may never know who benefitted."
		return
	if(attacker)
		if(victim)		attacker << "You have failed! [capitalize(Vname)] still draws breath!"
		else			attacker << "You have failed to finish off your victim"
	if(victim)
		if(attacker)	victim << "You have successfully eluded [Aname], who wished to kill you."
		else			victim << "You have survived, to the great consternation of other folks."

//----------------------------------------------------------------------------
