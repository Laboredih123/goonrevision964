/mob/prespawn/say(txt as text)
	txt = sanitize(txt,256)
	if(!txt) return
	world.log_say("[src.name]/[src.key] : [txt]")
	for(var/mob/prespawn/P in world)
		P << "<b>[src.client] \[prespawn\]</b>: [txt]"
