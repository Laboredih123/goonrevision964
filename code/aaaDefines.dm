#include "atoms.dm"

/obj/proc/throwing(t_dir, rs)

	if (src.throwspeed <= 1)
		src.throwing = 0
	src.throwspeed--
	if (rs == 0)
		rs = 1
	if (src.throwing)
		if (rs == 1)
			step(src, t_dir)
			sleep(1)
			spawn( 0 )
				throwing(t_dir, rs)
				return
		else
			if (rs > 1)
				var/t = null
				while(t < rs)
					step(src, t_dir)
					t++
				sleep(10)
				spawn( 0 )
					src.throwing(t_dir, rs)
					return
			else
				step(src, t_dir)
				sleep(10 / rs)
				spawn( 0 )
					throwing(t_dir, rs)
					return
	else
		//*****RM
		//src.density = 0
		if(istype(src, /obj/item))
			src.density = 0

		//*****
	return


//*****RM

/obj/Bump(atom/O)

	if (src.throwing)
		//world<<"[src] bumped into [O] and stopped"
		src.throwing = 0
	..()

//*****
/atom/proc/burn(fi_amount)

	return

/atom/movable/Move()

	var/atom/A = src.loc
	. = ..()
	src.move_speed = world.time - src.l_move_time
	src.l_move_time = world.time
	src.m_flag = 1
	if ((A != src.loc && A && A.z == src.z))
		src.last_move = get_dir(A, src.loc)
	return
