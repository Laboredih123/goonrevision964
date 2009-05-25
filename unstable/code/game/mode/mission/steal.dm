/datum/mission/steal
	var/item

	var/const/laser = 1
	var/const/hand_tele = 2
	var/const/plasma_bomb = 3
	var/const/jetpack = 4
	var/const/captain_card = 5
	var/const/captain_suit = 6

	New(list/group, gname)
		..()
		item = pick(get_pickable_items(group))

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
				if(laser)
					for(var/obj/item/weapon/gun/energy/laser_gun/O in items)
						if (O.charges >= O.maximum_charges)
							return 1
				if(plasma_bomb)
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
							return 1
				if(hand_tele)
					for(var/obj/item/weapon/hand_tele/O in items)
						return 1
				if(captain_card)
					for(var/obj/item/weapon/card/id/O in items)
						if(!O.access)
							continue
						for(var/A in get_all_accesses())
							if(!A in O.access)
								continue
						//he's got all the permissions, GOOD JOB
						return 1
				if(jetpack)
					for(var/obj/item/weapon/tank/jetpack/O in items)
						return 1
				if(captain_suit)
					for(var/obj/item/weapon/clothing/under/darkgreen/O in items)
						return 1
		return 0

	description()
		return "steal [get_item_desc(item)]"

	proc/get_item_desc(var/target)
		switch (target)
			if (laser)
				return "a fully loaded laser gun"
			if (hand_tele)
				return "a hand teleporter"
			if (plasma_bomb)
				return "a fully armed and heated plasma bomb"
			if (captain_card)
				return "an ID card with universal access"
			if (captain_suit)
				return "a captain's dark green jumpsuit"
			if (jetpack)
				return "a jet pack"
			else
				return "Error: Invalid theft target: [target]"

	proc/get_pickable_items(list/group)
		var/list/items = list(laser, hand_tele, plasma_bomb, captain_card, jetpack, captain_suit)
		for(var/mob/M in group)
			var/killerrank = get_rank(M)
			if(killerrank == "Captain")
				items -= list(laser, captain_card, captain_suit, hand_tele, jetpack) //too easy to steal
			else if(killerrank == "Head of Personnel" || killerrank == "Head of Research")
				items -= laser //too easy to steal
		return items