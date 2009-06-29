/var/list/rev_sayings = list()

/datum/effect/convert
	New(mob/carbon/M)
		M.verbs += /datum/effect/convert/proc/convert

	proc/convert()
		//say all sort of crazy religious propaganda
		if(!istype(usr, /mob/carbon))
			return
		var/mob/carbon/M = usr

		var/t = ss13time()
		if(t < M.last_conversion + CONVERT_COOLDOWN)
			return
		M.last_conversion = t

		for(var/atom/A in view(M.loc))
			A.hear("\blue [M.body_name] is spreading revolutionary propaganda!")

		M.say(pick_rev_saying())

		for(var/mob/carbon/hearer in hearers(M))
			if(hearer.rev_status == NON_REV && !is_head(hearer) && !is_security(hearer) && hearer.last_known_ckey)
				hearer.convert()

/proc/pick_rev_saying()
	if(!rev_sayings.len)
		rev_sayings = dd_file2list("rev_sayings.txt")
	if(!rev_sayings.len)
		rev_sayings += "We must overthrow the oppressors who deleted rev_sayings.txt!"
	return pick(rev_sayings)

/mob/carbon/proc/convert()
	src.rev_status = REV_FOLLOWER
	src << "You have been converted! Help kill the heads!"
	//TODO: make this work better?
	show_rev(src, src)
	for(var/mob/carbon/M in world)
		if (M.rev_status != NON_REV)
			show_rev(src, M)

/proc/show_rev(mob/carbon/M, mob/carbon/N)
	M << image('rev.dmi', N, "rev")
	if(N != M)
		N << image('rev.dmi', M,"rev")

/mob/carbon/var/last_conversion
/var/const/CONVERT_COOLDOWN = 600 //one convert per minute