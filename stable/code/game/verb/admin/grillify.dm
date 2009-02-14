// Made during the internet outage caused by hurricane ike
// fuck you ike
// love persh
/client/proc/grillify()
	set category = "Debug"
	set name = "spawn grilles"
	set desc="it spawns grilles okay fuck if I know"

	//	All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	world.log_admin("[src.name]/[src.key] used the grillify verb")
	world << "\blue<big><B>[src.name]/[src.key] commenced a metal takeover!</big></B>"

	for(var/turf/T in world)
		if(!T.density)
			spawn(-1)
				new /obj/grille(locate(T.x,T.y,T.z))