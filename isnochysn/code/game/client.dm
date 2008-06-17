/client/Del()
	world.log_access("Logout: [src.key]")
	..()

/client/New()
	src.lastKnownIP = src.address
	world.log_access("Login: [src.key] from [src.address]")

	if (config.log_access)
		for (var/mob/M in world)
			if(M.client == src)
				continue
			if(M.client && M.client.address == src.address)
				world.log_access("Notice: [src.key] has same IP address as [M.key]")
			else if (M.lastKnownIP && M.lastKnownIP == src.address && M.ckey != src.ckey)
				world.log_access("Notice: [src.key] has same IP address as [M.key] did (M.key is no longer logged in).")
				if (M.ckey in banned)
					world.log_access("Further notice: [M.key] was banned.")