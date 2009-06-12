/mob
	density = 1
	layer = 4.0
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/poll_answer = 0.0
	var/nextDblClick = 0
	var/list/requests = list(  )
	var/list/mapobjs = list()

	var/death_threshold = 200
	var/unconsciousness_threshold = 100
	var/is_intelligent = 1

	var/is_dead = 0
	var/be_syndicate = "Yes"

	var/last_known_ip = null
	var/last_known_ckey = null

	var/voice = null
	var/spawn_name = null

	New()
		..()
		if(!src.voice)
			src.voice = src.name
		if(!src.spawn_name)
			src.spawn_name = src.name

	var/canmove = 0
	var/atom/movable/pulling = null

	var/ui_mode = UI_MODE_DEFAULT

	var/prev_move = 0
	var/next_move = 0

	var/list/languages = list(LANGUAGE_NONE)
	var/curr_language = LANGUAGE_NONE

	var/is_deaf = 0
	var/is_perma_deaf = 0
	var/is_blind = 0
	var/is_perma_blind = 0

	density = 1

	var/cameraFollow = null
	var/datum/job/spawn_job = null
