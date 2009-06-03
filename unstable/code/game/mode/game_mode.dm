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

	proc/get_traitors()
		return null

	proc/give_newcomer_job(mob/new_player)
		var/list/jobs = get_unfilled_jobs()
		var/dat = "<html><head><title>Select job</title></head>"
		dat += "<p>You spawned late, so you get to select a job! Lucky you!"
		for(var/job in jobs)
			if(allowed_to_do_job(new_player, job))
				dat += "<br><a href='byond://?src=\ref[src];late-job=\ref[job]'>[job]</a>"
		dat += "</p>"
		ss13_browse(new_player, dat, "window=late_job;size=300x600")

	Topic(href, href_list)
		if(href_list["late-job"])
			ss13_browse(usr, null, "window=late_job")
			if(!istype(usr,/mob/prespawn))
				return
			var/mob/prespawn/new_player = usr
			var/datum/job/j = locate(href_list["late-job"])
			j.create(new_player, JOINED_LATE)
			return
		else
			return ..()

	proc/get_unfilled_jobs()
		var/list/jobs = list()
		for(var/datum/job/j in get_all_job_instances())
			if(j.can_join_late && j.max)
				jobs[j] = j.max
		for(var/mob/carbon/C in world)
			jobs[C.spawn_job] --
			if(jobs[C.spawn_job] <= 0)
				jobs -= C.spawn_job
		return jobs
