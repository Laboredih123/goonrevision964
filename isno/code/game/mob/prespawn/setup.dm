/mob/prespawn
	var/ready = 0
	canmove = 1
	icon = 'quivering_mass.dmi'

	New()
		. = ..()
		src.verbs -= /mob/verb/add_memory
		src.verbs -= /mob/verb/cancel_camera
		src.verbs -= /mob/verb/memory
		src.verbs -= /mob/verb/observe
		src.verbs -= /mob/verb/respawn
		src.verbs -= /mob/verb/switch_language