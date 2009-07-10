/datum/termination_condition/all // terminates only when all conditions are met
	var/list/conds
	var/conclusion = null

	New(list/conds, conclusion)
		src.conds = conds
		src.conclusion = conclusion

	check()
		for(var/datum/termination_condition/T in conds)
			if(!T.check())
				return 0
		return 1

	conclude() //what happens when the termination condition is fulfilled
		if(conclusion)
			world << conclusion
		else
			for(var/datum/termination_condition/T in conds)
				T.conclude()