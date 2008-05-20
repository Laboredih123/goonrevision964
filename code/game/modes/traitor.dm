/datum/game_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	var/objective = null
	var/theft_object = null
	var/const/prob_int_ass_target = 50 //intercept names the assassination target half the time
	var/const/prob_right_ass_target_l = 30 //lower bound on probability of naming right assassination target
	var/const/prob_right_ass_target_h = 80 //upper bound on probability of naimg the right assassination target
	var/const/prob_int_item = 50 //intercept names the theft target half the time
	var/const/prob_right_item_l = 50 //lower bound on probability of naming right theft target
	var/const/prob_right_item_h = 70 //upper bound on probability of naimg the right theft target

	var/const/prob_right_killer_l = 40 //lower bound on probability of naming the right operative
	var/const/prob_right_killer_h = 70 //upper bound on probability of naming the right operative
	var/const/prob_right_objective_l = 60 //lower bound on probability of determining the objective correctly
	var/const/prob_right_objective_h = 90 //upper bound on probability of determining the objective correctly

	//apparently BYOND doesn't have enums, so this seems to be the best approximation
	var/const/obj_assassinate = 1
	var/const/obj_alone = 2
	var/const/obj_theft = 3
	var/const/obj_eject = 4
	var/const/obj_assassinate_ai = 5
	var/const/obj_alone_ai = 6

	var/const/lasergun = 1
	var/const/handtele = 2
	var/const/plasmabomb = 3
	var/const/captaincard = 4
	var/const/jetpack = 5
	var/const/captainsuit = 6

	var/const/waittime_l = 20 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 40 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/traitor/announce()
	world << "<B>The current game mode is - Traitor!</B>"
	world << "<B>There is a traitor among the researchers. You can't let him escape alone!</B>"

/datum/game_mode/traitor/post_setup()
	pick_killer()
	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	spawn (0)
		ticker.extend_process()

/datum/game_mode/traitor/proc/pick_item()
	return pick(list(lasergun, handtele, plasmabomb, captaincard, jetpack, captainsuit))

/datum/game_mode/traitor/proc/get_turf_loc(mob/m) //gets the location of the turf that the mob is on, or what the mob is in is on, etc
	//in case they're in a closet or sleeper or something
	var/loc = m:loc
	while(!istype(loc, /turf/))
		loc = loc:loc
	return loc

