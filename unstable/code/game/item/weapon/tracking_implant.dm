/obj/item/weapon/implant/tracking
	name = "tracking"
	var/freq = 1451
	var/id = 1.0

	proc/get_freq_text()
		return round(freq / 10, 0.1)