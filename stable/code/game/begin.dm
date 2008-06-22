/obj/begin/verb/ready()
	set src in usr.loc

	while (world.time < 60)
		sleep(10) //attempted temporary fix for "people dont spawn when they do ready"
		//assumes it's a lag issue
		//TODO: actually fix the bug


	if (!usr.client.authenticated)
		src << "You are not authorized to enter the game."
		return

	if (!istype(usr, /mob/human) || usr.start)
		usr << "You have already started!"
		return

	var/mob/human/M = usr
	for (var/mob/human/H in world)
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

	M.verbs -= /mob/human/verb/char_setup
	M.start = 1
	M.update_face()
	M.update_body()

	sleep(20) // people sometimes don't spawn, this might fix it and anyways this is all getting ripped out soon

	enter()

/obj/begin/proc/enter()

	world.log_game("[usr.key] entered as [usr.name]")

	if (!enter_allowed)
		usr << "\blue There is an administrative lock on entering the game!"
		return

	if (!usr.start || !istype(usr, /mob/human))
		usr << "\blue <B>You aren't ready! Use the ready verb on this pad to set up your character!</B>"
		return

	if (ctf)
		var/obj/rogue = locate("landmark*CTF-rogue")
		usr.loc = rogue.loc
		usr << "<B>It's CTF mode. You are a late joiner so you are a Rogue!</B>"
		usr << "\blue Now teleporting."
		if (ticker)
			var/mob/H = usr
			if (istype(H, /mob/human))
				reg_dna[text("[]", H.primary.uni_identity)] = H.rname
		return

	var/mob/human/M = usr
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

	if (!usr.start || !istype(usr, /mob/human) || usr.loc != src.loc)
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
				var/obj/O = new /mob/monkey(S.loc)
				M.client.mob = O
				O.loc = S.loc
				del(M)
			else
				M.loc = S.loc		//was O.loc
	else
		if (isturf(S))
			M << "\blue Now teleporting."
			M.loc = S

/obj/begin/proc/get_dna_ready(var/mob/user as mob)
	var/mob/human/M = user

	if (!M.primary)
		var/t2

		M.r_hair = M.nr_hair
		M.b_hair = M.nb_hair
		M.g_hair = M.ng_hair
		M.s_tone = M.ns_tone
		var/t1 = rand(1000, 1500)
		dna_ident += t1
		if (dna_ident > 65536)
			dna_ident = rand(1, 1500)
		M.primary = new /obj/dna(null)
		M.primary.uni_identity  = add_zero(num2hex(dna_ident), 4)
		M.primary.uni_identity += add_zero(num2hex(M.nr_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.ng_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.nb_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.r_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(M.g_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(M.b_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(-M.ns_tone + 35), 2)

		if (M.gender == "male")
			t2 = "[num2hex(rand(  1, 124))]"
		else
			t2 = "[num2hex(rand(127, 250))]"

		if (length(t2) < 2)
			M.primary.uni_identity = text("[]0[]", M.primary.uni_identity, t2)
		else
			M.primary.uni_identity = text("[][]", M.primary.uni_identity, t2)

		M.primary.spec_identity = "5BDFE293BA5500F9FFFD500AAFFE"
		M.primary.struc_enzyme = "CDE375C9A6C25A7DBDA50EC05AC6CEB63"

		if (rand(1, 3125) == 13)
			M.need_gl = 1
			M.be_epil = 1
			M.be_cough = 1
			M.be_tur = 1
			M.be_stut = 1

		var/b_vis
		if (M.need_gl)
			b_vis = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			M.disabilities = M.disabilities | 1
			M << "\blue You need glasses!"
		else
			b_vis = "5A7"

		var/epil
		if (M.be_epil)
			epil = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			M.disabilities = M.disabilities | 2
			M << "\blue You are epileptic!"
		else
			epil = "6CE"

		var/cough
		if (M.be_cough)
			cough = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			M.disabilities = M.disabilities | 4
			M << "\blue You have a chronic coughing syndrome!"
		else
			cough = "EC0"

		var/Tourette
		if (M.be_tur)
			epil = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			M.disabilities = M.disabilities | 8
			M << "\blue You have Tourette syndrome!"
		else
			Tourette = "5AC"

		var/stutter
		if (M.be_stut)
			stutter = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			M.disabilities = M.disabilities | 16
			M << "\blue You have a stuttering problem!"
		else
			stutter = "A50"

		M.primary.struc_enzyme = "CDE375C9A6C2[b_vis]DBD[stutter][cough][Tourette][epil]B63"
		M.primary.use_enzyme = "493DB249EB6D13236100A37000800AB71"
		M.primary.n_chromo = 28
