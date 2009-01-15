/var/const/SHUTTLE_Z = 2 //where it starts
/var/const/SHUTTLE_CALLED_Z = 1
/var/shuttle_loc = SHUTTLE_Z

/var/const/SHUTTLE_TIME = 6000 //tenths of a second - 10 minutes
/var/const/SHUTTLE_TIME_DOCKED = 600 * 3 // 3 minutes
/var/const/SHUTTLE_TIME_SPED_UP = 100 // 10 seconds
/var/shuttle_time_left
/var/last_shuttle_update

/var/const/SHUTTLE_WAITING = 0
/var/const/SHUTTLE_COMING = 1
/var/const/SHUTTLE_RETURNING = 2
/var/const/SHUTTLE_DOCKED = 3
/var/const/SHUTTLE_LEFT = 4

/var/shuttle_status = SHUTTLE_WAITING

/proc/call_shuttle() //does not bring the shuttle, just starts the countdown
	if(shuttle_status == SHUTTLE_WAITING)
		spawn() process_shuttle()
	if(shuttle_status == SHUTTLE_WAITING || shuttle_status == SHUTTLE_RETURNING)
		shuttle_status = SHUTTLE_COMING
		shuttle_time_left = SHUTTLE_TIME
		last_shuttle_update = world.realtime
		announce_shuttle()
	else if(shuttle_status == SHUTTLE_COMING)
		announce_shuttle()

/proc/announce_shuttle()
	world << "The shuttle has been called and will arrive in [shuttle_time_left/600] minutes."

/proc/process_shuttle()
	if(shuttle_status == SHUTTLE_RETURNING)
		if(shuttle_time_left >= SHUTTLE_TIME)
			shuttle_status = SHUTTLE_WAITING
		else
			var/curtime = world.realtime
			shuttle_time_left = min(SHUTTLE_TIME, shuttle_time_left + curtime - last_shuttle_update)
			last_shuttle_update = curtime
			sleep(5)
			process_shuttle()
	else if(shuttle_status == SHUTTLE_COMING)
		if(shuttle_time_left <= 0)
			shuttle_status = SHUTTLE_DOCKED
			shuttle_time_left = SHUTTLE_TIME_DOCKED
			last_shuttle_update = world.realtime
			shuttle_move(SHUTTLE_Z, SHUTTLE_CALLED_Z)
			sleep(5)
			process_shuttle()
		else
			var/curtime = world.realtime
			shuttle_time_left = max(0, shuttle_time_left - (curtime - last_shuttle_update))
			last_shuttle_update = curtime
			sleep(5)
			process_shuttle()
	else if(shuttle_status == SHUTTLE_DOCKED)
		if(shuttle_time_left <= 0)
			shuttle_status = SHUTTLE_LEFT
			shuttle_move(SHUTTLE_CALLED_Z, SHUTTLE_Z)
		else
			var/curtime = world.realtime
			shuttle_time_left = max(0, shuttle_time_left - (curtime - last_shuttle_update))
			last_shuttle_update = curtime
			sleep(5)
			process_shuttle()

/proc/shuttle_move(src_z, dest_z)

	return