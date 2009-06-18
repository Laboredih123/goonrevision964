/mob/silicon/ai
	anchored = 1
	var/aiRestorePowerRoutine = 0
	var/network = "SS13"
	icon_state = "teg"
	icon = 'power.dmi'
	var/obj/machinery/camera/current = null
	var/list/laws = list()
	var/has_power = 1
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_COMPUTER)
	curr_language = LANGUAGE_ENGLISH
	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list())
	var/viewalerts = 0
	var/is_evil = 0
	var/last_lockdown = 0
	is_dead = 0

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/silicon/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.interact(M)
