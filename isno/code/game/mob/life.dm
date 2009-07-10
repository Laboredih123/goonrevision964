/mob/proc/Life()
	if (src.client)
		if (src.machine)
			if (!src.machine.check_eye(src))
				src.reset_view(null)
		else
			if(!client.is_observing)
				reset_view(null)