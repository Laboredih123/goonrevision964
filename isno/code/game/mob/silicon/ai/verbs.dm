/mob/silicon/ai/cancel_camera()
	set category = "AI Commands"
	..()

/var/locked_down = 0

/mob/silicon/ai/proc/lockdown()
	set name = "Lockdown"
	set category = "AI Commands"

	if(!src.is_active())
		src <<"You cannot initiate lockdown because you are dead!"
		return

	if(src.last_lockdown + 100 > ss13time())
		src << "You locked down too recently! Wait a few seconds first."
		return

	src.last_lockdown = ss13time()

	begin_lockdown(src)

	src.verbs += /mob/silicon/ai/proc/disablelockdown

/mob/silicon/ai/proc/disablelockdown()
	set name = "Disable Lockdown"
	set category = "AI Commands"

	if(!src.is_active())
		src <<"You cannot disable lockdown because you are dead!"
		return

	end_lockdown(src)

	src << "\red Disable lockdown command disabled until lockdown engaged again!"
	while(/mob/silicon/ai/proc/disablelockdown in src.verbs)
		src.verbs -= /mob/silicon/ai/proc/disablelockdown

/proc/begin_lockdown(mob/originator)
	locked_down = 1

	station_announce("Lockdown initiated by [originator.name]!")


	for(var/obj/machinery/firealarm/FA in world)	// activate firealarms
		spawn(0)
			FA.alarm()

	for(var/obj/machinery/door/airlock/AL in world) // close airlocks
		spawn(0)
			if(AL.try_close())
				AL.locked = 1 // and seal 'em

/proc/end_lockdown(mob/originator)
	locked_down = 0

	station_announce("Lockdown cancelled by [originator.name]!")

	for(var/obj/machinery/firealarm/FA in world)
		spawn(0)
			FA.reset()

	for(var/obj/machinery/door/airlock/AL in world) //	unlock airlocks
		if(AL.locked && AL.arePowerSystemsOn())
			AL.locked = 0

/mob/silicon/ai/proc/ai_camera_track()
	set category = "AI Commands"
	set name = "Track With Camera"

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/mob/carbon/M in world)
		if(!istype(M.loc, /turf)) //in a closet or something, AI can't see him anyways
			continue
		if(M.invisibility) //cloaked
			continue
		if(M.CameraInvisible())
			continue

		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = text("[] ([])", name, namecounts[name])
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M

	var/target_name = input(usr, "Which creature should you track?") as null|anything in creatures

	if (!target_name)
		usr:cameraFollow = null
		return

	track_mob(creatures[target_name])

/mob/silicon/ai/proc/track_mob(mob/carbon/target)
	usr:cameraFollow = target
	usr << text("Now tracking [] on camera.", target.name)
	if (usr.machine == null)
		usr.machine = usr

	spawn (0)
		while (usr:cameraFollow == target)
			if (usr:cameraFollow == null)
				return
			else if (target.CameraInvisible())
				usr << "Tracking Error"
				usr:cameraFollow = null
				return
			else if (!target || !istype(target.loc, /turf)) //in a closet
				usr << "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb)."
				sleep(40) //because we're sleeping another second after this (a few lines down)
				continue

			var/obj/machinery/camera/C = usr:current
			if ((C && istype(C, /obj/machinery/camera)) || C==null)
				var/closestDist = -1
				if (C!=null)
					if (C.status)
						closestDist = get_dist(C, target)
				//usr << text("Dist = [] for camera []", closestDist, C.name)
				var/zmatched = 0
				if (closestDist > 7 || closestDist == -1)
					//check other cameras
					var/obj/machinery/camera/closest = C
					for(var/obj/machinery/camera/C2 in world)
						if (C2.network == src.network)
							if (C2.z == target.z && target in view(C2))
								zmatched = 1
								if (C2.status)
									var/dist = get_dist(C2, target)
									if ((dist < closestDist) || (closestDist == -1))
										closestDist = dist
										closest = C2
					//usr << text("Closest camera dist = [], for camera []", closestDist, closest.area.name)

					if (closest != C)
						usr:current = closest
						usr.reset_view(closest)
						//use_power(50)
					if (zmatched == 0)
						usr << "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb)."
						sleep(40) //because we're sleeping another second after this (a few lines down)
			else
				usr << "Follow camera mode ended."
				usr:cameraFollow = null

			sleep(10)
