/datum/mission/murder
	var/client/victim = null
	var/client/attacker = null
	var/Vname = "your victim"
	var/Aname = "your attacker"

	New(var/client/A, var/client/V)
		victim = V
		attacker = A
		if(A && A.mob)	Aname = A.mob.spawn_name
		if(V && V.mob)	Vname = V.mob.spawn_name

		A << "You have been tasked with removing [Vname] from the face of this station!"
		//if(prob(25)) V << "It appears a contract has been put on your life; be wary!"

	proc/succeded()
	if(victim && victim.mob)
		Vname = victim.mob.spawn_name
	if(attacker && attacker.mob)
		Aname = attacker.mob.spawn_name

	if(victim && victim.mob && !victim.mob.is_dead)
		return false
	else
		return true

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