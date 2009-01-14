/datum/game_mode/traitor
	name = "traitor"

	var/const/obj_murder = 1
	var/const/obj_hijack = 2
	var/const/obj_steal = 3
	var/const/obj_sabotage = 4
	var/const/ai_obj_murder = 5
	var/const/ai_obj_evacuate = 6

	var/const/laser = 1
	var/const/hand_tele = 2
	var/const/plasma_bomb = 3
	var/const/jetpack = 4
	var/const/captain_card = 5
	var/const/captain_suit = 6

	var/const/destroy_plasma = 1
	var/const/destroy_ai = 2
	var/const/kill_monkeys = 3
	var/const/cut_power = 4

	announce()
		return

	setup()
		termination_conditions += new/datum/termination_condition/shuttle()

		var/list/synd_list = get_synd_list()
		if(synd_list.len)
			killer = pick(synd_list)
		else
			killer = pick(get_human_list())

		var/objective = pick_objective(killer)

	proc/pick_objective(mob/killer)
		var/list/targets = get_human_list()
		if(targets.len < 2)
			if(istype(killer, /mob/silicon/ai))
				return ai_obj_evacuate
			else
				return pick(obj_hijack, obj_steal, obj_sabotage)
		else
			if(istype(killer, /mob/silicon/ai))
				return pick(ai_obj_evacuate, ai_obj_murder)
			else
				return pick(obj_hijack, obj_steal, obj_sabotage, obj_murder)
