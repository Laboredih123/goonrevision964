/obj/item/weapon/locator/proc/get_freq_text()
	return round(src.freq/10, 0.1)

/obj/item/weapon/locator/attack_self(mob/user as mob)

	user.machine = src
	var/dat
	if (src.temp)
		dat = text("[]<BR><BR><A href='?src=\ref[];temp=1'>Clear</A>", src.temp, src)
	else
		dat = "<B>Persistent Signal Locator</B><HR>"
		dat += "Frequency: <A href='?src=\ref[src];freq=-10'>-</A>"
		dat += "<A href='?src=\ref[src];freq=-2'>-</A>"
		dat += src.get_freq_text()
		dat += "<A href='?src=\ref[src];freq=2'>+</A>"
		dat += "<A href='?src=\ref[src];freq=10'>+</A>"
		dat += "<BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/locator/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)
			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"
				for(var/obj/item/weapon/radio/beacon/W in world)
					if (W.freq == src.freq)
						var/turf/tr = get_turf(W)
						if ((tr.z == sr.z && tr))
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += text("[]-[]-[]<BR>", W.code, dir2text(get_dir(sr, tr)), direct)
					//Foreach goto(114)
				src.temp += "<B>Extranneous Signals:</B><BR>"
				for(var/obj/item/weapon/implant/tracking/W in world)
				//Label_332:
					if (W.freq == src.freq)
						if ((!( W.implanted ) || !( istype(W.loc, /mob/carbon) )))
							continue //goto Label_332
						else
							var/mob/carbon/M = W.loc
							if (M.is_dead)
								if (M.timeofdeath + 6000 < world.time)
									continue //goto(332)
						var/turf/tr = get_turf(W)
						if ((tr.z == sr.z && tr))
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 20)
								if (direct < 5)
									direct = "very strong"
								else
									if (direct < 10)
										direct = "strong"
									else
										direct = "weak"
								src.temp += text("[]-[]-[]<BR>", W.id, dir2text(get_dir(sr, tr)), direct)
					//Foreach goto(332)
				src.temp += text("<B>You are at \[[],[],[]\]</B> in orbital coordinates.<BR><BR><A href='?src=\ref[];refresh=1'>Refresh</A><BR>", sr.x, sr.y, sr.z, src)
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.freq += text2num(href_list["freq"])
				src.freq = min(1489, src.freq)
				src.freq = max(1441, src.freq)
			else
				if (href_list["temp"])
					src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
				//Foreach goto(749)
	return