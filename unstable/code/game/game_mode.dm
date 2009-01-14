var/const/SCENARIO_ACTIVE = 0
var/const/SCENARIO_COMPLETE = 1

/datum/game_mode
	var/name = "free form"

	var/votable = 1
	var/probability = 1
	var/list/missions = new()
	var/list/groupings = null

/datum/game_mode/proc/CheckState(var/datum/mission/A)
	if(missions[A] != MISSION_ACTIVE) return missions[A]
	missions[A] = A.state()
	return missions[A]

/datum/game_mode/proc/announce()
	world << "<font color='blue'><B>Free Form!</B></font>"

/datum/game_mode/proc/conclude()
	world << "<font color='red'><B>Game Over!</B></font>"
	for(var/datum/mission/x in missions)
		if(missions[x] != MISSION_ACTIVE) x.conclude()

/datum/game_mode/proc/setup()
	missions[new/datum/mission/survival()] = MISSION_ACTIVE

/datum/game_mode/proc/execute()
	while(src.state()==SCENARIO_ACTIVE) sleep(5)
	return src.conclude()

/datum/game_mode/proc/state()
	for(var/datum/mission/x in missions)
		if(CheckState(x) == MISSION_ACTIVE) continue
		if(x.critical) return SCENARIO_COMPLETE
	return SCENARIO_ACTIVE
