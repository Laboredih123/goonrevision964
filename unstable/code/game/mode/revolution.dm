/var/const/NON_REV = 0
/var/const/REV_FOLLOWER = 1
/var/const/REV_LEADER = 2

/mob/carbon/var/rev_status = NON_REV

/datum/game_mode/revolution
	name = "revolution"
	var/const/NUM_REVS = 3
	min_players = 3 + NUM_REVS
	var/list/revs = null
	var/list/heads = null

	announce()
		world << "IT'S A REVOLUTION"

	setup()
		while(1)
			var/curNum = 0
			for(var/mob/prespawn/M in world)
				if(M.client && M.ready)
					curNum ++
			if(curNum < min_players)
				world << "Don't seem to be enough people for a decent game of revolution."
				sleep(50) //5 seconds
			else
				break

	execute()
		while (1)
			revs = get_revs()
			if(revs)
				break
			sleep(30)
		heads = get_heads()

		var/list/headdeaths = list()
		for(var/mob/head in heads)
			headdeaths += new /datum/termination_condition/death(head, head.spawn_name)
		termination_conditions += new /datum/termination_condition/all(headdeaths, "The heads are all dead!")

		var/list/revdeaths = list()
		for(var/mob/rev in revs)
			revdeaths += new /datum/termination_condition/death(rev, rev.spawn_name)
		termination_conditions += new /datum/termination_condition/all(revdeaths, "The revolutionaries are all dead!")

		for(var/mob/carbon/M in revs)
			new /datum/effect/traitor_radio(M)
			new /datum/effect/convert(M)
			M.rev_status = REV_LEADER
			for(var/mob/carbon/N in revs)
				show_rev(M, N) // give people a rev flag on themselves too

		missions += new /datum/mission/murders(revs, "the revolutionaries", heads, "the heads")

		..()

	get_traitors()
		return revs

	proc/get_heads()
		var/list/L = list()
		for(var/mob/carbon/M in world)
			if(is_head(M))
				L += M
		return L

	proc/get_revs()
		var/list/want_synd = list()
		var/list/rest = list()
		for(var/mob/carbon/M in world)
			if (!M.client)
				continue
			if(is_head(M) || is_security(M))
				continue
			if(M.client.prefs && M.client.prefs.be_syndicate)
				want_synd += M
			else
				rest += M
		if(want_synd.len + rest.len < NUM_REVS)
			return
		var/list/L = list()
		for(var/i = 1 to NUM_REVS)
			if(want_synd.len)
				var/x = pick(want_synd)
				want_synd -= x
				L += x
			else
				var/x = pick(rest)
				rest -= x
				L += x
		return L

/proc/is_head(mob/carbon/M)
	var/datum/job/r = M.spawn_job
	//TODO: make this not gross
	if(istype(r, /datum/job/captain) || istype(r, /datum/job/hop) || istype(r, /datum/job/hor))
		return 1
	else
		return 0

/proc/is_security(mob/carbon/M)
	var/datum/job/r = M.spawn_job
	if(istype(r, /datum/job/detective) || istype(r, /datum/job/security))
		return 1
	else
		return 0