var/const
	LASER = 1
	HAND_TELE = 2
	PLASMA_BOMB = 3
	JETPACK = 4
	CAPTAIN_CARD = 5
	CAPTAIN_SUIT = 6
	NUKE_DISK = 7


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
					// SHOULD work for all bombs and that's it
					for(var/obj/item/weapon/assembly/O in items)
						var/istimebomb = istype(O, /obj/item/weapon/assembly/t_i_ptank)
						var/isproxbomb = istype(O, /obj/item/weapon/assembly/m_i_ptank)
						var/isradiobomb = istype(O, /obj/item/weapon/assembly/r_i_ptank)
						if(!istimebomb && !isproxbomb && !isradiobomb)
							continue
						var/obj/item/weapon/tank/plasmatank/P = O:part3
						if(!P || !istype(P, /obj/item/weapon/tank/plasmatank))
							continue
						if ((P.gas.plasma >= 1600000.0 && P.gas:temp >= 773)) // 500 degrees Celsius
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
				if(NUKE_DISK)
					for(var/obj/item/weapon/disk/nuclear/O in items)
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
			if(NUKE_DISK)
				return "a nuclear disk"
			else
				return "Error: Invalid theft target: [target]"

	proc/get_pickable_items(list/group)
		var/list/items = list(LASER, HAND_TELE, PLASMA_BOMB, CAPTAIN_CARD, CAPTAIN_SUIT, JETPACK)
		// not nuke disk
		for(var/mob/M in group)
			var/killerrank = M.spawn_rank
			if(killerrank == "Captain")
				items -= list(LASER, CAPTAIN_CARD, CAPTAIN_SUIT, JETPACK, HAND_TELE) //too easy to steal
			else if(killerrank == "Head of Personnel" || killerrank == "Head of Research")
				items -= LASER //too easy to steal
		return items