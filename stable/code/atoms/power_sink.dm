/obj/machinery/power_sink
	var/equip_used = 100
	var/environ_used = 100
	var/lighting_used = 100

	process()
		if(!stat & NOPOWER)
			use_power(environ_used, ENVIRON)
			use_power(equip_used, EQUIP)
			use_power(lighting_used, LIGHT)

	New()
		src.invisibility = 100
		return