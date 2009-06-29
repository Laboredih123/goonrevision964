/datum/configuration/var
	allow_vote_restart = 0 			// allow votes to restart
	allow_vote_mode = 0				// allow votes to change mode
	vote_delay = 600				// minimum time between voting sessions (seconds, 10 minute default)
	vote_period = 60				// length of voting period (seconds, default 1 minute)
	vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	vote_no_dead = 0				// dead people can't vote (tbi)
	enable_authentication = 0		// three-stage authentication (required,disabled,optional)

	list/probabilities = list()		// relative probability of each mode
	allow_ai = 1					// allow ai job
	hostedby = null
	respawn = 1

	rate_limit = 1					// restricts command rate to 1 command / second

	log_file // logfile name

	datum/game_mode/master_mode = null
	datum/game_mode/current_mode = null
