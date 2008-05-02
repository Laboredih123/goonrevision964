/proc/shuffle(var/list/shufflelist)
	if (!shufflelist)
		return
	
	var/list/old_list = shufflelist.Copy()
	var/list/new_list = list()
	
	while(old_list.len)
		var/item = old_list[rand(1, old_list.len)]
		new_list += item
		old_list -= item
	
	return new_list

/proc/uniquelist(var/list/L)
	var/list/K = list()
	for(var/item in L)
		if (!(item in K))
			K += item
	return K
