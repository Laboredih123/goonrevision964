/datum/ban/round
	var/endat = 0

	New(id, origckey, reason, adminckey, length) // length in rounds
		..()
		endat = length + curround

	is_banned()
		if(endat <= curround)
			return 0
		else
			return 1

	get_duration_desc()
		return "for [endat - curround] round\s"