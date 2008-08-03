/mob/silicon/ai/cancel_camera()
	set category = "AI Commands"
	..()

/mob/silicon/ai/proc/lockdown()
	set name = "Lockdown"
	set category = "AI Commands"

	if(!src.is_active())
		src <<"You cannot initiate lockdown because you are dead!"
		return

	src.cancel_camera()
	world << "\red Lockdown initiated by [src.name]!"

	for(var/obj/machinery/firealarm/FA in world)	//	activate firealarms
		spawn(0)
			FA.alarm()

	for(var/obj/machinery/door/airlock/AL in world) //	close airlocks
		spawn( 0 )
			if(AL.close())
				AL.locked = 1						//	and seal 'em

	src << "\red Lockdown command removed for 10 seconds."

	src.verbs -= /mob/silicon/ai/proc/lockdown
	src.verbs += /mob/silicon/ai/proc/disablelockdown

	spawn(100)	//	wait 10 seconds
		src.verbs += /mob/silicon/ai/proc/lockdown

/mob/silicon/ai/proc/disablelockdown()
	set name = "Disable Lockdown"
	set category = "AI Commands"

	if(!src.is_active())
		src <<"You cannot disable lockdown because you are dead!"
		return

	src.cancel_camera()
	world << "\red Lockdown cancelled by [src.name]!"

	for(var/obj/machinery/firealarm/FA in world)
		spawn(0)
			FA.reset()

	for(var/obj/machinery/door/airlock/AL in world) //	open airlocks
		if(AL.locked && AL.arePowerSystemsOn())
			AL.locked = 0

	src << "\red Disable lockdown command disabled until lockdown engaged again!"
	src.verbs -= /mob/silicon/ai/proc/disablelockdown
