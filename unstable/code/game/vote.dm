/datum/vote
	var/voting = 0 // true if currently voting
	var/nextvotetime // time at which next vote can be started
	var/timeleft = 600
	var/is_processing = 0
	var/list/votes = list()
	var/list/votetotals = list()
	var/aborted = 1
	var/desc = ""
	var/const
		VOTE_NO = "No"
		VOTE_YES = "Yes"

	New()
		nextvotetime = ss13time()

	proc/canvote()
		return (ss13time() >= nextvotetime)

	proc/nextwait()
		return timetext( round( (nextvotetime - ss13time())/10) )

	proc/endwait()
		return timetext( round(timeleft/10) )

	proc/timetext(var/interval)
		var/minutes = round(interval / 60)
		var/seconds = round(interval % 60)

		var/tmin = "[minutes>0?num2text(minutes)+" min":null]"
		var/tsec = "[seconds>0?num2text(seconds)+" sec":null]"

		if(tmin && tsec)				// hack to skip inter-space if either field is blank
			return "[tmin] [tsec]"
		else
			if(!tmin && !tsec)		// return '0sec' if 0 time left
				return "0 sec"
			return "[tmin][tsec]"

	proc/conclude()
		if(!voting) // means that voting was aborted by an admin
			return
		world << "\red <B>***Voting has closed.</B>"

		voting = 0
		nextvotetime = ss13time() + 10*config.vote_delay

		for(var/mob/M in world)	// clear vote window from all clients
			if(M.client)
				ss13_browse(M, null, "window=vote")
				M.client.showvote = 0

		apply()

	proc/apply()
		return

	proc/get_vote_text(client/C)
		return

	Topic(href, href_list)
		..()
		if(href_list["vote"] && src.voting)
			if(votes[usr.client]) // remove old vote
				votetotals[votes[usr.client]]--
			votes[usr.client] = href_list["vote"]
			votetotals[href_list["vote"]]++
			usr.vote()
		else if(href_list["startvote"])
			if(currentvote && currentvote.voting)
				return
			if(!src.canvote() && !(usr.client && usr.client.powers))
				return

			currentvote = src
			src.voting = 1
			src.timeleft = config.vote_period * 10
			aborted = 0
			spawn()
				src.process()

			votes = list()
			votetotals = list()

			world.log_vote("Voting to [src.desc] started by [usr.name]/[usr.key]")

			for(var/mob/M in world)
				M << "A vote to [src.desc] has been initiated by [usr.key]."
				M << "You have [src.timetext(config.vote_period)] to <a href='?src=\ref[M];vote=1'>vote.</a>"
				if(M.client)
					for(var/datum/admin_power/p in M.client.powers)
						if(istype(p, /datum/admin_power/abort_vote))
							M << "<a href='?src=\ref[p];refresh=0'>Abort Vote</a>"
							break

					if(!config.vote_no_default && !(config.vote_no_dead && M.is_dead) && M.client.authenticated)
						votes[M.client] = default_vote()
						votetotals[default_vote()]++

			usr.vote()

	proc/current_winners()
		var/best = -1
		var/winners = list()
		for(var/voted in votetotals)
			if(votetotals[voted] == best)
				winners += voted
			else if(votetotals[voted] > best)
				winners = list(voted)
				best = votetotals[voted]
		return winners

	proc/default_vote()
		return

	proc/process()
		if(is_processing)
			world.log_bug("Entered process() a second time in __FILE__ at __LINE__, uh oh")
			return
		is_processing = 1
		var/last_update = ss13time()
		while(1)
			if(aborted)
				is_processing = 0
				return
			if(timeleft <= 0)
				is_processing = 0
				conclude()
				return
			else
				var/curtime = ss13time()
				timeleft = max(timeleft + last_update - curtime, 0)
				last_update = curtime
			sleep(5)

