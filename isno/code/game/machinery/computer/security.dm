/obj/machinery/computer/security/New()
	..()
	if(!maplevel)
		src.verbs -= /obj/machinery/computer/security/verb/station_map

/obj/machinery/computer/security/check_eye(var/mob/user as mob)

	if((get_dist(user, src) > 1 || !( user.canmove ) || !( src.current ) || !( src.current.status )) && (!istype(user, /mob/silicon/ai)))
		return null
	if(istype(user, /mob/carbon))
		var/mob/carbon/M = user
		if(M.is_blind)
			return null
	user.reset_view(src.current)
	return 1

/obj/machinery/computer/security/interact(var/mob/user as mob)
	if(!..()) return 0
	if(istype(user, /mob/carbon))
		var/mob/carbon/M = user
		if(M.is_blind) return

	user.machine = src

	var/list/L = list()
	for (var/obj/machinery/camera/C in world) L.Add(C)
	camera_sort(L)

	var/list/D = list()
	D["Cancel"] = "Cancel"
	for(var/obj/machinery/camera/C in L)
		if(C.network == src.network)
			D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C

	var/t = input(user, "Which camera should you change to?") as null|anything in D
	if(!t)
		user.machine = null
		return 0

	var/obj/machinery/camera/C = D[t]

	if(t == "Cancel")
		user.machine = null
		return 0

	if((get_dist(user, src) > 1 || user.machine != src || !( user.canmove ) || !( C.status )) && (!istype(user, /mob/silicon/ai)))
		return 0
	src.current = C
	use_power(50)

	spawn(5)
		interact(user)