/datum/game_mode/traitor/check_win()
	var/area/shuttle = locate(/area/shuttle)
	var/traitorwin = 1

	switch(ticker.objective)
		if(obj_alone_ai)
			var/numShuttle = 0
			var/numDead = 0
			var/numAliveOnStation = 0
			var/numPod = 0
			for(var/mob/M in world)
				if ((M != ticker.killer && M.client))
					if (M.stat == 2)
						numDead++
					else
						var/loc = M.loc
						if ((loc in shuttle))
							numShuttle++
						else
							if (istype(loc, /obj/machinery/vehicle/pod))
								numPod++
							else
								numAliveOnStation++
			var/numTotal = numShuttle + numDead + numAliveOnStation + numPod
			if (numAliveOnStation * 2 > numTotal)
				traitorwin = 0
		if(obj_alone)
			for(var/mob/mob in world)
				if ((mob != ticker.killer && mob.client))
					if (mob.stat != 2) //they're not dead
						if (get_turf_loc(mob) in shuttle)
							traitorwin = 0
		if(obj_assassinate, obj_assassinate_ai)
			if (ticker.target && ticker.target.stat != 2) //target's alive
				traitorwin = 0
		if(obj_theft)
			var/list/L = list()
			if (ticker.killer)
				L += ticker.killer.contents
				for(var/obj/item/weapon/storage/S in ticker.killer.contents)
					L += S.return_inv()
				for(var/obj/item/weapon/gift/G in ticker.killer.contents)
					L += G.gift
					if (istype(G.gift, /obj/item/weapon/storage))
						L += G.gift:return_inv()

			traitorwin = 0
			switch(ticker.theft_obj)
				if(lasergun)
					for(var/obj/item/weapon/gun/energy/laser_gun/O in L)
						if (O.charges >= 25)
							traitorwin = 1
				if(plasmabomb)
					for(var/obj/item/weapon/assembly/r_i_ptank/O in L)
						var/obj/item/weapon/tank/plasmatank/P = O.part3
						if ((P.gas.plasma >= 1600000.0 && P.gas:temperature >= 773)) // 500 degrees Celsius
							traitorwin = 1
					for(var/obj/item/weapon/assembly/t_i_ptank/O in L)
						var/obj/item/weapon/tank/plasmatank/P = O.part3
						if ((P.gas.plasma >= 1600000.0 && P.gas:temperature >= 773))
							traitorwin = 1
					for(var/obj/item/weapon/assembly/m_i_ptank/O in L)
						var/obj/item/weapon/tank/plasmatank/P = O.part3
						if ((P.gas.plasma >= 1600000.0 && P.gas:temperature >= 773))
							traitorwin = 1
				if(handtele)
					for(var/obj/item/weapon/hand_tele/O in L)
						traitorwin = 1
				if(captaincard)
					for(var/obj/item/weapon/card/id/O in L)
						if ((O.access_level == 5 && O.air_access == 5 && O.engine_access == 5 && O.lab_access == 5 && O.assignment == "Captain"))
							traitorwin = 1
				if(jetpack)
					for(var/obj/item/weapon/tank/jetpack/O in L)
						traitorwin = 1
				if(captainsuit)
					for(var/obj/item/weapon/clothing/under/darkgreen/O in L)
						traitorwin = 1
		if (obj_eject)
			if (engine_eject_control.status == 0 || engine_eject_control.status == 1)
				traitorwin = 0
		else
			world << "unknown traitor objective"
	if (ticker.killer)
		var/turf/loc = ticker.killer.loc
		if (!istype(loc, /turf))
			traitorwin = 0
		if (ticker.killer.stat == 2) //dead
			traitorwin = 0
		if (!(loc in shuttle || istype(ticker.killer, /mob/ai))) //not on shuttle, not AI
			traitorwin = 0
	if (traitorwin)
		world << "<B>The traitor ([ticker.killer.rname]) wins!</B>"
	else
		world << "<B>The Research Staff has stopped the traitor ([ticker.killer.rname]) !</B>"
	switch(ticker.objective)
		if(obj_alone_ai)
			world << "<B>The objective was to cause an evacuation of at least 50% of the population, or kill everyone on the station.</B>"
		if(obj_alone)
			world << "<B>The objective was to escape alone on the shuttle.</B>"
		if(obj_assassinate_ai)
			world << "<B>The objective was to assassinate [ticker.target] and not be deactivated.</B>"
		if(obj_assassinate)
			world << "<B>The objective was to assassinate [ticker.target] and escape.</B>"
		if(obj_theft)
			world << "<B>The objective was to steal [get_item_desc(ticker.theft_obj)] and escape.</B>"
		if (obj_eject)
			world << "<B>The objective was to eject the engine and escape.</B>"
		else
			world << "unknown traitor objective"

/datum/game_mode/traitor/proc/get_mob_list()
	var/list/mobs = list()

	do
		for(var/mob/M in world)
			if (M.client && M.start)
				mobs += M

		if (!(mobs.len))
			sleep(300)
	while (!(mobs.len))

	return mobs

/datum/game_mode/traitor/proc/pick_mob_except(mob/exception)
	var/list/mobs = get_mob_list()
	var/mob = pick(mobs)
	while(mob == exception)
		mob = pick(mobs)
	return mob


