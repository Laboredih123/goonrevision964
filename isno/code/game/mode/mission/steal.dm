var/const
	LASER = 1
	HAND_TELE = 2
	PLASMA_BOMB = 3
	JETPACK = 4
	CAPTAIN_CARD = 5
	CAPTAIN_SUIT = 6
	DISK = 7


/datum/mission/steal
	var/item

	New(list/group, gname, item)
		..()
		if(item)
			src.item = item
		else
			src.item = pick(get_pickable_items(group))

	check_success()
		var/list/items = list()
		for(var/mob/M in group)
			if(!on_shuttle(M) || M.is_dead)
				continue
			items += M.contents
			for(var/obj/item/weapon/storage/S in M.contents)
				items += S.return_inv()
			for(var/obj/item/weapon/gift/G in M.contents)
				items += G.gift
				if (istype(G.gift, /obj/item/weapon/storage))
					items += G.gift:return_inv()

			switch(item)
				if(LASER)
					for(var/obj/item/weapon/gun/energy/laser_gun/O in items)
						if (O.charges >= O.maximum_charges)
							return MISSION_SUCCESS
				if(PLASMA_BOMB)
					for(var/obj/item/weapon/assembly/O in items)
						if(!istype(O.actor, /obj/item/weapon/igniter_tank))
							continue
						var/obj/item/weapon/igniter_tank/A = O.actor
						if(!A.welded || !O.secured)
							continue
						var/obj/item/weapon/tank/plasmatank/tank = A.tank
						if(!tank)
							continue
						if(tank.gas.plasma >= 1600000 && tank.gas.temp >= 773)
							return MISSION_SUCCESS
				if(HAND_TELE)
					for(var/obj/item/weapon/hand_tele/O in items)
						return MISSION_SUCCESS
				if(CAPTAIN_CARD)
					for(var/obj/item/weapon/card/id/O in items)
						if(!O.access)
							continue
						for(var/A in get_all_accesses())
							if(!A in O.access)
								continue
						//he's got all the permissions, GOOD JOB
						return MISSION_SUCCESS
				if(JETPACK)
					for(var/obj/item/weapon/tank/jetpack/O in items)
						return MISSION_SUCCESS
				if(CAPTAIN_SUIT)
					for(var/obj/item/weapon/clothing/under/darkgreen/O in items)
						return MISSION_SUCCESS
				if(DISK)
					for(var/obj/item/weapon/disk/code/O in items)
						return MISSION_SUCCESS
		return MISSION_FAILURE

	description()
		return "steal [get_item_desc(item)]"

	proc/get_item_desc(var/target)
		switch (target)
			if (LASER)
				return "a fully loaded laser gun"
			if (HAND_TELE)
				return "a hand teleporter"
			if (PLASMA_BOMB)
				return "a fully armed and heated plasma bomb"
			if (CAPTAIN_CARD)
				return "an ID card with universal access"
			if (CAPTAIN_SUIT)
				return "a captain's dark green jumpsuit"
			if (JETPACK)
				return "a jet pack"
			if(DISK)
				return "the code disk"
			else
				return "Error: Invalid theft target: [target]"

	proc/get_pickable_items(list/group)
		var/list/items = list(LASER, HAND_TELE, PLASMA_BOMB, CAPTAIN_CARD, CAPTAIN_SUIT, JETPACK)
		// not disk
		for(var/mob/M in group)
			var/datum/job/killerjob = M.spawn_job
			if(istype(killerjob, /datum/job/captain))
				items -= list(LASER, CAPTAIN_CARD, CAPTAIN_SUIT, JETPACK, HAND_TELE) //too easy to steal
			else if(istype(killerjob, /datum/job/hop) || istype(killerjob, /datum/job/hor))
				items -= LASER //too easy to steal
		return items