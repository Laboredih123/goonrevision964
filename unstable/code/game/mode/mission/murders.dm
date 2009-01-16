/datum/mission/murders
	var/mob/list/victims = null
	var/mob/list/attackers = null
	var/Vdesc = "your victim"
	var/Adesc = "your attacker"
	var/A_plur = 0
	var/V_plur = 0

	New(list/A, Aname, A_is_plural, mob/V, Vname, V_is_plural)
		attackers = A
		victims = V
		src.Adesc = Aname
		src.Vdesc = Vname
		A_plur = A_is_plural
		V_plur = V_is_plural
		for(var/attacker in attackers)
			attacker << "You have been tasked with removing [Vdesc] from the face of this station!"

	proc/succeeded()
		for(var/mob/carbon/V in victims)
			if(!V)
				continue
			if(istype(V, /mob) && !V.is_dead)
				return 0
		return 1

	conclude()
		if(src.succeeded())
			for(var/attacker in attackers)
				attacker << "Congratulations! [capitalize(Vdesc)] no longer [V_plur?"draw":"draws"] breath."
			for(var/victim in victims)
				victim << "Your death has fulfilled the obligations of [Adesc]"
		else
			for(var/attacker in attackers)
				attacker << "You have failed! [capitalize(Vdesc)] still [V_plur?"draw":"draws"] breath!"
			for(var/victim in victims)
				victim << "You have successfully eluded [Adesc], who wished to kill you."

/proc/pick_cliented_human_except(mob/E)
	var/list/L = new()
	for(var/mob/carbon/human/M in world)
		if(M != E && M.client)
			L += M
	return pick(L)