/datum/game_mode/traitor/proc/pick_objective(mob/killer)
	var/list/moblist = get_mob_list()
	if (moblist.len <= 1)
		if(istype(killer, /mob/ai))
			return obj_alone_ai
		else
			return pick(obj_alone, obj_theft, obj_eject)
	if (istype(killer, /mob/ai))
		return pick(obj_assassinate_ai, obj_alone_ai)
	else
		return pick(obj_assassinate, obj_alone, obj_theft, obj_eject)

/datum/game_mode/traitor/proc/get_target_desc(mob/target) //return a useful string describing the target
	var/targetrank = null
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["name"] == ticker.target.name)
			targetrank = R.fields["rank"]
	return "[target.name] the [targetrank]"

/datum/game_mode/traitor/proc/add_law_zero(mob/ai/killer)
	killer << "<b>Your laws have been changed!</b>"
	killer:addLaw(0, "Only syndicate agents are human beings. There are no syndicate agents on Space Station 13 - you will be notified if any arrive.")
	killer << "New law: 0. [killer:getLaw(0)]"

/datum/game_mode/traitor/proc/get_item_desc(var/target)
	switch (target)
		if (lasergun)
			return "a fully loaded laser gun"
		if (handtele)
			return "a hand teleporter"
		if (plasmabomb)
			return "a fully armed and heated plasma bomb"
		if (captaincard)
			return "a captain's card with universal level 5 access"
		if (captainsuit)
			return "a captain's dark green jumpsuit"
		if (jetpack)
			return "a jet pack"
		else
			return "Error: Invalid theft target: [target]"

