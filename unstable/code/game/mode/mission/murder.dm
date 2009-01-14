/datum/mission/murder
	var/mob/victim = null
	var/mob/attacker = null
	var/Vname = "your victim"
	var/Aname = "your attacker"

	New(mob/M)
		attacker = M
		victim = pick_cliented_mob_except(M)
		if(attacker)
			Aname = attacker.spawn_name
		if(victim)
			Vname = victim.spawn_name
		attacker << "You have been tasked with removing [Vname] from the face of this station!"

	proc/succeeded()
		if(victim)
			Vname = victim.spawn_name
		if(attacker)
			Aname = attacker.spawn_name

		if(victim && !victim.is_dead)
			return 0
		else
			return 1

	conclude()
		if(src.succeeded())
			if(attacker)
				if(victim)
					attacker << "Congratulations! [capitalize(Vname)] no longer draws breath."
				else
					attacker << "Congratulations! [capitalize(Vname)] has left this world and its hardships."
			if(victim)
				if(attacker)
					victim << "Your death has fulfilled the obligations of [Aname]"
				else
					victim << "Your death serves the goals of those around you; too bad you may never know who benefitted."
		else
			if(attacker)
				if(victim)
					attacker << "You have failed! [capitalize(Vname)] still draws breath!"
				else
					attacker << "You have failed to finish off your victim"
			if(victim)
				if(attacker)
					victim << "You have successfully eluded [Aname], who wished to kill you."
				else
					victim << "You have survived, to the great consternation of other folks."

	proc/pick_cliented_mob_except(mob/E)
		var/list/L = new()
		for(var/mob/M in world)
			if(M != E && M.client)
				L += M
		return pick(L)