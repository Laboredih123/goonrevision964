/datum/mission/destroy
	New(var/tname, var/list/targets)
		src.gname = tname
		src.group = targets

	conclude()
		if(group.len)
			world << "<font color='blue'>The [gname] scourge has been eradicated!</font>"
		else
			world << "<font color='blue'>The [gname] scourge has not been eradicated!</font>"
