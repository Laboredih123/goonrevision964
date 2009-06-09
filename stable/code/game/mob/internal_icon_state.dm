// Kurper is a bro
/var/list/internal_percents = null
/mob/proc/get_internal_icon_state(obj/item/weapon/tank/internal, obj/screen/internal_screen)
	if(!internal_percents)
		internal_percents = list()
		for(var/name in icon_states(internal_screen.icon))
			var/pos = findtext(name, "internal1-")
			if(pos)
				var/percent = copytext(name, length("internal1-") + 1)
				internal_percents[percent] = name // would use text2num but can't have arbitrary int keys :(
	// TODO: Make this work with arbitrary intervals, ideally even mutltiple different intervals at once
	var/percent = 100 * internal.gas.tot_gas() / internal.maximum
	// TODO: profile, see if num2text uses enough cpu to be worth caching
	return internal_percents[num2text(round(percent, 20))]