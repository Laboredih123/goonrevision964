/datum/admin_power/abort_vote
	panel_type = PANEL_TYPE_GAME
	allowed_for = ADMIN_GM

	Topic(href, href_list)
		if(currentvote && currentvote.voting)
			world << "\red <B>***Voting aborted by [usr.key].</B>"
			world.log_admin("Voting aborted by [usr.key]")

			currentvote.voting = 0
			currentvote.nextvotetime = ss13time() + 10 * config.vote_delay
			currentvote.aborted = 1

			for(var/mob/M in world)		// clear vote window from all clients
				if(M.client)
					ss13_browse(M, null, "window=vote")
					M.client.showvote = 0

			currentvote = null
		if(href_list["refresh"] == "0")
			return
		return ..()

	get_desc()
		if(currentvote && currentvote.voting)
			return "<a href='?src=\ref[src]'>Abort vote</a>"
		else
			return null
