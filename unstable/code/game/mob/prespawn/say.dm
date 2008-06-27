/mob/prespawn/say(txt as text)
	if(!src.muted)
		txt = sanitize(txt)
		txt = copytext(txt, 1, 256)
		world.log_say("[src.name]/[src.key] : [txt]")
		for(var/mob/prespawn/P in world)
			P << "[src.client] \[prespawn\]: [txt]"