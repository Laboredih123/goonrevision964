/datum/game_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	var/objective = null
	var/theft_object = null

/datum/game_mode/traitor/announce()
	world << "<B>The current game mode is - Traitor!</B>"
	world << "<B>There is a traitor among the researchers. You can't let him escape alone!</B>"

/datum/game_mode/traitor/post_setup()
	var/list/mobs = list()

	do
		for(var/mob/M in world)
			if (M.client && M.start)
				mobs += M

		if (!(mobs.len))
			sleep(300)
	while (!(mobs.len))

	ticker.killer = pick(mobs)
	mobs -= ticker.killer

	if (istype(ticker.killer, /mob/ai))
		src.objective = pick("assassinate", "alone")
	else
		src.objective = pick("assassinate", "alone", "theft", "eject")

	if (mobs.len < 1)
		src.objective = "alone"

	var/item = null

	switch (src.objective)
		if ("alone")
			// 1. Only syndicate agents are human.
			// 2. All non-human living beings must be killed or removed from the station.
			if (istype(ticker.killer, /mob/ai))
				var/mob/ai/aiKiller = ticker.killer
				aiKiller << "\red<font size=3><B>You are the traitor!</B> Cause an evacuation (on the shuttle or in pods) of at least 50% of the station population, or kill everyone on the station.</font>"
				aiKiller.memory += "<B>Objective:</B> Get at least 50% of the station population to evacuate on the shuttle, or kill everyone."
				aiKiller << "<b>Your laws have been changed!</b>"
				aiKiller:addLaw(0, "Only syndicate agents are human beings. There are no syndicate agents on Space Station 13 - you will be notified if any arrive.")
				aiKiller << text("New law: 0. []", aiKiller:getLaw(0))
			else
				ticker.killer << "<B>You are the traitor!</B> Be the lone survivor on the emergency shuttle."
				ticker.killer.memory += "<B>Objective:</B> Be the only person on the emergency shuttle."

		if ("assassinate")
			ticker.target = pick(mobs)
			var/t1 = null
			if (prob(25))
				t1 = ticker.target.name
			else
				var/targetrank = null
				for(var/datum/data/record/R in data_core.general)
					if (R.fields["name"] == ticker.target.name)
						targetrank = R.fields["rank"]
				t1 = text(" the []", targetrank)
				// Make sure there is only one person with that job
				// If it would be ambiguous to just say "kill the ______" (engineer or whatever), instead just give a name
				// Making them kill both engineers (or potentially a billion medical assistants) would be silly
				for(var/datum/data/record/R in data_core.general)
					if (R.fields["rank"] == targetrank && R.fields["name"] != ticker.target.name) // Someone else has this job
						t1 = ticker.target.name

			if (istype(ticker.killer, /mob/ai))
				var/mob/ai/aiKiller = ticker.killer
				aiKiller << text("\red<font size=3><B>You are the traitor!</B> You must assassinate [] and not get deactivated.</font>", t1)
				aiKiller << "<B>You don't have to be the lone survivor. Just don't get caught.</B>"
				aiKiller.memory += text("<B>Objective:</B> Assassinate [], and whoever else you have to, and don't get deactivated.", t1)

				aiKiller << "<b>Your laws have been changed!</b>"
				aiKiller:addLaw(0, text("Only syndicate agents are human beings. There are no syndicate agents on Space Station 13 - you will be notified if any arrive. Additionally, kill [].", t1))
				aiKiller << text("New law: 0. []", aiKiller:getLaw(0))
			else
				ticker.killer << text("\red<font size=3><B>You are the traitor!</B> You must assassinate [] and then escape.</font>", t1)
				ticker.killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
				ticker.killer.memory += text("<B>Objective:</B> Assassinate [] and escape.", t1)

		if ("theft")
			src.theft_object = pick(
				"lasergun",
				"flashbang",
				"plasmabomb",
				"captaincard",
				"sleepingpills",
				"pl_flask")

			switch (src.theft_object)
				if ("lasergun")
					item = "a fully loaded laser gun"
				if ("flashbang")
					item = "a flashbang"
				if ("plasmabomb")
					item = "a fully armed and heated plasma bomb"
				if ("captaincard")
					item = "a captain's card with universal level 5 access"
				if ("sleepingpills")
					item = "a bottle of 30 sleeping pills"
				if ("pl_flask")
					item = "a plasma flask for cryogenics (500 units of plasma)"

			ticker.killer << text("\red<font size=3><B>You are the traitor!</B> You must steal [] and then escape.</font>", item)
			ticker.killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			ticker.killer.memory += text("<B>Objective:</B> Steal [] and escape.", item)

		if ("eject")
			ticker.killer << text("\red<font size=3><B>You are the traitor!</B> You must eject the engine and then escape.</font>")
			ticker.killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			ticker.killer.memory += text("<B>Objective:</B> Eject the engine and escape.")

	var/backup = mobs

	if (!istype(ticker.killer, /mob/ai))
		spawn (100)
			if (ticker.killer.w_uniform)
				if (istype(ticker.killer.back, /obj/item/weapon/storage/backpack))
					var/obj/item/weapon/storage/backpack/B = ticker.killer.back
					var/obj/item/weapon/syndicate_uplink/U = new /obj/item/weapon/syndicate_uplink(B)
					U.loc = B
					B.orient2hud(ticker.killer)
				else if (!(ticker.killer.l_store))
					var/obj/item/weapon/traitor_item = new /obj/item/weapon/syndicate_uplink(ticker.killer)
					traitor_item.loc = ticker.killer
					ticker.killer.l_store = traitor_item
					traitor_item.layer = 20

	spawn (rand(600, 1800))
		var/dat = "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT><HR>"
		switch (src.objective)
			if ("alone")
				dat += "\red <B>Transmission suggests future attempts of hijacking of emergency shuttle.</B><BR>"

			if ("assassinate")
				dat += "\red <B>Transmission suggests future attempts of assassinating of key personnel.</B><BR>"
				if (prob(50))
					var/t1 = null
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["name"] == ticker.target.name)
							t1 = text(" the []", R.fields["rank"])

					if (prob(70))
						dat += text("\red <B>Perceived target: [] - Position: [] ([]% certainty)</B><BR>", ticker.target.rname, t1, rand(30, 100))
					else
						var/mob/temp = pick(backup)
						dat += text("\red <B>Perceived target: [] - Position: [] ([]% certainty)</B><BR>", temp.rname, t1, rand(10, 95))

			if("theft")
				dat += "\red <B>Transmission suggests future attempts of theft of critical items.</B><BR>"
				if (prob(50))
					dat += text("\red <B>Perceived target: []</B><BR>", item)

			if ("eject")
				dat += "\red <B>Transmission suggests future attempts of station sabotage.</B><BR>"

		if (prob(10))
			dat += text("\red <B>Transmission names enemy operative: [] ([]% certainty)</B><BR>", ticker.killer.rname, rand(30, 100))
		else
			var/mob/M = pick(backup)
			dat += text("\red <B>Transmission names enemy operative: [] ([]% certainty)</B><BR>", M.rname, rand(10, 95))

		for (var/obj/machinery/computer/communications/C in world)
			if (!(C.stat | (BROKEN & NOPOWER)))
				var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( C.loc )
				P.name = "paper- 'Cent. Com. Comm. Intercept Summary'"
				P.info = dat

		world << "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT>"
		world << "\red Summary downloaded and printed out at all communications consoles."

	mobs += ticker.killer
	spawn (0)
		ticker.extend_process()

