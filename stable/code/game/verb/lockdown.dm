var/locked_down = 0

/proc/begin_lockdown(mob/originator)
	if(locked_down)	return 0
	locked_down = 1

//	station_announce("Lockdown initiated by [originator.name]!")
	world << "\blue Lockdown initiated by [originator.name]!"

	for(var/obj/machinery/firealarm/FA in world)	// activate firealarms
		spawn(0)
			FA.alarm()

	for(var/obj/machinery/door/airlock/AL in world) // close airlocks
		spawn(0)
			if(AL.close())
				AL.locked = 1 // and seal 'em
	return 1

/proc/end_lockdown(mob/originator)
	if(!locked_down)	return 0
	locked_down = 0

//	station_announce("Lockdown cancelled by [originator.name]!")
	world << "\blue Lockdown cancelled by [originator.name]!"

	for(var/obj/machinery/firealarm/FA in world)
		spawn(0)
			FA.reset()

	for(var/obj/machinery/door/airlock/AL in world) //	unlock airlocks
		if(AL.locked && AL.arePowerSystemsOn())
			AL.locked = 0
	return 1