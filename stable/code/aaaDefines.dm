#include "atoms.dm"
/atom/proc/burn(fi_amount)
	return

/atom/movable/Move()
	var/atom/A = src.loc
	. = ..()
	src.move_speed = ss13time() - src.l_move_time
	src.l_move_time = ss13time()
	src.m_flag = 1
	if ((A != src.loc && A && A.z == src.z))
		src.last_move = get_dir(A, src.loc)
		src.moved_recently = 1
	return