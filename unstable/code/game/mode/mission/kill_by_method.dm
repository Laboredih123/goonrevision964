/var/const
	BRUTE = 1
	BURN = 2
	TOXIN = 3
	SUFFOCATION = 4
	ELECTRIC = 5

/datum/mission/kill_by_method
	var/const/REQ_DAMAGE = 100
	var/method
	var/num

	description()
		var/type = ""
		switch(method)
			if(BRUTE)
				type = "brute"
			if(BURN)
				type = "burn"
			if(TOXIN)
				type = "toxin"
			if(SUFFOCATION)
				type = "suffocation"
			if(ELECTRIC)
				type = "electric"
		return "cause [num] people to die of [type] damage."

	check_success()
		var/killed = 0
		for(var/mob/carbon/M in world)
			if (M.last_known_ckey && M.is_dead)
				var/datum/damage/d = M.get_damage()
				if(method == BRUTE && d.brute > REQ_DAMAGE)
					killed++
				else if(method == BURN && d.burn > REQ_DAMAGE)
					killed++
				else if(method == TOXIN && d.toxin> REQ_DAMAGE)
					killed++
				else if(method == SUFFOCATION && d.suffocation > REQ_DAMAGE)
					killed++
				else if(method == ELECTRIC && d.electric > REQ_DAMAGE)
					killed++


		if(killed >= num)
			return MISSION_SUCCESS
		else
			return MISSION_FAILURE

	New(num, method)
		if(num)
			src.num = num
		else
			var/list/mobs = get_cliented_mob_list()
			num = mobs.len / 3
		if(method)
			src.method = method
		else
			method = pick(BRUTE, BURN, TOXIN, SUFFOCATION)
