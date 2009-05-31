

/world/New()
	..()
	jobban_loadbanfile()

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/silicon/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.interact(M)
