/proc/SetupOccupationsList()
	var/list/new_occupations = list()

	for(var/occupation in occupations)
		if (!(occupation in new_occupations))
			new_occupations[occupation] = 1
		else
			new_occupations[occupation] += 1

	occupations = new_occupations
	return

/proc/reassign_job(job, list/unassigned, list/semiassigned)
	//gives job to someone who wants it more than their current job, and reassigns their current job if any
	for (var/level = 1; level <= 3; level++)
		var/list/candidates = FindOccupationCandidates(unassigned + semiassigned, job, level)
		for(var/mob/prespawn/M in candidates) //make sure they want this job more than their old one
			if(!(M in semiassigned))
				continue
			if(level >= 2 && M.client.prefs.job1 == semiassigned[M]) //first choice is their current job
				candidates -= M
				break
			if(level >= 3 && M.client.prefs.job2 == semiassigned[M]) //second choice is current job
				candidates -= M
				break
		if(!candidates.len)
			continue
		var/mob/prespawn/M = pick(candidates)
		var/oldjob = null
		if(M in semiassigned)
			oldjob = semiassigned[M]
		unassigned -= M
		semiassigned -= M
		semiassigned[M] = job
		reassign_job(oldjob, unassigned, semiassigned)
		return

/proc/allowed_to_do_job(mob/prespawn/M, job)
	if(jobban_isbanned(M, job))
		return 0
	if(M.client.authenticated)
		return 1
	return !RequiresAuth(job)

/proc/RequiresAuth(var/job)
	if(config.enable_authentication!=1) return 0
	return (job in config.require_authentication)

/proc/FindOccupationCandidates(list/unassigned, job, level)
	var/list/candidates = list()
	for(var/mob/prespawn/M in unassigned)
		if(!allowed_to_do_job(M, job)) continue
		if(level == 1 && M.client.prefs.job1 == job)	candidates += M
		if(level == 2 && M.client.prefs.job2 == job)	candidates += M
		if(level == 3 && M.client.prefs.job3 == job)	candidates += M
	return candidates

/proc/DivideOccupations()
	var/list/assigned = list()
	var/list/unassigned = list()
	var/list/semiassigned = list()

	var/list/occupation_choices = occupations.Copy()
	occupation_choices["Captain"] = 1
	if(!config.allow_ai) occupation_choices -= "AI"

	for(var/mob/prespawn/M in world)
		if(M.client && M.ready && !M.already_placed)
			unassigned += M

	if(unassigned.len == 1) // no Captain required. also don't care if they're authenticated or jobbanned.
		var/mob/prespawn/M = unassigned[1]
		if(M.client.prefs.job1 in occupation_choices)
			M.Assign_Rank(M.client.prefs.job1)
		else
			M.Assign_Rank("Captain")
	else if(unassigned.len > 1)
		//first, assign jobs to people based on how badly they want them
		for(var/level = 1; level <= 3; level++)
			if(!unassigned.len) break

			for(var/occupation in assistant_occupations)
				if(!unassigned.len) break
				var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
				for(var/mob/prespawn/candidate in candidates)
					semiassigned[candidate] = occupation
					unassigned -= candidate

			for(var/occupation in occupation_choices)
				if(!unassigned.len) break
				var/num_available = occupation_choices[occupation]
				if(!num_available)	continue
				for(var/i = 0; i < num_available; i++)
					var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
					if(!candidates.len) break
					var/mob/prespawn/candidate = pick(candidates)
					semiassigned[candidate] = occupation
					occupation_choices[occupation]--
					unassigned -= candidate


		//next, assign the jobs that absolutely must be filled (trying to fill them from unassigned first)
		var/list/necessaryjobs = list(
			"Captain",
			"Head of Personnel",
			"Station Engineer",
			"AI",
			"Medical Doctor",
			"Head of Research"
		)
		if(!config.allow_ai)
			necessaryjobs -= "AI"

		for(var/job in necessaryjobs)
			if(!unassigned.len) continue
			var/selected = null
			var/list/existing = list()
			for(var/mob/prespawn/M in semiassigned)
				if(semiassigned[M] == job) existing += M

			if(existing.len)
				var/mob/prespawn/M = pick(existing)
				semiassigned -= M
				assigned[M] = job
				continue

			// nobody has this job yet, so we have to pick someone to do it
			// if anyone doesn't have a job yet, give it to them (more fair)
			for(var/mob/prespawn/M in shuffle(unassigned))
				if(!allowed_to_do_job(M,job))
					continue
				assigned[M] = job
				unassigned -= M
				selected = M
				break

			if(!selected)	// everyone has a job, just pick randomly
				for(var/mob/prespawn/M in shuffle(semiassigned))
					if(!allowed_to_do_job(M, job))
						continue
					semiassigned -= M
					assigned[M] = job
					reassign_job(job, unassigned, semiassigned)
					break

			// don't assign this job - necessaryjobs is arranged in order of importance

		//assign remaining non-terrible jobs
		if(unassigned.len)
			var/list/remaining_occupations = list()
			for(var/occupation in occupation_choices)
				for(var/i = 0; i < occupation_choices[occupation]; i++)
					remaining_occupations += occupation
			for(var/occupation in shuffle(remaining_occupations))
				for(var/mob/prespawn/candidate in shuffle(unassigned))
					if(!allowed_to_do_job(candidate, occupation))
						continue
					semiassigned[candidate] = occupation
					occupation_choices[occupation]--
					unassigned -= candidate
					break

		//	even unauthenticated users can fill assistant roles
		for(var/mob/prespawn/M in unassigned)
			semiassigned[M] = pick(assistant_occupations)
			unassigned -= M

		//actally assign the jobs!
		for(var/mob/prespawn/M in semiassigned)	M.Assign_Rank(semiassigned[M])
		for(var/mob/prespawn/M in assigned)		M.Assign_Rank(assigned[M])

	//	still need to loop since we declare who is AI
	for (var/mob/silicon/ai/aiPlayer in world)
		spawn(0)
			if(config.random_ai_names)
				var/randomname = "HAL"	//	default name
				if(ai_names) randomname = pick(ai_names)
				var/newname = input(aiPlayer,"You are the AI. Would you like to change your name?", "Character Creation", randomname)
				if(!length(newname)) newname = randomname
				newname = strip_html(newname,30)
				aiPlayer.spawn_name = newname
				aiPlayer.voice = newname
				aiPlayer.name = newname
				spawn_ranks[aiPlayer.spawn_name] = "AI"

			world << text("<b>[] is the AI!</b>", aiPlayer.name)

	return
