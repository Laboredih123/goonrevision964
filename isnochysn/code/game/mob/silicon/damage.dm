/mob/silicon/proc/take_damage(damage)
	damage.toxin = 0
	damage.suffocation = 0
	damage.electric *= 10
	src.damage.add(damage)