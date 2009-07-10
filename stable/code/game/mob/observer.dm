/mob/observer
	layer = 1		//	not used
	density = 0		//	not used
	is_dead = 1		//	not used
	canmove = 0		//	not used
	is_blind = 0	//	not used
	anchored = 1	//  don't get pushed around
	var/mob/corpse = null	//	observer mode
	var/datum/hud/carbon/hud = null // hud
	invisibility = 101

/mob/observer/New(mob/corpse)
	src.corpse		= corpse
	src.loc			= corpse.loc
	src.name		= corpse.name
	src.voice		= corpse.voice
	src.spawn_name	= corpse.spawn_name
	src.sight |= SEE_TURFS | SEE_MOBS | SEE_INFRA | SEE_OBJS
	src.see_invisible = 100
	src.see_infrared = 100
	src.see_in_dark = 100

	src.verbs += /mob/observer/proc/examine_anything

	if(istype(corpse,/mob/carbon))
		src.hud = corpse:hud
		if(!src.corpse.is_dead)
			//	stop our body from wandering
			src.corpse:resting = 1

/mob/observer/Move(NewLoc, direct)
	if(NewLoc)
		src.loc = NewLoc
		return
	if((direct & NORTH) && src.y < world.maxy)
		src.y++
	if((direct & SOUTH) && src.y > 1)
		src.y--
	if((direct & EAST) && src.x < world.maxx)
		src.x++
	if((direct & WEST) && src.x > 1)
		src.x--

/mob/observer/verb/JumpToZ()
	var/list/L = list()
	for(var/z = 1; z <= world.maxz; z++)
		L += z
	src.z = input("Choose a z-level to jump to.", "Z LEVEL", src.z) in L

/mob/observer/examine()
	if(usr)	usr << src.desc

/mob/observer/can_use_hands()	return 0
/mob/observer/is_active()		return 0

/mob/observer/Life()
	if(src.hud) src.hud.update_icons()

/mob/observer/proc/examine_anything(atom/A in world)
	set name = "examine"
	A.examine()

/mob/observer/verb/jump(mob/M in world)
	src.loc = get_turf(M)