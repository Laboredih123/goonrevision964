/mob/carbon/Stat()
	..()
	stat(null, text("Intent: []", src.intent))
	if(src.client.statpanel == "Status")
		if (src.internal)
			if (!( src.internal.gas ))
				del(src.internal)
			else
				stat(null, text("Internal Atmosphere: []", src.internal))
				stat(null, text("Internal Oxygen: []", src.internal.gas.oxygen))
				stat(null, text("Internal Plasma: []", src.internal.gas.plasma))
	if(shuttle_status == SHUTTLE_COMING)
		stat(null, "Shuttle will arrive in [time2text(shuttle_time_left, "mm:ss")]")
		// this is not strictly OK by the definition of time2text, which is supposed to take seconds since the BYOND
		// era and return the time represented by that
		// however, as long as the time left is less than an hour, it works fine, since the BYOND era starts at
		// 00:00:00.
		// timezones may make it impossible to easily adapt this to times longer than an hour, however.
	else if(shuttle_status == SHUTTLE_RETURNING)
		stat(null, "Shuttle distance: [time2text(shuttle_time_left, "mm:ss")]")
	else if(shuttle_status == SHUTTLE_DOCKED)
		stat(null, "Shuttle will depart in [time2text(shuttle_time_left, "mm:ss")]")