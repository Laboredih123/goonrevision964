/var/const/SHUTTLE_Z = 2 //where it starts
/var/const/SHUTTLE_CALLED_Z = 1
/var/shuttle_loc = SHUTTLE_Z

/var/const/SHUTTLE_TIME = 6000 //tenths of a second - 10 minutes
/var/const/SHUTTLE_TIME_DOCKED = 600 * 3 // 3 minutes
/var/const/SHUTTLE_TIME_SPED_UP = 100 // 10 seconds
/var/shuttle_time_left = SHUTTLE_TIME
/var/last_shuttle_update

/var/const/SHUTTLE_WAITING = 0
/var/const/SHUTTLE_COMING = 1
/var/const/SHUTTLE_RETURNING = 2
/var/const/SHUTTLE_DOCKED = 3
/var/const/SHUTTLE_LEFT = 4

/var/shuttle_status = SHUTTLE_WAITING
/var/shuttle_processing = 0
/var/last_shuttle_announce = SHUTTLE_TIME
/var/list/shuttle_announce_times = list(600 * 5, 600 * 2, 600 * 1, 100)
/var/list/shuttle_announce_times_docked = list(600 * 2, 600 * 1, 100)

/proc/call_shuttle() //does not bring the shuttle, just starts the countdown
	if(shuttle_status == SHUTTLE_WAITING)
		spawn process_shuttle()
	if(shuttle_status == SHUTTLE_WAITING || shuttle_status == SHUTTLE_RETURNING)
		shuttle_status = SHUTTLE_COMING
		announce_shuttle()
	else if(shuttle_status == SHUTTLE_COMING)
		announce_shuttle()

/proc/uncall_shuttle()
	if(shuttle_status == SHUTTLE_COMING)
		shuttle_status = SHUTTLE_RETURNING
		announce_shuttle()

/proc/announce_shuttle()
	if(shuttle_status == SHUTTLE_COMING)
		station_announce("The shuttle has been called and will arrive in [shuttle_time_left/600] minutes.")
		last_shuttle_announce = shuttle_time_left
	else if(shuttle_status == SHUTTLE_RETURNING)
		station_announce("The shuttle has been sent back.")

/proc/process_shuttle()
	if(shuttle_processing)
		return
	// don't let anyone call process_shuttle() while i'm at this line ok thanks
	shuttle_processing = 1
	last_shuttle_update = ss13time()
	while(1)
		if(shuttle_status == SHUTTLE_RETURNING)
			if(shuttle_time_left >= SHUTTLE_TIME)
				shuttle_status = SHUTTLE_WAITING
			else
				var/curtime = ss13time()
				shuttle_time_left = min(SHUTTLE_TIME, shuttle_time_left + curtime - last_shuttle_update)
				last_shuttle_update = curtime
		else if(shuttle_status == SHUTTLE_COMING)
			if(shuttle_time_left <= 0)
				shuttle_status = SHUTTLE_DOCKED
				shuttle_time_left = SHUTTLE_TIME_DOCKED
				last_shuttle_update = ss13time()
				shuttle_move(SHUTTLE_Z, SHUTTLE_CALLED_Z)
				station_announce("\blue The shuttle has arrived! It will depart in [time2text(shuttle_time_left, "mm minutes and ss seconds")].")
				last_shuttle_announce = shuttle_time_left
			else
				var/curtime = ss13time()
				shuttle_time_left = max(0, shuttle_time_left - (curtime - last_shuttle_update))
				last_shuttle_update = curtime
				for(var/x in shuttle_announce_times)
					if(last_shuttle_announce > x && shuttle_time_left < x)
						station_announce("\blue The shuttle will arrive in [time2text(x, "mm:ss")]")
						last_shuttle_announce = x
						break
		else if(shuttle_status == SHUTTLE_DOCKED)
			if(shuttle_time_left <= 0)
				shuttle_status = SHUTTLE_LEFT
				shuttle_move(SHUTTLE_CALLED_Z, SHUTTLE_Z)
			else
				var/curtime = ss13time()
				shuttle_time_left = max(0, shuttle_time_left - (curtime - last_shuttle_update))
				last_shuttle_update = curtime
				for(var/x in shuttle_announce_times_docked)
					if(last_shuttle_announce > x && shuttle_time_left < x)
						station_announce("\blue The shuttle will depart in [time2text(x, "mm minutes and ss seconds")]")
						last_shuttle_announce = x
						break
		sleep(5)

/proc/shuttle_move(src_z, dest_z)
	var/area/A = locate(/area/shuttle)
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
		if(M.z == src_z && !istype(M, /area))
			// TODO: determine if /area check is necessary
			// I don't THINK it is
			M.z = dest_z

	// replace the turfs it's coming from with space
	for(var/turf/T in A)
		if(T.z == src_z && !istype(T, /turf/space))
			var/turf/space/S = new /turf/space(T)
			A.contents -= S
			A.contents += S

/mob/silicon/ai/proc/ai_call_shuttle()
	set category = "AI Commands"
	set name = "Call Emergency Shuttle"
	if(usr.is_dead)
		usr << "You can't call the shuttle because you are dead!"
		return
	call_shuttle()