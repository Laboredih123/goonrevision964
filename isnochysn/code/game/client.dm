/client/Del()
	world.log_access("Logout: [src.key]")
	..()

/client/New()
	if (banned.Find(src.ckey))
		del(src)
	src.lastKnownIP = src.address
	world.log_access("Login: [src.key] from [src.address]")

	src << text("\blue <B>[]</B>", world_message)

	if (config.log_access)
		for (var/mob/M in world)
			if(M.client == src)
				continue
			if(M.client && M.client.address == src.address)
				world.log_access("Notice: [src.key] has same IP address as [M.key]")
			else if (M.last_known_ip && M.last_known_ip == src.address && M.ckey != src.ckey)
				world.log_access("Notice: [src.key] has same IP address as [M.key] did (M.key is no longer logged in).")
				if (M.ckey in banned)
					world.log_access("Further notice: [M.key] was banned.")
	..()