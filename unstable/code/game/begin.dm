/*/obj/begin/verb/ready()
	set src in usr.loc

	if (!usr.client.authenticated)
		src << "You are not authorized to enter the game."
		return

	if (!istype(usr, /mob/carbon) || usr.start)
		usr << "You have already started!"
		return

	var/mob/carbon/M = usr
	for (var/mob/carbon/H in world)
		if (H.start && cmptext(H.rname,M.rname))
			usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
			return
	src.get_dna_ready(M)

	if (ticker)
		var/list/L = assistant_occupations
		var/job
		if (L.Find(M.occupation1))
			job = M.occupation1
		else if (L.Find(M.occupation2))
			job = M.occupation2
		else if (L.Find(M.occupation3))
			job = M.occupation3
		else
			job = pick(L)
		var/joined_late = 1
		M.Assign_Rank(job, joined_late)

	M.verbs -= /mob/carbon/verb/char_setup
	M.start = 1
	M.update_face()
	M.update_body()

	enter()

/obj/begin/proc/enter()

	world.log_game("[usr.key] entered as [usr.name]")

	if (!enter_allowed)
		usr << "\blue There is an administrative lock on entering the game!"
		return

	if (!usr.start || !istype(usr, /mob/carbon))
		usr << "\blue <B>You aren't ready! Use the ready verb on this pad to set up your character!</B>"
		return

	if (ctf)
		var/obj/rogue = locate("landmark*CTF-rogue")
		usr.loc = rogue.loc
		usr << "<B>It's CTF mode. You are a late joiner so you are a Rogue!</B>"
		usr << "\blue Now teleporting."
		if (ticker)
			var/mob/H = usr
			if (istype(H, /mob/carbon))
				reg_dna[text("[]", H.primary.uni_identity)] = H.rname
		return

	var/mob/carbon/M = usr
	var/list/start_loc = list()

	var/area/A = locate(/area/arrival/start)
	var/list/L = list(  )
	for(var/turf/T in A)
		if(T.isempty())
			L += T

	start_loc["SS13"] = pick(L)

	if (locate("spstart[M.ckey]"))
		for (var/obj/sp_start/S in world)
			if (S.tag == text("spstart[M.ckey]"))
				start_loc[S.desc] = S

	var/option = input(M, "Where should you start?", "Start Selector", null) in start_loc

	if (!usr.start || !istype(usr, /mob/carbon) || usr.loc != src.loc)
		return

	if (ticker)
		reg_dna[M.primary.uni_identity] = M.rname

	var/obj/sp_start/S = start_loc[option]

	if (istype(S, /obj/sp_start))
		M << "\blue Now teleporting to special location."

		if (S.special == 2)
			for(var/obj/O in M)
				del(O)
			M.loc = S.loc
		else
			if (S.special == 3)
				for(var/obj/O in M)
					del(O)
				var/obj/O = new /mob/carbon/monkey(S.loc)
				M.client.mob = O
				O.loc = S.loc
				del(M)
			else
				M.loc = S.loc		//was O.loc
	else
		if (isturf(S))
			M << "\blue Now teleporting."
			M.loc = S
*/