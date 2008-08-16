/mob/observer
	layer = 1	//	not used
	density = 0	//	not used
	is_dead = 1	//	not used
	canmove = 0	//	not used
	anchored = 1 // don't get pushed around
	var/mob/corpse = null	//	observer mode

/mob/observer/New(var/mob/corpse)
	set invisibility = 101
	src.corpse		= corpse
	src.loc			= corpse.loc
	src.name		= corpse.name
	src.voice		= corpse.voice
	src.spawn_name	= corpse.spawn_name
	src.sight |= SEE_TURFS | SEE_MOBS | SEE_INFRA | SEE_OBJS
	src.see_invisible = 100
	src.see_infrared = 100
	src.see_in_dark = 100

	if(!src.corpse.is_dead)
		if(istype(corpse,/mob/carbon))
			//	stop our body from wandering
			src.corpse:resting = 1

/mob/observer/Move(NewLoc, direct)
	if(NewLoc)
		src.loc = NewLoc
		return
	if(direct & NORTH)	src.y++
	if(direct & SOUTH)	src.y--
	if(direct & EAST)	src.x++
	if(direct & WEST)	src.x--

/mob/observer/examine()
	if(usr)	usr << src.desc

/mob/observer/can_use_hands()	return 0
/mob/observer/is_active()		return 0
