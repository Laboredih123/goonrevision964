/datum/mission/steal_canisters
	var/num

	New(list/group, gname, num = 10)
		..()
		src.num = num

	check_success()
		var/num_got = 0
		for(var/obj/machinery/atmoalter/canister/poisoncanister/C in world)
			if(!on_shuttle(C))
				continue
			if(C.gas.plasma >= C.maximum)
				num_got++
		if(num_got >= num)
			return MISSION_SUCCESS
		return MISSION_FAILURE

	description()
		return "steal [num] full plasma canisters"