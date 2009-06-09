/proc/get_target_desc(mob/target) //return a useful string describing the target
	var/targetrank = null
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["name"] == target.rname)
			targetrank = R.fields["rank"]
	return "[target.name] the [targetrank]"

/proc/get_rank(mob/M)
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["name"] == M.name)
			return R.fields["rank"]
	return null

/proc/get_mobs_with_rank(rank)
	var/list/names = list()
	var/list/mobs = list()
	for(var/datum/data/record/R in data_core.general)
		if (R.fields["rank"] == rank)
			names += R.fields["name"]
			break
	for(var/mob/M in world)
		for(var/name in names)
			if(M.name == name)
				mobs += M
	return mobs

/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && M.start)
			mobs += M
	return mobs

/proc/get_human_list()
	var/list/humans = list()
	for(var/mob/human/M in world)
		if (M.client && M.start && get_rank(M) != "AI")
			humans += M
	return humans

/proc/pick_human_except(mob/human/exception)
	return pick(get_human_list() - exception)

/proc/is_head(mob/M)
	var/list/L = get_mobs_with_rank("Head of Personnel") + get_mobs_with_rank("Head of Research") + get_mobs_with_rank("Captain")
	if(L.Find(M))
		return 1
	else
		return 0

/proc/is_security(mob/M)
	var/list/L = get_mobs_with_rank("Security")
	if(L.Find(M))
		return 1
	else
		return 0