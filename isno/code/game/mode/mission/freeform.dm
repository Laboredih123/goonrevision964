/datum/mission/freeform
	var/desc
	New(list/group, gname, desc)
		src.desc = desc
		..()

	description()
		return desc