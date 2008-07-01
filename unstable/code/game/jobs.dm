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

/proc/PickOccupationCandidate(list/candidates)
	if (candidates.len > 0)
		var/list/randomcandidates = shuffle(candidates)
		candidates -= randomcandidates[1]
		return randomcandidates[1]

	return null

/proc/DivideOccupations()
	var/list/unassigned = list()
	var/list/occupation_choices = occupations.Copy()
	var/list/occupation_eligible = occupations.Copy()
	occupation_choices = shuffle(occupation_choices)

	for (var/mob/prespawn/M in world)
		if (M.client && M.ready && !M.already_placed)
			unassigned += M

			// If someone picked AI before it was disabled, or has a saved profile with it
			// on a game that now lacks it, this will make sure they don't become the AI,
			// by changing that choice to Captain.
			if (!config.allow_ai)
				if (M.char_job1 == "AI")
					M.char_job1 = "Captain"
				if (M.char_job2 == "AI")
					M.char_job2 = "Captain"
				if (M.char_job3 == "AI")
					M.char_job3 = "Captain"

	if (unassigned.len == 0)
		return

	var/mob/prespawn/captain_choice = null
	for (var/level = 1 to 3)
		var/list/captains = FindOccupationCandidates(unassigned, "Captain", level)
		var/mob/prespawn/candidate = PickOccupationCandidate(captains)

		if (candidate != null)
			captain_choice = candidate
			unassigned -= captain_choice
			break

	if (captain_choice == null && unassigned.len > 1)
		unassigned = shuffle(unassigned)
		captain_choice = unassigned[1]
		unassigned -= captain_choice

	if (captain_choice == null)
		world << "Captainship not forced on someone since this is a one-player game."
	else
		captain_choice.Assign_Rank("Captain")

	for (var/level = 1 to 3)
		if (unassigned.len == 0)
			break

		for (var/occupation in assistant_occupations)
			if (unassigned.len == 0)
				break
			var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
			for (var/mob/prespawn/candidate in candidates)
				candidate.Assign_Rank(occupation)
				unassigned -= candidate

		for (var/occupation in occupation_choices)
			if (unassigned.len == 0)
				break
			var/eligible = occupation_eligible[occupation]
			if (eligible == 0)
				continue
			var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
			var/eligiblechange = 0
			while (eligible--)
				var/mob/prespawn/candidate = PickOccupationCandidate(candidates)
				if (candidate == null)
					break
				candidate.Assign_Rank(occupation)
				unassigned -= candidate
				eligiblechange++
			occupation_eligible[occupation] -= eligiblechange

	if (unassigned.len)
		unassigned = shuffle(unassigned)
		for (var/occupation in occupation_choices)
			if (unassigned.len == 0)
				break
			var/eligible = occupation_eligible[occupation]
			while (eligible-- && unassigned.len > 0)
				var/mob/prespawn/candidate = unassigned[1]
				if (candidate == null)
					break
				candidate.Assign_Rank(occupation)
				unassigned -= candidate

	for (var/mob/prespawn/M in unassigned)
		M.Assign_Rank(pick(assistant_occupations))

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