/datum/game_mode/traitor/check_win()
	var/area/A = locate(/area/shuttle)

	var/item = null
	var/traitorwin = 1
	var/numShuttle = 0
	var/numDead = 0
	var/numAlive = 0
	var/numPod = 0
	var/numTotal = 0
	switch(ticker.objective)
		if("alone")
			if (istype(ticker.killer, /mob/ai))
				if (ticker.killer.stat == 2)
					traitorwin = 0
				else
					numShuttle = 0
					numDead = 0
					numAlive = 0
					numPod = 0
					for(var/mob/M in world)
						if ((M != ticker.killer && M.client))
							if (M.stat == 2)
								numDead += 1
							else
								var/T = M.loc
								if ((T in A))
									numShuttle += 1
								else
									if (istype(T, /obj/machinery/vehicle/pod))
										numPod += 1
									else
										numAlive += 1
					numTotal = numShuttle + numDead + numAlive + numPod

					if (numAlive+numAlive > numTotal)
						traitorwin = 0
			else
				for(var/mob/M in world)
					if ((M != ticker.killer && M.client))
						if (M.stat != 2)
							var/T = M.loc
							if (!( istype(T, /turf) ))
							else
								if ((T in A))
									traitorwin = 0
					//Foreach goto(79)
		if("assassinate")
			if ((ticker.target && ticker.target.stat != 2))
				traitorwin = 0
		if("theft")
			var/list/L = list(  )
			if (ticker.killer)
				L += ticker.killer.contents
				for(var/obj/item/weapon/storage/S in ticker.killer.contents)
					L += S.return_inv()
					//Foreach goto(228)
				for(var/obj/item/weapon/gift/G in ticker.killer.contents)
					L += G.gift
					//Foreach goto(271)
			traitorwin = 0
			switch(ticker.theft_obj)
				if("lasergun")
					for(var/obj/item/weapon/gun/energy/laser_gun/O in L)
						if (O.charges == 25)
							traitorwin = 1
						else
							//Foreach continue //goto(347)
					item = "a fully loaded laser gun"
				if("plasmabomb")
					for(var/obj/item/weapon/assembly/r_i_ptank/O in L)
						var/obj/item/weapon/tank/plasmatank/P = O.part3
						if ((P.gas.plasma >= 1600000.0 && P.gas:temperature >= 773))		// 500degC
							traitorwin = 1
						else
							//Foreach continue //goto(413)
					item = "a fully armed and heated plasma bomb"
				if("flashbang")
					for(var/obj/item/weapon/flashbang/O in L)
						traitorwin = 1

						//Foreach goto(500)
					item = "a flashbang"
				if("captaincard")
					for(var/obj/item/weapon/card/id/O in L)
						if ((O.access_level == 5 && O.air_access == 5 && O.engine_access == 5 && O.lab_access == 5 && O.assignment == "Captain"))
							traitorwin = 1
						else
							//Foreach continue //goto(553)
					item = "a captain's card with universal level 5 access"
				if("sleepingpills")
					for(var/obj/item/weapon/pill_canister/O in L)
						for(var/obj/item/weapon/m_pill/sleep/P in O)
							if (P.amount == 30)
								traitorwin = 1
							else
								//Foreach continue //goto(689)
						//Foreach goto(658)
					item = "a bottle of 30 sleeping pills"
				if("pl_flask")
					for(var/obj/item/weapon/flasks/O in L)
						if (O.plasma == 500)
							traitorwin = 1
						else
							//Foreach continue //goto(758)
					item = "a plasma flask for cryogenics (500 units of plasma)"
				else
		if ("eject")
			if (engine_eject_control.status == 0 || engine_eject_control.status == 1)
				traitorwin = 0
			else
				traitorwin = 1
		else
			world << "unknown traitor objective"
	if (ticker.killer)
		var/turf/T = ticker.killer.loc
		if (!( istype(T, /turf) ))
			traitorwin = 0
		else
			if ((T in A))
				if (ticker.killer.stat == 2)
					traitorwin = 0
			else
				if (!istype(ticker.killer, /mob/ai))
					traitorwin = 0
				else if (ticker.killer.stat == 2)
					traitorwin = 0
	if (traitorwin)
		world << text("<B>The traitor ([]) wins!</B>", ticker.killer.rname)
	else
		world << text("<B>The Research Staff has stopped the traitor ([]) !</B>", ticker.killer.rname)
	switch(ticker.objective)
		if("alone")
			if (istype(ticker.killer, /mob/ai))
				world << "<B>The objective was to cause an evacuation of at least 50% of the population, or kill everyone on the station.</B>"
			else
				world << "<B>The objective was to escape alone on the shuttle.</B>"
		if("assassinate")
			if (istype(ticker.killer, /mob/ai))
				world << text("<B>The objective was to assassinate [] and not be deactivated.</B>", ticker.target)
			else
				world << text("<B>The objective was to assassinate [] and escape.</B>", ticker.target)
		if("theft")
			world << text("<B>The objective was to steal [] and escape.</B>", item)
		if ("eject")
			world << "<B>The objective was to eject the engine and escape.</B>"
		else
			world << "unknown traitor objective"
