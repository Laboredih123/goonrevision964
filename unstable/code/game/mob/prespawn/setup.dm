/mob/prespawn
	var/ready = 0
	opacity = 0
	density = 0
	icon = null
	icon_state = null

/mob/prespawn/New()
	..()
	src.verbs -= /mob/verb/add_memory
	src.verbs -= /mob/verb/cancel_camera
	src.verbs -= /mob/verb/memory
	src.verbs -= /mob/verb/observe
	src.verbs -= /mob/verb/respawn
	src.verbs -= /mob/verb/switch_language

	return

/mob/prespawn/Topic(href, href_list)
	if(src != usr)
		return ..()
