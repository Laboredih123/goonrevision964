/mob/Stat()
	..()
	statpanel("Status")

	if (src.client.statpanel == "Status" && ticker)
			var/timel = ticker.timeleft
			stat(null, text("Shuttle ETA-[]:[][]", timel / 600 % 60, timel / 100 % 6, timel / 10 % 10))
	return