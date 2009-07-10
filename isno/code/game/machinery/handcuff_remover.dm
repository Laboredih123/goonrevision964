/obj/machinery/handcuff_remover
	icon = 'handcuff_remover.dmi'
	icon_state = ""
	name = "Handcuff Remover"
	var/const/WAIT_TIME = 100 // 10 seconds
	var/operating = 0
	anchored = 1
	layer = 5 // got to be above pipes at least, might need to be adjusted when it's put with something else

	interact_cuffed(mob/carbon/user)
		if(operating)
			return
		var/turf/T = user.loc
		if(T != src.loc) // it goes on a wall, the only tile that can access it is the one you're on
			return
		user.show_viewers("\red <b>[user] is using the handcuff remover.</b>")
		src.icon_state = "operating"
		src.operating = 1
		sleep(WAIT_TIME)
		src.operating = 0
		src.icon_state = ""
		if(!user.hasMoved(T) && user.handcuffs) // still cuffed, hasn't moved (probably)
			user.show_viewers("\red <b>[user]'s handcuffs fall off!</b>")
			user.drop(SLOT_HANDCUFFS)