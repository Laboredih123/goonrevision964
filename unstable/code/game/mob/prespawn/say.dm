/mob/prespawn/say(txt as text)
	txt = copytext(sanitize(txt),1,256)
	if(!txt) return
	world.log_say("[src.name]/[src.key] : [txt]")
	for(var/mob/prespawn/P in world)
		P << "[src.client] \[prespawn\]: [txt]"
