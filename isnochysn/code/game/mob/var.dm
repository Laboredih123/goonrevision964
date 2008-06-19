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
	var/unconsciousness_threshold = 100

	var/voice = null
	var/spawn_name = null

	New()
		..()
		if(!src.voice)
			src.voice = src.name
		if(!src.spawn_name)
			src.spawn_name = src.name