/datum/vote/restart
	desc = "restart"

	get_vote_text(client/C)
		var/text = {"
			Vote to restart round in progress.<br>
			[src.endwait()] until voting is closed.<br><br>
			Restart the world?<br>
			<ul>"}
		for(var/option in list(VOTE_NO, VOTE_YES))
			if(votes[C] == option)
				text += "<li><b>[option]</b>"
			else
				text += "<li><a href='?src=\ref[src];voter=\ref[C];vote=[option]'>[option]</a>"
			if(votetotals[option])
				text += " ([votetotals[option]] vote\s)"
			text += "</li>"
		text += "</ul>"
		var/list/L = current_winners()
		if(L.len == 1)
			text += "<p>Current winner: <b>[L[1]]</b><br>"
		else
			text += "<p>Current winner: <b>No</b><br>"
		return text

	default_vote()
		return VOTE_NO

	apply()
		var/list/winners = current_winners()
		if(winners.len != 1)
			winners = list(VOTE_NO)
		var/winner = pick(winners)

		if(winner == VOTE_NO)
			world << "Result is: \red No restart."
		else
			world << "Result is: \red Restart."
			world <<"\red <B>World will reboot in 5 seconds</B>"
			sleep(50)
			world.log_game("Rebooting due to restart vote")
			world.Reboot()

/datum/vote/mode
	desc = "change mode"

	get_vote_text(client/C)
		var/text = {"
			Vote to change mode in progress.<br>
			[src.endwait()] until voting is closed.<br><br>
			Current game mode is: <b>[master_mode.long_name]</b>.
			Select the mode to change to:<br>
			<ul>"}
		for(var/datum/game_mode/option in get_mode_instances())
			if(votes[C] == option)
				text += "<li><b>[option.long_name]</b>"
			else
				text += "<li><a href='?src=\ref[src];voter=\ref[C];vote=\ref[option]'>[option.long_name]</a>"
			if(votetotals[option])
				text += " ([votetotals[option]] vote\s)"
			text += "</li>"
		text += "</ul>"

		var/list/L = current_winners()
		if(!L.len)
			text += "<p>Current winner: <b>No change</b></p>"
		else
			text += "<p>Current winner:<b>"
			if(L.len > 1)
				text += " Tie:"
			for(var/datum/game_mode/M in L)
				if(M != master_mode)
					text += " [M.long_name]"
				else
					text += " No change"
			text += "</b><br>"
		return text

	default_vote()
		return master_mode

	apply()
		var/list/winners = current_winners()
		if(!winners.len)
			winners = list(master_mode)
		var/datum/game_mode/winner = pick(winners)

		if(winner == master_mode)
			world << "Result is: \red No change."
		else
			world << "Result is change to \red [winner.long_name]"
			world.log_vote("Voting closed, changing mode to [winner.long_name]")
			master_mode = winner
			set_default_mode(winner)

	Topic(href, href_list)
		if(href_list["vote"] && src.voting)
			if(votes[usr.client]) // remove old vote
				votetotals[votes[usr.client]]--
			votes[usr.client] = locate(href_list["vote"])
			votetotals[locate(href_list["vote"])]++
			usr.vote()
		else
			return ..()

/mob/verb/vote()
	set name = "Vote"
	if(!usr.client.authenticated)
		usr << "You're not authenticated, you can't vote."
		return
	usr.client.showvote = 1

	var/text = "<HTML><HEAD><TITLE>Voting</TITLE></HEAD><BODY scroll=no>"
	var/footer = "<HR><A href='?src=\ref[src];vclose=1'>Close</A></BODY></HTML>"

	if(!(usr.client && usr.client.powers) && (config.vote_no_dead && usr.is_dead)) //admins can vote while dead
		text += "Voting while dead has been disallowed."
		text += footer
		ss13_browse(usr, text, "window=vote")
		usr.client.showvote = 0
		return

	if(currentvote && currentvote.voting)
		// vote in progress, do the current
		text += currentvote.get_vote_text(usr.client)
		text += footer
	else		//no vote in progress
		if(!(usr.client && usr.client.powers) && !config.allow_vote_restart && !config.allow_vote_mode)
			text += "<P>Player voting is disabled.</BODY></HTML>"
			ss13_browse(usr, text, "window=vote")
			usr.client.showvote = 0
			return
		var/list/L = list()
		L[restartvote] = config.allow_vote_restart
		L[modevote] = config.allow_vote_mode

		for(var/datum/vote/V in L)
			if(!L[V])
				continue
			if(!(usr.client && usr.client.powers) && !V.canvote()) // not time to vote yet
				text+="Voting to [V.desc] is enabled. Next vote can begin in [V.nextwait()].<br>"
			else
				text += "<a href='?src=\ref[V];startvote=1'>Begin [V.desc] vote.</a><br>"
		text += footer

	ss13_browse(usr, text, "window=vote;size=500x450")

	spawn(20)
		if(usr.client && usr.client.showvote)
			usr.vote()
		else
			ss13_browse(usr, null, "window=vote")

/mob/Topic(href, href_list)
	if(href_list["vclose"])
		ss13_browse(src, null, "window=vote")
		src.client.showvote = 0
	else
		return ..()