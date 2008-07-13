/proc/SetupOccupationsList()
	var/list/new_occupations = list()

	for(var/occupation in occupations)
		if (!(new_occupations.Find(occupation)))
			new_occupations[occupation] = 1
		else
			new_occupations[occupation] += 1

	occupations = new_occupations
	return

/proc/FindOccupationCandidates(list/unassigned, job, level)
	var/list/candidates = list()

	for (var/mob/prespawn/M in unassigned)
		if (level == 1 && M.char_job1 == job)
			candidates += M

		if (level == 2 && M.char_job2 == job)
			candidates += M

		if (level == 3 && M.char_job3 == job)
			candidates += M

	return candidates

/proc/reassign_job(job, list/unassigned, list/semiassigned)
	//gives job to someone who wants it more than their current job, and reassigns their current job if any
	for (var/level = 1; level <= 3; level++)
		var/list/candidates = FindOccupationCandidates(unassigned + semiassigned, job, level)
		for(var/mob/prespawn/M in candidates) //make sure they want this job more than their old one
			if(M in semiassigned)
				if(level >= 2 && M.char_job1 == semiassigned[M]) //first choice is their current job
					candidates -= M
					break
				if(level >= 3 && M.char_job2 == semiassigned[M]) //second choice is current job
					candidates -= M
					break
		if(candidates.len)
			var/mob/prespawn/M = pick(candidates)
			var/oldjob = null
			if(M in semiassigned)
				oldjob = semiassigned[M]
			unassigned -= M
			semiassigned -= M
			semiassigned[M] = job
			reassign_job(oldjob, unassigned, semiassigned)
			return

/proc/DivideOccupations()
	var/list/unassigned = list()
	var/list/semiassigned = list()
	var/list/assigned = list()

	var/list/occupation_choices = list()
	for(var/i in occupations)
		if(occupation_choices[i])
			occupation_choices[i]++
		else
			occupation_choices[i] = 1

	for (var/mob/prespawn/M in world)
		if (M.client && M.ready && !M.already_placed)
			unassigned += M

	//first, assign jobs to people based on how badly they want them
	for (var/level = 1; level <= 3; level++)
		if (unassigned.len == 0)
			break

		for (var/occupation in assistant_occupations)
			if (unassigned.len == 0)
				break
			var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
			for (var/mob/prespawn/candidate in candidates)
				unassigned -= candidate
				semiassigned[candidate] = occupation

		for (var/occupation in occupation_choices)
			if (unassigned.len == 0)
				break
			var/num_available = occupation_choices[occupation]
			if (num_available == 0)
				continue
			for(var/i = 0; i < num_available; i++)
				var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
				if(!candidates.len)
					break
				var/mob/prespawn/candidate = pick(candidates)
				unassigned -= candidate
				semiassigned[candidate] = occupation
				occupation_choices[occupation]--
	//next, assign the jobs that absolutely must be filled (trying to fill them from unassigned first)
	var/list/necessaryjobs = list(
		"Captain",
		"AI",
		"Head of Personnel",
		"Head of Research",
		"Station Engineer",
		"Medical Doctor"
	)
	for(var/job in necessaryjobs)
		// first check that nobody already has this job
		// if people do, pick a random one of them to perma-have it
		// (this way, even if there are 3 station engineers in semiassigned you'll still end up with a doctor)
		var/list/existing = list()
		for(var/mob/prespawn/M in semiassigned)
			if(semiassigned[M] == job)
				existing += M
		if(existing.len)
			var/mob/prespawn/M = pick(existing)
			semiassigned -= M
			assigned[M] = job
			continue
		// nobody has this job yet, so we have to pick someone to do it
		// if anyone doesn't have a job yet, give it to them (more fair)
		if(unassigned.len)
			var/mob/prespawn/M = pick(unassigned)
			unassigned -= M
			assigned[M] = job
			continue
		// everyone has a job, just pick randomly
		// could do it based on whether they have this job in their preferences,
		// but that is a bad idea because it makes it undesirable to put your real preferences
		// for example, Bob puts AI as first choice and Captain as second, Bill puts AI as first
		// under that system, Bob would always be Captain, which sucks for Bob
		// under this system, both of them have an equal chance to be AI
		if(semiassigned.len)
			var/mob/prespawn/M = pick(semiassigned)
			semiassigned -= M
			assigned[M] = job
			//now we have to reassign his job
			reassign_job(job, unassigned, semiassigned)
		// if semiassigned is empty too, just don't assign this job - necessaryjobs is arranged in order of importance

	//assign remaining non-terrible jobs
	if (unassigned.len)
		for (var/occupation in occupation_choices)
			var/num_available = occupation_choices[occupation]
			if (num_available == 0)
				continue
			for(var/i = 0; i < num_available; i++)
				if (unassigned.len == 0)
					break
				var/mob/prespawn/candidate = pick(unassigned)
				unassigned -= candidate
				semiassigned[candidate] = occupation
				occupation_choices[occupation]--

	for (var/mob/prespawn/M in unassigned)
		unassigned -= M
		semiassigned[M] = pick(assistant_occupations)

	//actally assign the jobs!
	for(var/mob/prespawn/M in semiassigned)
		M.Assign_Rank(semiassigned[M])
	for(var/mob/prespawn/M in assigned)
		M.Assign_Rank(assigned[M])

	for (var/mob/silicon/ai/aiPlayer in world)
		spawn(0)
			var/randomname = pick(ai_names)
			var/newname = input(
				aiPlayer,
				"You are the AI. Would you like to change your name to something else?", "Name change",
				randomname)

			if (length(newname) == 0)
				newname = randomname

			if (newname)
				if (length(newname) >= 26)
					newname = copytext(newname, 1, 26)
				newname = dd_replacetext(newname, ">", "'")
				aiPlayer.spawn_name = newname
				aiPlayer.name = newname
				aiPlayer.voice = newname

			world << text("<b>[] is the AI!</b>", aiPlayer.name)

	return
