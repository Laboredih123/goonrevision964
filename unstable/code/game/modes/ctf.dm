/mob/Login()
	..()
	src.verbs += /mob/proc/show_ctf

/mob/proc/show_ctf()
	if (ticker)
		usr << "Too late... The game has already started!"
		return
	else
		if (!( ctf ))
			ctf = new /obj/ctf_assist(  )
		ctf.show_screen(usr)
	return

/obj/team/proc/process()

	if (src.base)
		var/obj/starting = locate(text("landmark*CTF-base-[]", src.base))
		while(locate(text("landmark*CTF-supply-[]", src.base)))
			var/obj/L = locate(text("landmark*CTF-supply-[]", src.base))
			var/obj/item/weapon/card/id/I = new /obj/item/weapon/card/id( L.loc )
			I.access = get_access("Captain")
			I.assignment = "Captain"
			I.registered = text("[]", uppertext((src.color ? src.color : "rogue")))
			I.name = text("[]'s ID Card ([])", I.registered, I.assignment)
			var/obj/item/weapon/paper/flag/F = new /obj/item/weapon/paper/flag( L.loc )
			if (src.color)
				F.icon_state = text("flag_[]", src.color)
				F.name = text("flag- '[] Team's Flag'", uppertext(src.color))
			else
				F.name = "flag- 'NEUTRAL Team's Flag'"
				F.icon_state = "flag_neutral"
			F.info = text("This is an authentic [] flag!\n<font face=vivaldi>Capture the Flag</font>", (src.color ? src.color : "neutral"))
			if (src.master.paint_cans)
				var/obj/item/weapon/paint/P = new /obj/item/weapon/paint( L.loc )
				if (src.color)
					P.color = src.color
					P.icon_state = text("paint_[]", src.color)
				else
					P.color = "neutral"
					P.icon_state = text("paint_[]", src.color)
			//L = null
			del(L)
		while(locate(text("landmark*CTF-wardrobe-[]", src.base)))
			var/obj/L = locate(text("landmark*CTF-wardrobe-[]", src.base))
			switch(src.color)
				if("blue")
					new /obj/closet/wardrobe( L.loc )
				if("green")
					new /obj/closet/wardrobe/green( L.loc )
				if("yellow")
					new /obj/closet/wardrobe/yellow( L.loc )
				if("black")
					new /obj/closet/wardrobe/black( L.loc )
				if("white")
					new /obj/closet/wardrobe/white( L.loc )
				if("red")
					new /obj/closet/wardrobe/red( L.loc )
				else
			//L = null
			del(L)
		if (starting)
			for(var/mob/carbon/H in src.members)
				H.loc = starting.loc
				if ((src.master.autodress && src.color))
					H.jumpsuit = null
					del(H.jumpsuit)
					H.shoes = null
					del(H.shoes)
					switch(src.color)
						if("blue")
							H.jumpsuit = new /obj/item/weapon/clothing/under/blue( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						if("green")
							H.jumpsuit = new /obj/item/weapon/clothing/under/green( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/black( H )
						if("yellow")
							H.jumpsuit = new /obj/item/weapon/clothing/under/yellow( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/orange( H )
						if("black")
							H.jumpsuit = new /obj/item/weapon/clothing/under/black( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/black( H )
						if("white")
							H.jumpsuit = new /obj/item/weapon/clothing/under/white( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						if("red")
							H.jumpsuit = new /obj/item/weapon/clothing/under/red( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						else
							H.jumpsuit = new /obj/item/weapon/clothing/under/orange( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/orange( H )
					H.jumpsuit.layer = 20
					H.shoes.layer = 20
				//Foreach goto(507)
	return

/obj/team/proc/show_screen(user as mob)

	var/dat = "<H1>CTF Team</H1><HR><PRE>"
	dat += text("<A href='?src=\ref[];disband=1'>\[disband\]</A>\n", src)
	dat += text("Max Players: <A href='?src=\ref[];max_players=1'>[]</A>\n", src, src.max_players)
	dat += text("Captain: <A href='?src=\ref[];captain=1'>[]</A>\n", src, (src.captain ? src.captain : "NONE"))
	dat += "<B>Members:</B>\n"
	for(var/mob/M in src.members)
		dat += text("\t[] ([])\n", M.rname, M.key)
		//Foreach goto(79)
	dat += text("Base: \t<A href='?src=\ref[];base=1'>[]</A>\nColor: \t<A href='?src=\ref[];color=1'>[]</A>\n\n<A href='?src=\ref[];nothing=1'>Refresh</A>", src, src.base, src, src.color, src)
	dat += "</PRE>"
	user << browse(dat, "window=ctf_team")
	return

/obj/team/Topic(href, href_list)
	..()
	if (ticker)
		return
	if ((usr.CanAdmin() || usr == src.captain))
		if (href_list["color"])
			var/t = input(usr, "Please select a new color", null, null)  as null|anything in src.master.avail_colors
			if ((t && src.master.avail_colors.Find(t)))
				src.master.avail_colors -= t
				src.master.avail_colors += src.color
				src.color = t
		if (href_list["base"])
			var/t = input(usr, "Please select a new base", null, null)  as null|anything in src.master.avail_bases
			if ((t && src.master.avail_bases.Find(t)))
				src.master.avail_bases -= t
				src.master.avail_bases += src.base
				src.base = t
	if (usr.CanAdmin())
		if (href_list["disband"])
			//SN src = null
			del(src)
			return
		if (href_list["max_players"])
			src.max_players = input(usr, "What is the max number of players on this team?", null, null)  as num
			src.max_players = max(src.max_players, 1)
		if (href_list["captain"])
			var/L = list(  )
			for(var/mob/carbon/H in world)
				if (H.client)
					L += H
				//Foreach goto(331)
			for(var/obj/team/T in world)
				L -= T.members
				L -= T.captain
				//Foreach goto(370)
			var/mob/m = input(usr, "Please select a new captain", null, null)  as null|anything in L
			if (ismob(m))
				src.members -= src.captain
				src.members += m
				src.captain = m
			else
				src.members -= src.captain
				src.captain = null
			show_screen(src.captain)
		src.show_screen(usr)
	for(var/mob/carbon/H in world)
		if ((H.CanAdmin() || H == src.captain))
			src.master.show_screen(H)
		//Foreach goto(510)
	return

/obj/ctf_assist/New()

	..()
	going = 0
	master_mode = "extended"
	world << "<B>Capture the Flag Mode activated!</B>"
	world << "<B>The game start has been frozen to accomodate!</B>"
	for(var/obj/begin/B in world)
		if (!( locate(/obj/grille, B.loc) ))
			new /obj/grille( B.loc )
	for(var/mob/carbon/M in world)
		var/client/C = M.client
		C.mob = new /mob/prespawn
		del(M)
	world << "<B>All players have been pushed back!</B>"
	return

/obj/ctf_assist/proc/next_pick()

	src.pickers_left -= src.picker
	src.picker = null
	if (src.players_left.len < 1)
		world << "<B>We are done picking! (No more people to be picked!)</B>"
		src.picker = 0
		return null
	if (src.pickers_left.len < 1)
		for(var/obj/team/T in src)
			if ((T.members.len < src.play_team && T.members.len < T.max_players))
				if (T.captain)
					src.pickers_left += T.captain
				else
					src.pickers_left += T
			//Foreach goto(78)
	if (src.pickers_left.len < 1)
		world << "<B>We are done picking! (All teams are full!)</B>"
		src.picker = 0
		return null
	else
		src.picker = pick(src.pickers_left)
		if (ismob(src.picker))
			show_pick(src.picker)
			world << text("<B>[] is picking!</B>", src.picker)
		else
			if (istype(src.picker, /obj/team))
				var/H = pick(src.players_left)
				var/obj/team/T = src.picker
				if (istype(T, /obj/team))
					T.members += H
					src.players_left -= H
					spawn( 0 )
						next_pick()
						return
	return src.picker
	return

/obj/ctf_assist/proc/show_pick(user as mob)

	var/dat = "<H1>CTF Mode Pick</H1><HR>"
	dat += text("<B>Players (per Team): []</B><BR>\n<B>\"Please Pick a Player</B><BR>", src.play_team)
	for(var/mob/carbon/H in src.players_left)
		dat += text("<A href='?src=\ref[];pick=\ref[]'>[] ([])</A><BR>", src, H, H.spawn_name, H.key)
		//Foreach goto(39)
	user << browse(dat, "window=ctf_pick")
	return

/obj/ctf_assist/proc/get_team(captain as mob)

	for(var/obj/team/T in src)
		if (T.captain == captain)
			return T
		//Foreach goto(15)
	return

/obj/ctf_assist/proc/check_win(O as obj)

	if (src.wintype == "none")
		return
	var/obj/item/weapon/paper/flag/F = locate(/obj/item/weapon/paper/flag)
	var/winning = 1
	for(var/obj/item/weapon/paper/flag/L in world)
		if (F.icon_state != L.icon_state)
			winning = 0
		else
			if (src.wintype == "collect")
				if (F.loc != O)
					winning = 0
		//Foreach goto(45)
	if (!( winning ))
		return
	var/obj/team/winner = null
	for(var/obj/team/T in src)
		if (text("flag_[]", T.color) == text("[]", F.icon_state))
			winner = T
		else
			//Foreach continue //goto(157)
	if (winner)
		world << "<H3><B>The game has been won!!!</B></H3>"
		world << text("<B>Team: [] Team led by [] in []</B>", uppertext(winner.color), winner.captain, winner.base)
		world << "<B>Original Members:</B>"
		for(var/mob/carbon/H in winner.members)
			if (H.client)
				world << text("\t [] ([])", H.spawn_name, H.key)
			//Foreach goto(266)
	return

/obj/ctf_assist/proc/show_screen(user as mob)

	var/dat = "<H2>CTF Mode Helper</H2><HR><PRE>"
	dat += text("Players (per Team): <A href='?src=\ref[];play_team=1'>[]</A>\nBarrier Time: <A href='?src=\ref[];barriertime=1'>[] minutes</A>\n\n<B>Teams:</B>\n", src, src.play_team, src, src.barriertime)
	for(var/obj/team/O in src)
		if (ismob(O.captain))
			if (O.color)
				dat += text("\t<A href='?src=\ref[];team=\ref[]'>[]'s Team ([])</A>\n", src, O, O.captain, O.color)
			else
				dat += text("\t<A href='?src=\ref[];team=\ref[]'>[]'s Team</A>\n", src, O, O.captain)
		else
			if (O.color)
				dat += text("\t<A href='?src=\ref[];team=\ref[]'>[] Team</A>\n", src, O, O.color)
			else
				dat += text("\t<A href='?src=\ref[];team=\ref[]'>No Captain</A>\n", src, O)
		//Foreach goto(43)
	dat += text("<A href='?src=\ref[];add_team=1'>\[Add Team\]</A>\n<A href='?src=\ref[];select_team=1'>Captains Select Members</A>\n\n<A href='?src=\ref[];start=1'>Start the Game (and Set up Map)</A>\n\n<B>Win Options: []</B>\n<A href='?src=\ref[];win=collect'>Collection</A> - All flags same color on clipboard\n<A href='?src=\ref[];win=convert'>Conversion</A> - All flags same color\n<A href='?src=\ref[];win=none'>None</A>\n\n<B>Other Options:</B>\nAuto-Dress (Teams): <A href='?src=\ref[];autodress=1'>[]</A>\nRemove Engine Ejection: <A href='?src=\ref[];ejectengine=1'>[]</A>\nPaint Cans: <A href='?src=\ref[];paint_cans=1'>[]</A>\nImmobile flags (Territory): <A href='?src=\ref[];immobile=1'>[]</A>\nAdd Neutral Flags to Unused Bases: <A href='?src=\ref[];neutral_replace=1'>[]</A>\n\n<A href='?src=\ref[];nothing=1'>Refresh</A>", src, src, src, src.wintype, src, src, src, src, (src.autodress ? "Yes" : "No"), src, (src.ejectengine ? "Yes" : "No"), src, (src.paint_cans ? "Yes" : "No"), src, (src.immobile ? "Yes" : "No"), src, (src.neutral_replace ? "Yes" : "No"), src)
	dat += "</PRE>"
	user << browse(dat, "window=ctf_assist")
	return

/obj/ctf_assist/Topic(href, href_list)
	..()
	if ((ticker || src.starting))
		return
	if (href_list["pick"])
		if (src.picker == usr)
			var/H = locate(href_list["pick"])
			if ((istype(H, /mob/carbon) && src.players_left.Find(H)))
				var/obj/team/T = get_team(src.picker)
				if (istype(T, /obj/team))
					T.members += H
					src.players_left -= H
					next_pick()
			return
		else
			usr << "<B>It's not your turn!</B>"
	if (!( usr.CanAdmin() ))
		return
	if (href_list["team"])
		var/obj/team/T = locate(href_list["team"])
		if (istype(T, /obj/team))
			T.show_screen(usr)
	if (href_list["play_team"])
		src.play_team = input(usr, "What is the max number of players per team?", null, null)  as num
		src.play_team = max(src.play_team, 1)
	if (href_list["barriertime"])
		src.barriertime = input(usr, "What is the barrier life time (in minutes- decimals allowed)?", null, null)  as num
		src.barriertime = max(src.barriertime, 0.1)
	if (href_list["win"])
		if ((href_list["win"] in list( "collect", "convert", "none" )))
			src.wintype = href_list["win"]
	if (href_list["autodress"])
		src.autodress = !( src.autodress )
	if (href_list["ejectengine"])
		src.ejectengine = !( src.ejectengine )
	if (href_list["paint_cans"])
		src.paint_cans = !( src.paint_cans )
	if (href_list["neutral_replace"])
		src.neutral_replace = !( src.neutral_replace )
	if (href_list["immobile"])
		src.immobile = !( src.immobile )
	if (href_list["add_team"])
		if (src.avail_bases.len > 0)
			var/obj/team/T = new /obj/team( src )
			T.master = src
			T.base = pick(src.avail_bases)
			T.color = pick(src.avail_colors)
			src.avail_bases -= T.base
			src.avail_colors -= T.color
	if (href_list["select_team"])
		if (!( src.picking ))
			src.picking = 1
			for(var/mob/carbon/H in world)
				src.players_left += H
				//Foreach goto(578)
			for(var/obj/team/T in src)
				if (T.members.len < src.play_team)
					if (T.captain)
						src.pickers_left += T.captain
					else
						src.pickers_left += T
				src.players_left -= T.members
				//Foreach goto(618)
			if ((!( src.players_left.len ) || !( src.pickers_left.len )))
				src.picking = 0
				src.players_left.len = 0
				src.pickers_left.len = 0
				usr << "<B>Not enough players/teams!</B>"
				return
			world << "<B>Now Selecting Teams!!!</B>"
			src.picker = pick(src.pickers_left)
			if (ismob(src.picker))
				show_pick(src.picker)
				world << text("<B>[] is picking!</B>", src.picker)
			else
				if (istype(src.picker, /obj/team))
					var/H = pick(src.players_left)
					var/obj/team/T = src.picker
					if (istype(T, /obj/team))
						T.members += H
						src.players_left -= H
						next_pick()
		else
			show_pick(src.picker)
			world << text("<B>[] is picking!</B>", src.picker)
	if (href_list["start"])
		src.starting = 1
		var/obj/begin/use_me = locate(/obj/begin)
		for(var/mob/carbon/H in world)
			if (H.client)
				H.occupation1 = pick("Staff Assistant", "Research Assistant", "Technical Assistant", "Medical Assistant")
				H.update_face()
			//Foreach goto(923)
		world << "<B>STARTING!!!</B>"
		for(var/obj/landmark/alterations/A in world)
			switch(A.name)
				if("prison shuttle")
					new /obj/machinery/computer/prison_shuttle( A.loc )
					//A = null
					del(A)
				if("id computer")
					new /obj/machinery/computer/card( A.loc )
					//A = null
					del(A)
				if("Experimental Technology")
					new /obj/secloset/highsec( A.loc )
					//A = null
					del(A)
				if("Security Locker")
					new /obj/secloset/security1( A.loc )
					//A = null
					del(A)
				if("recharger")
					new /obj/machinery/recharger( A.loc )
					//A = null
					del(A)
				if("barrier")
					new /obj/barrier( A.loc )
					//A = null
					del(A)
		for(var/obj/closet/wardrobe/W in world)
			//W = null
			del(W)
			//Foreach goto(1238)
		for(var/obj/item/weapon/clothing/under/T in world)
			//T = null
			del(T)
			//Foreach goto(1281)
		if (src.ejectengine)
			for(var/obj/machinery/computer/engine/T in world)
				//T = null
				del(T)
				//Foreach goto(1333)
		for(var/obj/landmark/alterations/A in world)
			switch(A.name)
				if("Prisoners Wardrobe")
					new /obj/closet/wardrobe/orange( A.loc )
					//A = null
					del(A)
		var/obj/rogue = locate("landmark*CTF-rogue")
		for(var/mob/carbon/H in world)
			H.loc = rogue.loc
			H.jumpsuit = new /obj/item/weapon/clothing/under/orange( H )
			H.jumpsuit.layer = 20
			H.shoes = new /obj/item/weapon/clothing/shoes/orange( H )
			H.shoes.layer = 20
			//Foreach goto(1453)
		for(var/obj/team/T in src)
			T.process()
			//Foreach goto(1545)
		if (src.paint_cans)
			for(var/obj/secloset/highsec/S in world)
				new /obj/item/weapon/paint( S )
				//Foreach goto(1595)
		if (src.neutral_replace)
			while(src.avail_bases.len > 0)
				var/t = pick(src.avail_bases)
				src.avail_bases -= t
				var/obj/L = locate(text("landmark*CTF-supply-[]", t))
				var/obj/item/weapon/paper/flag/F = new /obj/item/weapon/paper/flag( L.loc )
				F.name = "flag- 'NEUTRAL Team's Flag'"
				F.icon_state = "flag_neutral"
				F.info = "This is an authentic neutral flag!\n<font face=vivaldi>Capture the Flag</font>"
				//L = null
				del(L)
		for(var/obj/begin/B in world)
			if (locate(/obj/grille, B.loc))
				for(var/obj/grille/G in B.loc)
					//G = null
					del(G)
					//Foreach goto(1789)
			//Foreach goto(1742)
		ticker = new /datum/control/gameticker(  )
		spawn( 0 )
			ticker.process()
			return
		data_core = new /obj/datacore(  )
	src.show_screen(usr)
	for(var/mob/carbon/H in world)
		if (H.CanAdmin())
			src.show_screen(H)
	return

/obj/item/weapon/clipboard/attackby(obj/item/weapon/P as obj, mob/user as mob)
	..()
	if (istype(P, /obj/item/weapon/paper/flag))
		if (ctf)
			ctf.check_win(src)