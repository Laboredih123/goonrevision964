var/const/SCENARIO_ACTIVE = 0
var/const/SCENARIO_COMPLETE = 1

/datum/game_mode
	var/name = "free form"

	var/votable = 1
	var/probability = 1
	var/list/missions = new()
	var/list/termination_conditions = new()

	proc/announce()
		world << "<font color='blue'><B>Free Form!</B></font>"

	proc/conclude()
		world << "<font color='red'><B>Game Over!</B></font>"
		for(var/datum/mission/x in missions)
			x.conclude()

	proc/setup()
		missions[new/datum/mission/survival()] = MISSION_ACTIVE

	proc/execute()
		while(src.state() == SCENARIO_ACTIVE)
			sleep(5)
		return src.conclude()

	proc/state()
		for(var/datum/termination_condition/t in termination_conditions)
			if(t.check())
				return SCENARIO_COMPLETE
		return SCENARIO_ACTIVE
