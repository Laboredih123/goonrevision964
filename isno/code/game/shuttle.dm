/var/datum/shuttle/emergency_shuttle = new()
/var/datum/shuttle/commando/commando_shuttle = new()

/var/list/shuttles_by_area_type = null

/var/const/SHUTTLE_Z = 2 //where it starts
/var/const/SHUTTLE_CALLED_Z = 1 // where it arrives

/datum/shuttle
	var/const
		STATE_WAITING = 0
		STATE_COMING = 1
		STATE_RETURNING = 2
		STATE_DOCKED = 3
		STATE_LEFT = 4

	var/loc = SHUTTLE_Z
	var/last_update
	var/status = STATE_WAITING
	var/is_processing = 0

	var/area_type = /area/shuttle/emergency
	var/type_name = "emergency shuttle"
	var/time_docked = 1800 // time between docking and leaving
	var/time_sped_up = 100 // time to leave after it's sped up
	var/time_left = 6000 // time to arrive

	var/last_announce = INFINITY
	var/list/announce_times_coming = list(600 * 5, 600 * 2, 600 * 1, 100)
	var/list/announce_times_docked = list(600 * 2, 600 * 1, 100)

	var/auth_need = 3

	proc/callize() // "call" is a reserved word, SCREW YOU BYOND
		if(status == STATE_WAITING)
			spawn process()

		if(status == STATE_WAITING || status == STATE_RETURNING)
			status = STATE_COMING

		if(status == STATE_COMING)
			announce()

	proc/uncall()
		if(status == STATE_COMING)
			status = STATE_RETURNING
			announce()

	proc/announce()
		if(status == STATE_COMING)
			station_announce("The [type_name] will arrive in [time2text(time_left, "mm minutes and ss seconds")].")
			last_announce = time_left
		else if(status == STATE_RETURNING)
			station_announce("The [type_name] has been sent back.")

	proc/process()
		if(is_processing)
			world.log_bug("Entered process() a second time in [src.type_name], uh oh")
			return
		is_processing = 1
		last_update = ss13time()
		while(1)
			if(status == STATE_RETURNING)
				if(time_left >= initial(time_left))
					status = STATE_WAITING
				else
					var/curtime = ss13time()
					time_left = min(initial(time_left), time_left + curtime - last_update)
					last_update = curtime
			else if(status == STATE_COMING)
				if(time_left <= 0)
					status = STATE_DOCKED
					time_left = time_docked
					last_update = ss13time()
					move(SHUTTLE_Z, SHUTTLE_CALLED_Z, area_type)
					src.on_arrive()
					last_announce = time_left
				else
					var/curtime = ss13time()
					time_left = max(0, time_left - (curtime - last_update))
					last_update = curtime
					for(var/x in announce_times_coming)
						if(last_announce > x && time_left < x)
							station_announce("The [type_name] will arrive in [time2text(x, "mm minutes and ss seconds")].")
							last_announce = x
							break
			else if(status == STATE_DOCKED)
				if(time_left <= 0)
					status = STATE_LEFT
					move(SHUTTLE_CALLED_Z, SHUTTLE_Z, area_type)
				else
					var/curtime = ss13time()
					time_left = max(0, time_left - (curtime - last_update))
					last_update = curtime
					for(var/x in announce_times_docked)
						if(last_announce > x && time_left < x)
							station_announce("The [type_name] will depart in [time2text(x, "mm minutes and ss seconds")].")
							last_announce = x
							break
			sleep(5)

	proc/move(src_z, dest_z, area_type)
		var/area/A = locate(area_type)
		// move over the turfs
		for(var/turf/T in A)
			if(T.z == src_z && !istype(T, /turf/space))
				var/turf/S = new T.type(locate(T.x, T.y, dest_z))
				//so diagonal walls work, basically
				S.icon = T.icon
				S.icon_state = T.icon_state
				S.dir = T.dir
				A.contents -= S
				A.contents += S

		// move over contents
		for(var/atom/movable/M in A)
			if(M.z == src_z)
				M.z = dest_z

		// replace the turfs it's coming from with space
		for(var/turf/T in A)
			if(T.z == src_z && !istype(T, /turf/space))
				var/turf/space/S = new /turf/space(T)
				A.contents -= S
				A.contents += S

	proc/speed_up()
		src.time_left = time_sped_up
		last_update = ss13time()
		station_announce("The [type_name] has been sped up! It will depart in [time2text(time_left, "mm minutes and ss seconds")].")

	proc/on_arrive()
		station_announce("The [type_name] has arrived! It will depart in [time2text(time_left, "mm minutes and ss seconds")].")

/datum/shuttle/commando
	area_type = /area/shuttle/commando
	type_name = "commando shuttle"
	time_left = 5 * 600
	time_docked = INFINITY
	announce_times_coming = list()
	announce_times_docked = list()
	auth_need = 1

	callize()
		emergency_shuttle.uncall()
		return ..()

	on_arrive()
		var/list/station_members = list()
		for(var/mob/carbon/M in world)
			if(!M.is_dead && M.client)
				station_members += M
		var/datum/mission/escape/E = new /datum/mission/escape(station_members, "station personnel")
		config.current_mode.add_mission(E)
		for(var/mob/carbon/M in station_members)
			M.tell_mission(E)

		var/list/commandos = list()
		var/datum/job/death_commando/j = get_job_instance_by_type(/datum/job/death_commando)
		for(var/mob/observer/M in world)
			if(M.client)
				spawn()
					commandos += j.create(M, JOINED_ON_TIME, 1, 1)

		sleep(50)

		var/datum/mission/murders/murders = new /datum/mission/murders(commandos, "the death commandos", station_members, "all station personnel")
		var/datum/mission/prevent_escape/prevent_escape = new /datum/mission/prevent_escape(commandos, "the death commandos", station_members, "any station personnel")
		config.current_mode.add_mission(murders)
		config.current_mode.add_mission(prevent_escape)
		for(var/mob/M in commandos)
			M.tell_mission(murders)
			M.tell_mission(prevent_escape)

		station_announce("Commandos from Central Command have arrived on the station.")


/mob/silicon/ai/proc/ai_call_shuttle()
	set category = "AI Commands"
	set name = "Call Emergency Shuttle"
	if(usr.is_dead)
		usr << "You can't call the shuttle because you are dead!"
		return
	emergency_shuttle.callize()