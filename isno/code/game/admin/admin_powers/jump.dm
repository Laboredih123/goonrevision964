/client/proc/jump(mob/M in world)
	if(src.mob)
		src.mob.loc = get_turf(M)
		world.log_admin("[usr] ([usr.ckey]) jumped to [M] ([M.ckey])")