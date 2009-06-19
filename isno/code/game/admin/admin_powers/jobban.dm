/datum/admin_power/jobban
	name = "Job Ban"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_MOD | ADMIN_ADMIN | ADMIN_SUPERADMIN

	Topic(href, href_list)
		..()
		if(href_list["mob"]) //show the window
			var/mob/M = locate(href_list["mob"])
			var/dat = "<html><head><title>Job Ban</title></head><body>"
			dat += "<form action='byond://' method='get'>"
			dat += "<input type='hidden' name='src' value='\ref[src]'>"
			dat += "<input type='hidden' name='mob-ban' value='[href_list["mob"]]'>"
			dat += "Choose a job to toggle jobban status for: "
			dat += "<select name='job'>"
			for(var/datum/job/job in get_all_job_instances())
				dat += "<option value='\ref[job]'>[job.name]"
				if(jobban_isbanned(M, job))
					dat += " (jobbanned - [jobban_banreason(M, job)])"
				dat += "</option>"
			dat += "</select><br>"

			dat += "Reason for banning (please be specific)<br>"
			dat += "<textarea name='reason' rows=5></textarea><br>"
			dat += "<input type='submit' value='Submit'>"
			dat += "</form>"
			ss13_browse(usr, dat, "window=jobban")
		else if(href_list["mob-ban"])
			var/datum/job/job = locate(href_list["job"])
			var/mob/M = locate(href_list["mob-ban"])
			var/reason = href_list["reason"]
			// TODO: Make admins not able to jobban primary admins, and do that for all other powers too
			if(jobban_isbanned(M, job))
				world.log_admin("[usr.key] unbanned [M.key]/[M.spawn_name] from [job.name]")
				jobban_unban(M, job)
			else
				world.log_admin("[usr.key] banned [M.key]/[M.spawn_name] from [job.name] - [reason]")
				jobban_fullban(M, job, reason)


	get_desc(mob/M)
		return "<a href='?src=\ref[src];mob=\ref[M]'>Job ban</a>"

var
	jobban_keylist[0]		//to store the keys & jobs


//TODO: make this not suck

/proc/jobban_banreason(mob/M, datum/job/job)
	return jobban_keylist["[M.ckey] - [job.name]"]

/proc/jobban_fullban(mob/M, datum/job/job, reason)
	if (!M || !M.key || !M.client) return
	jobban_keylist["[M.ckey] - [job.name]"] = reason
	jobban_savebanfile()

/proc/jobban_isbanned(mob/M, datum/job/job)
	if("[M.ckey] - [job.name]" in jobban_keylist)
		return 1
	else
		return 0

/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_full.ban")
	S["keys[0]"] >> jobban_keylist
	world.log_admin("Loading jobbans")
	if (!length(jobban_keylist))
		jobban_keylist=list()
		world.log_admin("jobban list was empty")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["keys[0]"] << jobban_keylist

/proc/jobban_unban(mob/M, datum/job/job)
	jobban_keylist -= "[M.ckey] - [job.name]"
	jobban_savebanfile()