/datum/admin_power/abort_vote
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		return

	Topic(href, href_list)
		if(vote.voting)
			world << "\red <B>***Voting aborted by [usr.key].</B>"
			world.log_admin("Voting aborted by [usr.key]")

			vote.voting = 0
			vote.nextvotetime = ss13time() + 10*config.vote_delay

			for(var/mob/M in world)		// clear vote window from all clients
				if(M.client)
					ss13_browse(M, null, "window=vote")
					M.client.showvote = 0
		if(href_list["refresh"] == "0")
			return
		return ..()

	get_desc()
		if(vote.voting)
			return "<a href='?src=\ref[src]'>Abort vote</a>"
		else
			return null
