
/obj/team/proc/process()

	if (src.base)
		var/obj/starting = locate(text("landmark*CTF-base-[]", src.base))
		while(locate(text("landmark*CTF-supply-[]", src.base)))
			var/obj/L = locate(text("landmark*CTF-supply-[]", src.base))
			var/obj/item/weapon/card/id/I = new /obj/item/weapon/card/id( L.loc )
			I.access_level = 5
			I.lab_access = 5
			I.engine_access = 5
			I.air_access = 5
			I.assignment = "Captain"
			I.registered = text("[]", uppertext((src.color ? src.color : "rogue")))
			I.name = text("[]'s ID Card ([]>[]-[]-[])", I.registered, I.access_level, I.lab_access, I.engine_access, I.air_access)
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
			for(var/mob/human/H in src.members)
				H.loc = starting.loc
				if ((src.master.autodress && src.color))
					H.w_uniform = null
					del(H.w_uniform)
					H.shoes = null
					del(H.shoes)
					switch(src.color)
						if("blue")
							H.w_uniform = new /obj/item/weapon/clothing/under/blue( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						if("green")
							H.w_uniform = new /obj/item/weapon/clothing/under/green( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/black( H )
						if("yellow")
							H.w_uniform = new /obj/item/weapon/clothing/under/yellow( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/orange( H )
						if("black")
							H.w_uniform = new /obj/item/weapon/clothing/under/black( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/black( H )
						if("white")
							H.w_uniform = new /obj/item/weapon/clothing/under/white( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						if("red")
							H.w_uniform = new /obj/item/weapon/clothing/under/red( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/brown( H )
						else
							H.w_uniform = new /obj/item/weapon/clothing/under/orange( H )
							H.shoes = new /obj/item/weapon/clothing/shoes/orange( H )
					H.w_uniform.layer = 20
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
			for(var/mob/human/H in world)
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
	for(var/mob/human/H in world)
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
		//Foreach goto(50)
	for(var/mob/human/M in world)
		M.loc = locate(/area/start)
		if (M.start)
			M.primary = null
			del(M.primary)
			for(var/obj/item/weapon/I in M)
				//M = null
				del(M)
				//Foreach goto(165)
			M.start = 0
		//Foreach goto(106)
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
	for(var/mob/human/H in src.players_left)
		dat += text("<A href='?src=\ref[];pick=\ref[]'>[] ([])</A><BR>", src, H, H.rname, H.key)
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
		for(var/mob/human/H in winner.members)
			if (H.client)
				world << text("\t [] ([])", H.rname, H.key)
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
			if ((istype(H, /mob/human) && src.players_left.Find(H)))
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
			for(var/mob/human/H in world)
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
		for(var/mob/human/H in world)
			if (H.client)
				H.start = 1
				H.occupation1 = pick("Staff Assistant", "Research Assistant", "Technical Assistant", "Medical Assistant")
				use_me.get_dna_ready(H)
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
		for(var/mob/human/H in world)
			H.loc = rogue.loc
			H.w_uniform = new /obj/item/weapon/clothing/under/orange( H )
			H.w_uniform.layer = 20
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
	for(var/mob/human/H in world)
		if (H.CanAdmin())
			src.show_screen(H)
		//Foreach goto(1881)
	return

/obj/landmark/New()

	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

	if (name == "shuttle")
		shuttle_z = src.z
		del(src)

	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y

	if (name == "monkey")
		monkeystart += src.loc
		del(src)

	if (name == "blobstart")
		blobstart += src.loc
		del(src)
	return

/obj/start/New()

	..()
	src.tag = text("start*[]", src.name)
	src.invisibility = 100
	return

/obj/sp_start/New()

	src.tag = text("spstart[]", src.name)
	src.invisibility = 100
	return

/obj/admins/Topic(href, href_list)
	..()
	if (usr.client != src.owner)
		world << text("\blue [] has attempted to override the admin panel!", usr.key)
		world.log << text("ADMIN: [] tried to use the admin panel without authorization.", usr.key)
		return


	if(href_list["vmode"])

		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			vote.mode = text2num(href_list["vmode"])-1 	// hack to yield 0=restart, 1=changemode
			vote.voting = 1						// now voting
			vote.votetime = world.timeofday + config.vote_period*10	// when the vote will end

			spawn(config.vote_period*10)
				vote.endvote()

			world << "\red<B>*** A vote to [vote.mode?"change game mode":"restart"] has been initiated by Admin [usr.key].</B>"
			world << "\red     You have [vote.timetext(config.vote_period)] to vote."

			world.log_admin("Voting to [vote.mode?"change mode":"restart round"] forced by admin [usr.key]")

			for(var/mob/CM in world)
				if(CM.client)
					CM.client.vote = "default"

	if(href_list["votekill"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))

			world << "\red <B>***Voting aborted by [usr.key].</B>"

			world.log_admin("Voting aborted by [usr.key]")

			vote.voting = 0
			vote.nextvotetime = world.timeofday + 10*config.vote_delay

			for(var/mob/M in world)		// clear vote window from all clients
				if(M.client)
					M << browse(null, "window=vote")
					M.client.showvote = 0


	if (href_list["vt_rst"])
		if (src.rank in list("Administrator", "Major Administrator", "Primary Administrator"))
			config.allow_vote_restart = !config.allow_vote_restart
			world << "<B>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</B>."

			world.log_admin("Restart voting toggled to [config.allow_vote_restart ? "On" : "Off"] by [usr.key].")

			if(config.allow_vote_restart)
				vote.nextvotetime = world.timeofday
			update()

	if (href_list["vt_mode"])
		if (src.rank in list("Administrator", "Major Administrator", "Primary Administrator"))
			config.allow_vote_mode = !config.allow_vote_mode
			world << "<B>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</B>."
			world.log_admin("Mode voting toggled to [config.allow_vote_mode ? "On" : "Off"] by [usr.key].")

			if(config.allow_vote_mode)
				vote.nextvotetime = world.timeofday
			update()

	if (href_list["boot"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Boot Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];boot2=\ref[]'>N:[] R:[] (K:[]) (IP:[])</A><BR>", src, M, M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP)
				//Foreach goto(103)
			usr << browse(dat, "window=boot")
	if (href_list["boot2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["boot2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] booted [M.key].")
				//M.client = null
				del(M.client)
	if (href_list["ban"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Ban Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];ban2=\ref[]'>N: [] R: [] (K: []) (IP: [])</A><BR>", src, M, M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP)
				//Foreach goto(362)
			dat += "<HR><B>Unban Player:</B><HR>"
			for(var/t in banned)
				dat += text("<A href='?src=\ref[];unban2=[]'>K: []</A><BR>", src, ckey(t), t)
				//Foreach goto(424)
			usr << browse(dat, "window=ban")
	if (href_list["ban2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["ban2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] banned [M.key].")
				banned += ckey(M.key)
				//M.client = null
				del(M.client)
	if (href_list["unban2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/t = href_list["unban2"]
			if (t)
				banned -= t
			world.log_admin("[usr.key] unbanned [t].")
	if (href_list["mute"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Mute/Unmute Player:</B><HR>"
			for(var/mob/M in world)
				dat += text("<A href='?src=\ref[];mute2=\ref[]'>N:[] R:[] (K:[]) (IP: []) \[[]\]</A><BR>", src, M, M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP, (M.muted ? "Muted" : "Voiced"))
				//Foreach goto(757)
			usr << browse(dat, "window=mute")
	if (href_list["mute2"])
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/mob/M = locate(href_list["mute2"])
			if (ismob(M))
				if ((M.client && M.client.holder && M.client.holder.rank >= src.rank))
					alert("You cannot perform this. Action you must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] altered [M.key]'s mute status.")
				M.muted = !( M.muted )
	if (href_list["restart"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = text("<B>Restart game?</B><HR>\n<BR>\n<A href='?src=\ref[];restart2=1'>Yes</A>\n", src)
			usr << browse(dat, "window=restart")
	if (href_list["restart2"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			world << text("\red <B> Restarting world!</B>\blue  Initiated by []!", usr.key)
			world.log_admin("[usr.key] initiated a reboot.")
			sleep(50)
			world.Reboot()
	if (href_list["restart3"])
		if ((src.rank in list( "Game Master", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			if( alert("Reboot server?",,"Yes","No") == "No")
				return
			world << text("\red <B> Rebooting world!</B>\blue  Initiated by []!", usr.key)
			world.log_admin("[usr.key] initiated an immediate reboot.")
			world.Reboot()
	if (href_list["c_mode"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			var/dat = text("<B>What mode do you wish to play?</B><HR>\n<A href='?src=\ref[];c_mode2=secret'>Secret</A><br>\n<A href='?src=\ref[];c_mode2=random'>Random</A><br>\n<A href='?src=\ref[];c_mode2=traitor'>Traitor</A><br>\n<A href='?src=\ref[];c_mode2=meteor'>Meteor</A><br>\n<A href='?src=\ref[];c_mode2=extended'>Extended</A><br>\n<A href='?src=\ref[];c_mode2=monkey'>Monkey</A><br>\n<A href='?src=\ref[];c_mode2=nuclear'>Nuclear Emergency</A><br>\n<A href='?src=\ref[];c_mode2=blob'>Blob</A><br>\n<A href='?src=\ref[];c_mode2=sandbox'>Sandbox</A><br>\n\nNow: []\n", src, src, src, src, src, src, src, src, src, master_mode)
			usr << browse(dat, "window=c_mode")
	if (href_list["c_mode2"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			switch(href_list["c_mode2"])
				if("secret")
					master_mode = "secret"
				if("random")
					master_mode = "random"
				if("traitor")
					master_mode = "traitor"
				if("meteor")
					master_mode = "meteor"
				if("extended")
					master_mode = "extended"
				if("monkey")
					master_mode = "monkey"
				if("nuclear")
					master_mode = "nuclear"
				if("megamonkey")
					master_mode = "megamonkey"
				if("blob")
					master_mode = "blob"
				if("sandbox")
					master_mode = "sandbox"
				else
			world.log_admin("[usr.key] set the mode as [master_mode].")
			world << text("\blue <B>The mode is now: []</B>", master_mode)

			var/F = file(persistent_file)
			fdel(F)
			F << master_mode

	if (href_list["l_ban"])
		var/dat = "<HR><B>Banned Keys:</B><HR>"
		for(var/t in banned)
			dat += text("[]<BR>", ckey(t))
			//Foreach goto(1424)
		if ((src.rank in list( "Moderator", "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			dat += text("<HR><A href='?src=\ref[];boot=1'>Goto Ban Control Screen</A>", src)
		usr << browse(dat, "window=ban_k")
	if (href_list["l_keys"])
		var/dat = "<B>Keys:</B><HR>"
		for(var/mob/M in world)
			if (M.client)
				dat += text("[]<BR>", M.client.ckey)
			//Foreach goto(1525)
		usr << browse(dat, "window=keys")
	if (href_list["l_players"])
		var/dat = "<B>Name/Real Name/Key/IP:</B><HR>"
		for(var/mob/M in world)
			dat += text("N: [] R: [] (K: []) (IP: [])<BR>", M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP)
			//Foreach goto(1602)
		usr << browse(dat, "window=players")
	if (href_list["g_send"])
		var/t = input("Global message to send:", "Admin Announce", null, null)  as message
		if (t)
			world << "\blue <B>[usr.key] Announces:</B>\n \t [t]"
			world.log_admin("Announce: [usr.key] : [t]")
	if (href_list["p_send"])
		var/dat = "<B>Who are you sending a message to?</B><HR>"
		for(var/mob/M in world)
			dat += "<A href='?src=\ref[usr];priv_msg=\ref[M]'>N:[M.name] R:[M.rname] (K:[(M.client ? M.client : "No client")])</A><BR>"
			//Foreach goto(1737)
		usr << browse(dat, "window=p_send")

	/*
	if (href_list["p_send2"])
		if (locate(href_list["p_send2"]))
			var/mob/M = locate(href_list["p_send2"])
			if (!( ismob(M) ))
				return
			var/t = input("Message:", text("Private message to []", M.key), null, null)  as text
			if (!( t ))
				return
			if (M.client && M.client.holder)
				M << text("\blue Admin PM from-<B><A href='?src=\ref[];p_send2=\ref[]'>[]</A></B>: []", M.client.holder, usr, usr.key, t)
			else
				M << text("\blue Admin PM from-<B>[]</B>: []", usr.key, t)
			usr << text("\blue Admin PM to-<B><A href='?src=\ref[];p_send2=\ref[]'>[]</A></B>: []", src, M, M.key, t)
			world.log_admin("PM: [usr.key]->[M.key] : [t]")
	*/

	if (href_list["m_item"])
		var/X = typesof(/obj/item/weapon)
		var/Q = input("What item?", null, null, null)  as null|anything in X
		if (!( Q ))
			return
		new Q( usr.loc )
		world.log_admin("[usr.key] created a [Q]")
	if (href_list["m_obj"])
		var/X = typesof(/obj) - typesof(/obj/item)
		var/Q = input("What object?", null, null, null)  as null|anything in X
		if (!( Q ))
			return
		new Q( usr.loc )
		world.log_admin("[usr.key] created a [Q]")
	if (href_list["dna"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = "<B>Registered DNA sequences:</B><HR>"
			for(var/M in reg_dna)
				dat += text("\t [] = []<BR>", M, reg_dna[text("[]", M)])
				//Foreach goto(2171)
			usr << browse(dat, "window=dna")
	if (href_list["t_ooc"])
		if ((src.rank in list( "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			ooc_allowed = !( ooc_allowed )
			if (ooc_allowed)
				world << "<B>The OOC channel has been globally enabled!</B>"
			else
				world << "<B>The OOC channel has been globally disabled!</B>"
			world.log_admin("[usr.key] toggled OOC.")
	if (href_list["startnow"])
		if ((src.rank in list( "Supervisor", "Administrator", "Major Administrator", "Primary Administrator" )))
			world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
			going = 1
			if (!ticker)
				ticker = new /datum/control/gameticker()
				spawn (0)
					world.log_admin("[usr.key] used start_now")
					ticker.process()
				data_core = new /obj/datacore()
	if (href_list["toggle_enter"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			enter_allowed = !( enter_allowed )
			if (!( enter_allowed ))
				world << "<B>You may no longer enter the game.</B>"
			else
				world << "<B>You may now enter the game.</B>"
			world.log_admin("[usr.key] toggled new player game entering.")
			world.update_stat()
			update()
	if (href_list["toggle_ai"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			config.allow_ai = !( config.allow_ai )
			if (!( config.allow_ai ))
				world << "<B>The AI job is no longer chooseable.</B>"
			else
				world << "<B>The AI job is chooseable now.</B>"
			world.log_admin("[usr.key] toggled AI allowed.")
			world.update_stat()
			update()
	if (href_list["toggle_abandon"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			abandon_allowed = !( abandon_allowed )
			if (abandon_allowed)
				world << "<B>You may now abandon mob.</B>"
			else
				world << "<B>Live or Die Mode Activated</B>"
				world.log_admin("[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
			world.update_stat()
			update()
	if (href_list["delay"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			if (ticker)
				return alert("Too late... The game has already started!", null, null, null, null, null)
			going = !( going )
			if (!( going ))
				world << text("<B>The game start has been delayed by [] (Administrator to SS13)</B>", usr.key)
				world.log_admin("[usr.key] delayed the game.")
			else
				world << text("<B>The game will start soon thanks to [] (Administrator to SS13)</B>", usr.key)
				world.log_admin("[usr.key] removed the delay.")
	if (href_list["secrets"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/dat = {"
<B>What secret do you wish to activate?</B><HR>
<A href='?src=\ref[src];secrets2=sec_clothes'>Remove 'internal' clothing</A><BR>
<A href='?src=\ref[src];secrets2=sec_all_clothes'>Remove ALL clothing</A><BR>
<A href='?src=\ref[src];secrets2=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
<A href='?src=\ref[src];secrets2=clear_bombs'>Remove all bombs currently  existence</A><BR>
<A href='?src=\ref[src];secrets2=list_bombers'>Show a list of all people who made a bomb</A><BR>
<A href='?src=\ref[src];secrets2=check_antagonist'>Show the key of the traitor</A><BR>
<A href='?src=\ref[src];secrets2=toxic'>Toxic Air (WARNING: dangerous)</A><BR>
<A href='?src=\ref[src];secrets2=monkey'>Turn all humans into monkies</A><BR>
<A href='?src=\ref[src];secrets2=power'>Make all areas powered</A><BR>
<A href='?src=\ref[src];secrets2=wave'>Spawn a wave of meteors</A><BR>"}

			usr << browse(dat, "window=secrets")
	if (href_list["secrets2"])
		if ((src.rank in list( "Game Master", "Administrator", "Major Administrator", "Primary Administrator" )))
			var/ok = 0
			switch(href_list["secrets2"])
				if("sec_clothes")
					for(var/obj/item/weapon/clothing/under/O in world)
						//O = null
						del(O)
						//Foreach goto(2781)
					ok = 1
				if("sec_all_clothes")
					for(var/obj/item/weapon/clothing/O in world)
						//O = null
						del(O)
						//Foreach goto(2833)
					ok = 1
				if("sec_classic1")
					for(var/obj/item/weapon/clothing/suit/firesuit/O in world)
						//O = null
						del(O)
						//Foreach goto(2885)
					for(var/obj/grille/O in world)
						//O = null
						del(O)
						//Foreach goto(2928)
					for(var/obj/machinery/vehicle/pod/O in world)
						for(var/mob/M in src)
							M.loc = src.loc
							if (M.client)
								M.client.perspective = MOB_PERSPECTIVE
								M.client.eye = M
							//Foreach goto(3001)
						//O = null
						del(O)
						//Foreach goto(2971)
					ok = 1
				if("clear_bombs")
					for(var/obj/item/weapon/assembly/r_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/m_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/t_i_ptank/O in world)
						del(O)
					ok = 1
				if("list_bombers")
					var/dat = "<B>Don't be insane about this list</B> Get the facts. They also could have disarmed one.<HR>"
					for(var/l in bombers)
						dat += text("[] 'made' a bomb.<BR>", l)
						//Foreach goto(3149)
					usr << browse(dat, "window=bombers")
				if("toxic")
					for(var/obj/machinery/atmoalter/siphs/fullairsiphon/O in world)
						O.t_status = 3
						//Foreach goto(3194)
					for(var/obj/machinery/atmoalter/siphs/scrubbers/O in world)
						O.t_status = 1
						O.t_per = 1000000.0
						//Foreach goto(3234)
					for(var/obj/machinery/atmoalter/canister/O in world)
						if (!( istype(O, /obj/machinery/atmoalter/canister/oxygencanister) ))
							O.t_status = 1
							O.t_per = 1000000.0
						else
							O.t_status = 3
						//Foreach goto(3282)
				if("check_antagonist")
					if (ticker)
						if (ticker.killer)
							if (ticker.killer.ckey)
								alert(text("The traitor's key is [].", ticker.killer.ckey), null, null, null, null, null)
							else
								alert("It seems like the traitor logged out...", null, null, null, null, null)
						else
							alert("There is no traitor.", null, null, null, null, null)
					else
						alert("The game has not started yet.", null, null, null, null, null)
				if("monkey")
					world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
					for(var/mob/human/H in world)
						H.monkeyize()
						//Foreach goto(3504)
					ok = 1
				if("power")
					world.log_admin("[usr.key] used secret [href_list["secrets2"]]")

					for(var/area/A in world)
						A.requires_power = 0
						A.power_light = 1
						A.power_equip = 1
						A.power_environ = 1

						A.power_change()
				if("wave")
					world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
					meteor_wave()
				else
			if (usr)
				world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
				if (ok)
					world << text("<B>A secret has been activated by []!</B>", usr.key)
	return

/obj/admins/proc/update()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Game Master")
			lvl = 2
		if("Supervisor")
			lvl = 3
		if("Administrator")
			lvl = 4
		if("Major Administrator")
			lvl = 5
		if("Primary Administrator")
			lvl = 6



	switch(src.screen)
		if(1.0)

			dat += "<center><B>Admin Control Console</B></center><hr>\n"

			if(lvl>=4)
				dat += {"
	<A href='?src=\ref[src];boot=1'>Boot Player/Key</A><br>
	<A href='?src=\ref[src];ban=1'>Ban/Unban Player/Key</A><br>
	<A href='?src=\ref[src];mute=1'>Mute/Unmute Player/Key</A><br>
	"}
			dat += "<br>"

			if(lvl!=1)
				dat += "<A href='?src=\ref[src];t_ooc=1'>Toggle OOC</A><br>"
				dat += "<A href='?src=\ref[src];delay=1'>Delay Game</A><br>"
				dat += "<A href='?src=\ref[src];startnow=1'>Start Round Now</A><br>"

			if(lvl >=3 )
				dat += "<A href='?src=\ref[src];toggle_enter=1'>Toggle Entering [enter_allowed]</A><br>"
				dat += "<A href='?src=\ref[src];toggle_abandon=1'>Toggle Abandon [abandon_allowed]</A><br>"
				dat += "<A href='?src=\ref[src];toggle_ai=1'>Toggle AI [config.allow_ai]</A><br>"

				dat += "<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>"
			if(lvl >= 2)
				dat += "<A href='?src=\ref[src];restart=1'>Restart Game</A><br>"
				dat += "<A href='?src=\ref[src];restart3=1'>Immediate Reboot</A><br>"

			dat += "<BR>"

			if(lvl!=1)
				dat += "<A href='?src=\ref[src];vmode=1'>Begin restart vote.</A><BR>"
				dat += "<A href='?src=\ref[src];vmode=2'>Begin change mode vote.</A><BR>"
				dat += "<A href='?src=\ref[src];votekill=1'>Abort current vote.</A><BR>"

			if(lvl>=3)
				dat += "<A href='?src=\ref[src];vt_rst=1'>Toggle restart voting [config.allow_vote_restart].</A><BR>"
				dat += "<A href='?src=\ref[src];vt_mode=1'>Toggle mode voting [config.allow_vote_mode].</A><BR>"

			dat += "<BR>"

			if(lvl >=3 )
				dat += "<A href='?src=\ref[src];secrets=1'>Activate Secrets</A><br>"
				dat += "<A href='?src=\ref[src];m_item=1'>Make Item</A><br>"
				dat += "<A href='?src=\ref[src];m_obj=1'>Make Object</A><br>"

			dat += "<BR>"
			if(lvl >=3 )

				dat += "<A href='?src=\ref[src];dna=1'>List DNA</A><br>"
				dat += "<A href='?src=\ref[src];l_keys=1'>List Keys</A><br>"
				dat += "<A href='?src=\ref[src];l_players=1'>List Players/Keys</A><br>"

			dat += "<A href='?src=\ref[src];g_send=1'>Send Global Message</A><br>"
			dat += "<A href='?src=\ref[src];p_send=1'>Send Private Message</A><br>"


		else
			dat = text("<center><B>Admin Control Center</B></center><hr>\n<A href='?src=\ref[];access=1'>Access Admin Commands</A><br>\n<A href='?src=\ref[];contact=1'>Contact Admins</A><br>\n<A href='?src=\ref[];message=1'>Access Messageboard</A><br>\n<br>\n<A href='?src=\ref[];l_keys=1'>List Keys</A><br>\n<A href='?src=\ref[];l_players=1'>List Players/Keys</A><br>\n<A href='?src=\ref[];g_send=1'>Send Global Message</A><br>\n<A href='?src=\ref[];p_send=1'>Send Private Message</A><br>", src, src, src, src, src, src, src)
	usr << browse(dat, "window=admin")
	return

/world/proc/update_stat()

	if(config)
		if (ticker)
			src.status = text("Space Station 13 V.[] ([],[],[],[],[])[]<!-- host=\"[]\"-->", SS13_version, master_mode, (abandon_allowed ? "AM" : "No AM"), (enter_allowed ? "Open" : "Closed"), ( config.allow_vote_mode ? "Vote": "No vote"), (config.allow_ai ? "AI Allowed" : "AI Not Allowed"),  (host ? text(" hosted by <B>[]</B>", host) : null), host)
		else
			src.status = text("Space Station 13 V.[] (<B>STARTING</B>,[],[],[],[])[]<!-- host=\"[]\"-->", SS13_version, (abandon_allowed ? "AM" : "No AM"), (enter_allowed ? "Open" : "Closed"), ( config.allow_vote_mode ? "Vote": "No vote"), (config.allow_ai ? "AI Allowed" : "AI Not Allowed"), (host ? text(" hosted by <B>[]</B>", host) : null), host)
	else
		if (ticker)
			src.status = text("Space Station 13 V.[] ([],[],[])[]<!-- host=\"[]\"-->", SS13_version, master_mode, (abandon_allowed ? "AM" : "No AM"), (enter_allowed ? "Open" : "Closed"), (host ? text(" hosted by <B>[]</B>", host) : null), host)
		else
			src.status = text("Space Station 13 V.[] (<B>STARTING</B>,[],[])[]<!-- host=\"[]\"-->", SS13_version, (abandon_allowed ? "AM" : "No AM"), (enter_allowed ? "Open" : "Closed"), (host ? text(" hosted by <B>[]</B>", host) : null), host)
	return

/world/New()
	src.update_stat()

	for (var/turf/T in world)
		T.updatelinks()

	makepipelines()
	makepowernets()

	sun = new /datum/sun()

	// ****stuff for presistent mode picking
	var/newmode = null

	var/modefile = file2text(persistent_file)

	if(modefile)			// stuff to fix trailing NL problems
		var/list/ML = dd_text2list(modefile, "\n")

		newmode = ML[1]

		//world << "Savefile: [SF] ([SF["newmode"]])"

		if(newmode)
			master_mode = newmode
			world.log << "Read default mode '[newmode]' from [persistent_file]"


	// *****

	var/motd = file2text("motd.txt")
	if (motd)
		world_message = motd
	var/ad_text = file2text("admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == ";")
				continue //goto(64)
			var/t1 = findtext(t, " - ", 1, null)
			if (t1)
				var/m_key = copytext(t, 1, t1)
				var/a_lev = text("[]", copytext(t, t1 + 3, length(t) + 1))
				admins[text("[]", m_key)] = text("[]", a_lev)
		//Foreach goto(64)

	config = new /datum/configuration()
	config.load("config.txt")
	
	vote = new /datum/vote()
	
	main_hud1 = new /obj/hud(  )
	main_hud2 = new /obj/hud/hud2(  )
	SS13_airtunnel = new /datum/air_tunnel/air_tunnel1(  )
	
	..()
	
	sleep(50)
	
	nuke_code = text("[]", rand(10000, 99999.0))
	for(var/obj/machinery/nuclearbomb/N in world)
		if (N.r_code == "ADMIN")
			N.r_code = nuke_code
	sleep(50)
	
	plmaster = new /obj/overlay(  )
	plmaster.icon = 'plasma.dmi'
	plmaster.icon_state = "onturf"
	plmaster.layer = FLY_LAYER
	
	slmaster = new /obj/overlay(  )
	slmaster.icon = 'plasma.dmi'
	slmaster.icon_state = "sl_gas"
	slmaster.layer = FLY_LAYER
	
	cellcontrol = new /datum/control/cellular()
	spawn (0)
		cellcontrol.process()
		return
	
	src.update_stat()
	
	spawn (0)
		sleep(900)		//*****RM was 900
		Label_482:
		if (ctf)
			return
		if (going && (!ticker))
			ticker = new /datum/control/gameticker(  )
			spawn( 0 )
				ticker.process()
				return
			data_core = new /obj/datacore(  )
		else
			sleep(100)
			goto Label_482
		return
	return

/world/Topic(T, addr, master, key)
	world.log << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"
	
	if(T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x
	else if (T == "reboot" && master)
		world.log << "TOPIC: Remote reboot from master ([addr])"
		world.Reboot()
	else if (T == "reboot45246")
		return "nice try faggot"
	else if(T == "players")
		var/n = 0
		for(var/mob/M in world)
			n++
			/*
			if(M.client)
				world.log << "[++n] : [M.name] ([M.client.key]) at [M.loc.loc] ([M.x],[M.y],[M.z]) : [M.client.inactivity/10.0]s"
			*/
		return n

/mob/proc/CanAdmin()
	if (world.address == src.client.address)
		return 1
	if (src.client.address == "127.0.0.1")
		return 1
	if (!( src.client.address ))
		return 1
	return 0


/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/ai))
		return 1
	return

/atom/proc/Bumped(AM as mob|obj)

	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)

	spawn( 0 )
		if ((A && yes))
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set src in oview()

	if ((!( usr ) || !( isturf(usr.loc) )) || isarea(src))		// can't point to areas anymore
		return
	if ((usr.stat == 0 && !( usr.restrained() )))
		var/P = new /obj/point( (isturf(src) ? src : src.loc) )
		spawn( 20 )
			//P = null
			del(P)
			return
		for(var/mob/M in viewers(usr, null))
			M.show_message(text("<B>[]</B> points to []", usr, src), 1)
			//Foreach goto(102)
	return

/turf/proc/updatecell()

	return

/turf/proc/conduction()
	return

/turf/proc/cachecell()

	return

/datum/control/proc/process()

	return

/datum/control/gameticker/proc/meteor_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= 6000)
						src.timeleft = null
						src.timing = 0
		spawn( 0 )
			new /obj/meteor( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )
			return
		if (prob(50))
			spawn( 0 )
				new /obj/meteor/small( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )


				return
		if ((src.timeleft <= 0 && src.timing && !( prison_entered )))
			src.timeup()

		sleep(10)
	while(src.processing)
	return

/proc/meteor_wave()
	if(!ticker || wavesecret)
		return

	wavesecret = 1
	for(var/my = 1 to world.maxy)
		spawn(rand(10,100))
			new /obj/meteor( locate(world.maxx, my, 1) )
	sleep(300)
	wavesecret = 0

/datum/control/gameticker/proc/megamonkey_process()

	do
		if (prob(2))
			spawn( 0 )
				new /obj/meteor( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )
				return
			if (prob(10))
				spawn( 0 )
					new /obj/meteor/small( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )
					return

		world << "megamonkey_process check_win"
		check_win()

		sleep(50)
	while(src.processing)
	return


/datum/control/gameticker/proc/extend_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= 6000)
						src.timeleft = null
						src.timing = 0
		if (prob(0.5))
			spawn( 0 )
				new /obj/meteor( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )
				return
			if (prob(10))
				spawn( 0 )
					new /obj/meteor/small( pick(block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, 1))) )
					return
		if ((src.timeleft <= 0 && (src.timing && (!( prison_entered ) || src.shuttle_location == 1))))
			src.timeup()

		sleep(10)
	while(src.processing)
	return

/datum/control/gameticker/proc/nuclear(z_level)

	if (src.mode != "nuclear")
		return
	if (z_level != 1)
		return
	spawn( 0 )
		src.objective = "Success"
		world << "<B>The Syndicate Operatives have destroyed Space Station 13!</B>"
		for(var/mob/human/H in world)
			if ((H.client && findtext(H.rname, "Syndicate ", 1, null)))
				if (H.stat != 2)
					world << text("<B>[] was []</B>", H.key, H.rname)
				else
					world << text("[] was [] (Dead)", H.key, H.rname)
			//Foreach goto(64)
		src.timing = 0
		sleep(300)
		world.log_game("Syndicate success")
		world.Reboot()
		return
	return

/datum/control/gameticker/proc/timeup()


	var/A = locate(/area/shuttle)
	if (src.shuttle_location == shuttle_z)
		world << "<B>The emergency shuttle has docked with the station! You have 3 minutes to board the shuttle.</B>"
		for(var/turf/T in A)

			if (T.z == shuttle_z)
				for(var/atom/movable/AM as mob|obj in T)
					AM.z = 1
					//Foreach goto(79)
				var/turf/U = locate(T.x, T.y, shuttle_z)
				U.oxygen = T.oxygen
				U.oldoxy = T.oldoxy
				U.tmpoxy = T.tmpoxy
				U.poison = T.poison
				U.oldpoison = T.oldpoison
				U.tmppoison = T.tmppoison
				U.co2 = T.co2
				U.oldco2 = T.oldco2
				U.tmpco2 = T.tmpco2

				U.buildlinks()
				//T = null
				del(T)
			//Foreach goto(45)
		src.timeleft = 1800
		src.shuttle_location = 1
	else
		world << "<B>The emergency shuttle is leaving!</B>"
		check_win()
	return

/datum/control/gameticker/proc/check_win()
	if (!mode.check_win())
		return 0

	for (var/mob/ai/aiPlayer in world)
		if (aiPlayer.stat!=2)
			world << "<b>The AI's laws at the end of the game were:</b>"
		else
			world << "<b>The AI's laws when it was deactivated were:</b>"
		aiPlayer.showLaws(1)

	var/area/A = locate(/area/shuttle)
	if (src.shuttle_location != shuttle_z)
		for(var/turf/T in A)
			if (T.z == 1)
				for(var/atom/movable/AM as mob|obj in T)
					AM.z = shuttle_z
					//Foreach goto(2483)
				var/turf/U = locate(T.x, T.y, shuttle_z)
				U.oxygen = T.oxygen
				U.oldoxy = T.oldoxy
				U.tmpoxy = T.tmpoxy
				U.poison = T.poison
				U.oldpoison = T.oldpoison
				U.tmppoison = T.tmppoison
				U.co2 = T.co2
				U.oldco2 = T.oldco2
				U.tmpco2 = T.tmpco2

				U.buildlinks()
				//T = null
				del(T)
			//Foreach goto(2449)
	sleep(300)
	world.log_game("Rebooting due to end of game")
	world.Reboot()
	return 1

/datum/control/gameticker/process()

	shuttle_location = shuttle_z

	world.update_stat()
	world << "<B>Welcome to the Space Station 13!</B>\n\n"

	switch (master_mode)
		if("secret")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Secret!</B>"
			world << "<B>The game will pick between meteor, traitor, blob, or monkey mode!</B>"
		if("random")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Random</B>"
			world << "<B>The game has picked mode: \red [src.mode.name]</B>"
		else
			src.mode = config.pick_mode(master_mode)
			src.mode.announce()

	src.mode.pre_setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("GAME: starting game of [src.mode.name]")

	DivideOccupations()

	for (var/obj/manifest/M in world)
		M.manifest()

	for (var/mob/human/H in world)
		if (H.start)
			reg_dna[H.primary.uni_identity] = H.name

	data_core.manifest()

	src.mode.post_setup()

	for(var/obj/start/S in world)
		del(S)

// *****
// MAIN LOOP OF PROGRAM
// *****

/datum/control/cellular/process()
	set invisibility = 0
	set background =1

	Label_6:

	//world << "World.contents.len [world.contents.len]"


	while(!( ticker ))
		for(var/mob/M in world)
			spawn( 0 )
				M.UpdateClothing()
				return
			//Foreach goto(28)
		sleep(10)

	time = (++time %10)

	sun.calc_position()

	//if(Debug)
	//	world.log << "*** SoT ***"
	//	Air()

	for(var/turf/station/T in world)
		if (T.updatecell)
			T.updatecell()
			if(!time)
				T.conduction()
	//if(Debug)
	//	world.log << "*** EoT ***"
	//	Air()

		//Foreach goto(73)
	sleep(3)
	for(var/mob/M in world)
		spawn( 0 )
			M.Life()
			return
		//Foreach goto(126)
	sleep(3)
	for(var/obj/move/S in world)
		S.process()
		//Foreach goto(167)
	sleep(2)

	//if(Debug)
	//	world.log << "*** SoP ***"
	//	Air()


	for(var/obj/machinery/M in machines)
		M.process()

	for(var/obj/machinery/M in gasflowlist)
		M.gas_flow()

	for(var/datum/powernet/P in powernets)
		P.reset()

	//if(Debug)
	//	world.log << "*** EoP ***"
	//	Air()

		//Foreach goto(213)
	src.var_swap = !( src.var_swap )
	if (src.processing)
		sleep(2)
		goto Label_6
	return
