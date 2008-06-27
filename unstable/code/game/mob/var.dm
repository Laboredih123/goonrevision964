/mob
	density = 1
	layer = 4.0
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/poll_answer = 0.0
	var/muted = null
	var/lastDblClick = 0
	var/list/requests = list(  )
	var/list/mapobjs = list()

	var/death_threshold = 200
	var/is_intelligent = 1

	var/is_dead = 0

	var/last_known_ip = null

	var/voice = null
	var/spawn_name = null

	New()
		..()
		if(!src.voice)
			src.voice = src.name
		if(!src.spawn_name)
			src.spawn_name = src.name
		if(src.client && src.client.last_known_ip)
			src.last_known_ip = src.client.last_known_ip

	var/canmove = 0
	var/atom/movable/pulling = null

	var/ui_mode = UI_MODE_DEFAULT

	var/prev_move = 0
	var/next_move = 0

	var/list/languages = list()
	var/curr_language = null

	icon = 'monkey.dmi'
	icon_state = "monkey1"