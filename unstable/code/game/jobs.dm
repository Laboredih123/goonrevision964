/proc/reassign_job(datum/job/job, list/unassigned, list/semiassigned, job_choices)
	//gives job to someone who wants it more than their current job, and reassigns their current job if any
	job_choices[job]--
	for (var/level = 1; level <= 3; level++)
		var/list/candidates = find_job_candidates(unassigned + semiassigned, job, level)
		for(var/mob/prespawn/M in candidates) //make sure they want this job more than their old one
			if(!(M in semiassigned))
				continue
			if(level >= 2 && M.client.prefs.job1 == semiassigned[M]) //first choice is their current job
				candidates -= M
			else if(level >= 3 && M.client.prefs.job2 == semiassigned[M]) //second choice is current job
				candidates -= M
		if(!candidates.len)
			continue
		job_choices[job]++
		var/mob/prespawn/M = pick(candidates)
		var/oldjob = null
		if(M in semiassigned)
			oldjob = semiassigned[M]
		unassigned -= M
		semiassigned -= M
		semiassigned[M] = job
		reassign_job(oldjob, unassigned, semiassigned, job_choices)
		return

/proc/allowed_to_do_job(mob/prespawn/M, job)
	if(jobban_isbanned(M, job))
		return 0
	if(M.client.authenticated)
		return 1
	return !config.enable_authentication

/proc/find_job_candidates(list/unassigned, datum/job/job, level)
	var/list/candidates = list()
	for(var/mob/prespawn/M in unassigned)
		if(!allowed_to_do_job(M, job)) continue
		if(level == 1 && M.client.prefs.job1 == job)	candidates += M
		if(level == 2 && M.client.prefs.job2 == job)	candidates += M
		if(level == 3 && M.client.prefs.job3 == job)	candidates += M
	return candidates

/proc/divide_jobs()
	var/list/assigned = list()
	var/list/unassigned = list()
	var/list/semiassigned = list()
	var/list/priorities = list()

	var/list/job_choices_left = get_all_job_instances()
	job_choices_left = job_choices_left.Copy()
	for(var/datum/job/j in job_choices_left)
		if(istype(j, /datum/job/ai) && !config.allow_ai)
			job_choices_left -= j
		job_choices_left[j] = j.max
		if(!j.priority in priorities)
			priorities += j.priority

	for(var/mob/prespawn/M in world)
		if(M.client && M.ready && !M.already_placed)
			unassigned += M

	if(unassigned.len == 1) // no Captain required. also don't care if they're authenticated or jobbanned.
		var/mob/prespawn/M = unassigned[1]
		var/datum/job/j = M.client.prefs.job1
		if(!j)
			j = get_job_instance_by_type(/datum/job/captain)
		j.create(M)
	else if(unassigned.len > 1)
		//first, semiassign jobs to people based on how badly they want them
		for(var/mob/prespawn/P in unassigned)
			var/datum/preferences/prefs = P.client.prefs
			for(var/datum/job/j in list(prefs.job1, prefs.job2, prefs.job3))
				if(job_choices_left[j] > 0)
					semiassigned[P] = j
					job_choices_left[j]--
					unassigned -= P

		// next, assign the jobs that must be filled (trying to fill them from unassigned first)
		// we don't care about the actual priority numbers, just the order
		// this is a very good thing, since byond doesn't allow indexing by arbitrary ints because it's awful
		// this implementation is not quite optimal - if multiple jobs have the same priority, it imposes an
		// arbitrary order without first checking if the remaining un/semiassigned prefer one or the other.
		// in practice, this shouldn't matter much.
		var/list/jobs_by_priority = list()
		for(var/datum/job/j in job_choices_left)
			if(j.priority <= 1)
				continue
			var/inserted = 0
			for(var/i = 1; i < jobs_by_priority.len; i++)
				var/datum/job/job = jobs_by_priority[i]
				if(job.priority < j.priority)
					jobs_by_priority.Insert(i, j)
					inserted = 1
					break
			if(!inserted)
				jobs_by_priority += j

		for(var/datum/job/j in jobs_by_priority)
			if(!unassigned.len && !semiassigned.len)
				break
			var/selected = null

			var/list/existing = list()
			for(var/mob/prespawn/M in semiassigned)
#ifdef DEATH_COMMANDO_DEATHMATCH_FUCK_AROUND
				assigned[M] = j
				semiassigned -= M
#else
				if(semiassigned[M] == j)
					existing += M
#endif
			if(existing.len)
				var/mob/prespawn/M = pick(existing)
				semiassigned -= M
				assigned[M] = j
				continue

			// nobody has this job yet, so we have to pick someone to do it
			// if anyone doesn't have a job yet, give it to them (more fair)
			for(var/mob/prespawn/M in shuffle(unassigned))
				if(!allowed_to_do_job(M,j))
					continue
				assigned[M] = j
				unassigned -= M
				selected = M
				break

			if(!selected)	// everyone has a job, just pick randomly
				for(var/mob/prespawn/M in shuffle(semiassigned))
					if(!allowed_to_do_job(M, j))
						continue
					assigned[M] = j
					semiassigned -= M
					reassign_job(j, unassigned, semiassigned, job_choices_left)
					break

			// don't assign this job - only happens if the more important jobs are all filled and there are no people left

		//assign remaining non-terrible jobs
		if(unassigned.len)
			for(var/priority in sort_list_num_desc(priorities))
				var/list/choices = list()
				for(var/datum/job/j in job_choices_left)
					if(j.priority == priority && job_choices_left[j] > 0)
						choices += j
				for(var/mob/prespawn/P in unassigned)
					var/datum/job/j = pick(choices) // does not weight by max, whether this is good or bad is debatable
					if(!allowed_to_do_job(P, j))
						continue
					if(!choices.len)
						break
					semiassigned[P] = j
					job_choices_left[j]--
					unassigned -= P
					if(job_choices_left[j] < 0)
						choices -= j

		if(unassigned.len) // STILL? this shouldnt ever happen unless you're jobbanned from technician
			// just give them an assistant job
			for(var/mob/prespawn/P in unassigned)
				var/datum/job/j = get_job_instance_by_type(/datum/job/technician)
				semiassigned[P] = j
				unassigned -= P

		//actally assign the jobs!
		// TODO: check that deleting the prespawn in the middle of the loop (as this does) doesnt break things
		for(var/mob/prespawn/M in semiassigned)
			var/datum/job/j = semiassigned[M]
			j.create(M)
		for(var/mob/prespawn/M in assigned)
			var/datum/job/j = assigned[M]
			j.create(M)

	return
