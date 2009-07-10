/var/time_offset = 0
/var/last_time = -1

/proc/ss13time()
	// returns an integer equal to the number of 1/10 seconds since an unspecified time, which is constant
	// while the world is running
	// this avoids the problems of BYOND's only time functions:
	// world.realtime - so large that it needs a float, and loses precision
	// world.time - measures ticks, not seconds
	// world.timeofday - not sequential, resets to 0 at midnight
	// it'd be nice if there were a decent library to do this, but unfortunately no decent coders use BYOND
	// if you go more than a day without calling this it will be inaccurate. it'd be possible to fix that but eh.
	var/t = world.timeofday
	if(last_time > t)
		time_offset += 36000 // add 1 day to offset
	last_time = t
	return t + time_offset
