/datum/effect/report_death/New(mob/M, message)
	while(M && !M.is_dead)
		sleep(10)
	for(var/mob/reportee in world)
		if(reportee.client && length(reportee.client.powers))
			reportee << message