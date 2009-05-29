var/const/SCENARIO_ACTIVE = 0
var/const/SCENARIO_COMPLETE = 1

/datum/game_mode
	var/name = "freeform"

	var/votable = 1
	var/list/missions = new()
	var/list/termination_conditions = new()
	var/min_players = 0

	proc/announce()
		world << "<font color='blue'><B>Freeform!</B></font>"

	proc/conclude()
		world << "<font color='red'><B>Game Over!</B></font>"
		for(var/datum/mission/x in missions)
			var/pronoun = null
			for(var/mob/M in x.group)
				if(pronoun != null || M.gender == PLURAL)
					pronoun = "Their"
				else if(M.gender == NEUTER)
					pronoun = "Its"
				else if(M.gender == MALE)
					pronoun = "His"
				else // lets be honest here this case might as well not exist
					pronoun = "Her"
			if(pronoun == null)
				pronoun = "The"
			var/outcome = x.check_success()
			if(outcome == MISSION_SUCCESS)
				world << "[x.gname] has succeeded! [pronoun] mission was to [x.description()]."
			else if(outcome == MISSION_FAILURE)
				world << "[x.gname] has failed. [pronoun] mission was to [x.description()]."
			else if(outcome == MISSION_UNKNOWN)
				world << "[x.gname] might have failed and might have succeeded, I dunno. [pronoun] mission was to [x.description()]."
			else
				world << "[x.gname] has me really confused, their mission (to [x.description()]) outcome was [outcome] and I have no idea what that means."
		sleep(300)
		world.Reboot()

	proc/setup()
		missions += new /datum/mission/survival()

	proc/execute()
		while(src.state() == SCENARIO_ACTIVE)
			sleep(5)
		return src.conclude()

	proc/state()
		for(var/datum/termination_condition/t in termination_conditions)
			if(t.check())
				return SCENARIO_COMPLETE
		return SCENARIO_ACTIVE

	proc/add_mission(datum/mission/m)
		missions += m
