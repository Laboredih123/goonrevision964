/proc/camera_sort(list/L)
	var/obj/machinery/camera/a
	var/obj/machinery/camera/b

	for (var/i = L.len, i > 0, i--)
		for (var/j = 1 to i - 1)
			a = L[j]
			b = L[j + 1]
			if (a.c_tag_order != b.c_tag_order)
				if (a.c_tag_order > b.c_tag_order)
					L.Swap(j, j + 1)
			else
				if (sorttext(a.c_tag, b.c_tag) < 0)
					L.Swap(j, j + 1)
	return L

/obj/machinery/computer/security/attack_hand(var/mob/user as mob)
	if (stat & (NOPOWER|BROKEN))
		return

	user.machine = src

	var/list/L = list()
	for (var/obj/machinery/camera/C in world)
		L.Add(C)

	camera_sort(L)

	var/list/D = list()
	D["Cancel"] = "Cancel"
	for (var/obj/machinery/camera/C in L)
		if (C.network == src.network)
			D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C

	var/t = input(user, "Which camera should you change to?") as null|anything in D

	if(!t)
		user.machine = null
		return 0

	var/obj/machinery/camera/C = D[t]

	if (t == "Cancel")
		user.machine = null
		return 0

	if ((get_dist(user, src) > 1 || user.machine != src || user.blinded || !( user.canmove ) || !( C.status )) && (!istype(user, /mob/ai)))
		return 0
	else
		src.current = C
		use_power(50)

		spawn( 5 )
			attack_hand(user)

/mob/ai/attack_ai(var/mob/user as mob)
	if (user != src)
		return

	if (stat == 2)
		return

	user.machine = src

	var/list/L = list()
	for (var/obj/machinery/camera/C in world)
		L.Add(C)

	camera_sort(L)

	var/list/D = list()
	D["Cancel"] = "Cancel"
	for (var/obj/machinery/camera/C in L)
		if (C.network == src.network)
			D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C

	var/t = input(user, "Which camera should you change to?") as null|anything in D

	if (!t)
		user.machine = null
		user.reset_view(null)
		return 0

	var/obj/machinery/camera/C = D[t]

	if (t == "Cancel")
		user.machine = null
		user.reset_view(null)
		return 0

	//if (user.machine != src || !( C.status ))
	if (!( C.status ))

		return 0
	else
		src.current = C
		//use_power(50)
		spawn( 5 )
			attack_ai(user)
			return
	return
