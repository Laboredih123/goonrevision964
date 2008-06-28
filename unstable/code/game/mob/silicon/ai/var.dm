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
	curr_language = LANGUAGE_COMPUTER