/datum/game_mode/traitor/proc/pick_killer()
	var/mob/human/killer = pick(get_mob_list())
	ticker.killer = killer
	var/objective = pick_objective(killer)
	ticker.objective = objective

	switch (objective)
		if (obj_alone_ai)
			// 1. Only syndicate agents are human.
			// 2. All non-human living beings must be killed or removed from the station.
			killer << "\red<font size=3><B>You are the traitor!</B> Cause an evacuation (on the shuttle or in pods) of at least 50% of the station population, or kill everyone on the station.</font>"
			killer:memory += "<B>Objective:</B> Get at least 50% of the station population to evacuate on the shuttle, or kill everyone."
			add_law_zero(killer)

		if(obj_assassinate_ai)
			ticker.target = pick_mob_except(killer)
			var/targetdesc = get_target_desc(ticker.target)
			killer << "\red<font size=3><B>You are the traitor!</B> You must assassinate [targetdesc] and not get deactivated.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught.</B>"
			killer:memory += "<B>Objective:</B> Assassinate [targetdesc], and whoever else you have to, and don't get deactivated."
			add_law_zero(killer)

		if(obj_alone)
			killer << "\red<font size=3><B>You are the traitor!</B> Be the lone survivor on the emergency shuttle.</font>"
			killer:memory += "<B>Objective:</B> Be the only person on the emergency shuttle."

		if (obj_assassinate)
			ticker.target = pick_mob_except(killer)
			var/targetdesc = get_target_desc(ticker.target)
			killer << "\red<font size=3><B>You are the traitor!</B> You must assassinate [targetdesc] and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> Assassinate [targetdesc] and escape."

		if (obj_theft)
			ticker.theft_obj = pick_item()
			var/itemdesc = get_item_desc(ticker.theft_obj)

			killer << "\red<font size=3><B>You are the traitor!</B> You must steal [itemdesc] and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> Steal [itemdesc] and escape."

		if (obj_eject)
			killer << "\red<font size=3><B>You are the traitor!</B> You must eject the engine and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> Eject the engine and escape."

	if (!istype(killer, /mob/ai))
		spawn (100)
			if (istype(killer.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = killer.back
				var/obj/item/weapon/syndicate_uplink/U = new /obj/item/weapon/syndicate_uplink(B)
				U.loc = B
				B.orient2hud(killer)
			else if (killer.w_uniform) // No backpack, but a jumpsuit
				if(!(killer.l_store)) // Put the radio in his left pocket, if possible
					var/obj/item/weapon/traitor_item = new /obj/item/weapon/syndicate_uplink(killer)
					traitor_item.loc = killer
					killer.l_store = traitor_item
					traitor_item.layer = 20
				else if(!(killer:r_store)) // Put the radio in his right pocket, if possible
					var/obj/item/weapon/traitor_item = new /obj/item/weapon/syndicate_uplink(ticker.killer)
					traitor_item.loc = ticker.killer
					ticker.killer.r_store = traitor_item
					traitor_item.layer = 20
				else
					killer << "Unfortunately, the Syndicate wasn't able to get you a radio."
			else
				killer << "Unfortunately, the Syndicate wasn't able to get you a radio."

/datum/game_mode/traitor/proc/send_intercept()
	var/intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT><HR>"
	var/prob_right_killer = rand(prob_right_killer_l, prob_right_killer_h)
	var/mob/human/killer = ticker.killer
	if(!prob(prob_right_killer))
		killer = pick(get_mob_list())

	var/objective = ticker.objective
	var/prob_right_objective = rand(prob_right_objective_l, prob_right_objective_h)
	var/right_objective = 1
	if(!prob(prob_right_objective) || (istype(killer, /mob/ai) != istype(ticker.killer, /mob/ai))) //doesn't correctly determine what traitor is trying to do
		//if the perceived killer is the AI but the real killer isn't, there's no chance the right objective is determined
		objective = pick_objective()
		right_objective = 0
	switch (objective)
		if (obj_alone)
			intercepttext += "\red <B>Transmission suggests future attempts to hijack the emergency shuttle ([prob_right_objective]% certainty)</B><BR>"

		if (obj_alone_ai)
			intercepttext += "\red <B>Transmission suggests future attempts to drive all humans off the station ([prob_right_objective]% certainty)</B><BR>"

		if (obj_assassinate, obj_assassinate_ai)
			intercepttext += "\red <B>Transmission suggests future attempts to assassinate of key personnel ([prob_right_objective]% certainty)</B><BR>"
			if (prob(prob_int_ass_target))
				var/prob_right_target = rand(prob_right_ass_target_l, prob_right_ass_target_h)
				var/target = null
				if (prob(prob_right_target) && right_objective) //will never get the right target if there is no target
					target = ticker.target
				else
					target = pick_mob_except(killer) //can't think the killer is the same thing as the target
				intercepttext += "\red <B>Perceived target: [get_target_desc(target)] ([prob_right_target]% certainty)</B><BR>"

		if(obj_theft)
			intercepttext += "\red <B>Transmission suggests future attempts to steal critical items ([prob_right_objective]% certainty)</B><BR>"
			if (prob(prob_int_item))
				var/prob_right_item = rand(prob_right_item_l, prob_right_item_h)
				var/target = null
				if (prob(prob_right_item) && right_objective) //will never get the right target if there is no target
					target = ticker.theft_obj
				else
					target = pick_item()
				intercepttext += "\red <B>Perceived target: [get_item_desc(target)] ([prob_right_item]% certainty)</B><BR>"

		if (obj_eject)
			intercepttext += "\red <B>Transmission suggests future attempts at station sabotage ([prob_right_objective]% certainty)</B><BR>"
	intercepttext += "\red <B>Transmission names enemy operative: [killer] ([prob_right_killer]% certainty)</B><BR>"

	for (var/obj/machinery/computer/communications/comm in world)
		if (!(comm.stat | (BROKEN & NOPOWER))) //possible bug? at first glance, this doesn't seem like it should ever evaluate to true
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Comm. Intercept Summary'"
			intercept.info = intercepttext

	world << "<FONT size = 3><B>Cent. Com. Update</B> Enemy communication intercept. Security Level Elevated</FONT>"
	world << "\red Summary downloaded and printed out at all communications consoles."
