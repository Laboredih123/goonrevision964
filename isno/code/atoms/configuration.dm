/datum/configuration
	var/allow_vote_restart = 0 			// allow votes to restart
	var/allow_vote_mode = 0				// allow votes to change mode
	var/vote_delay = 600				// minimum time between voting sessions (seconds, 10 minute default)
	var/vote_period = 60				// length of voting period (seconds, default 1 minute)
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	var/enable_authentication = 0		// three-stage authentication (required,disabled,optional)

	var/list/probabilities = list()		// relative probability of each mode
	var/allow_ai = 1					// allow ai job
	var/hostedby = null
	var/respawn = 1

	var/random_ai_names = 1				// enables random AI name suggestion
	var/random_names = 0				// enables random player name suggestion
	var/rate_limit = 1					// restricts command rate to 1 command / second

	var/log_file // logfile name
	var/log_file_admin
	var/log_file_attack
	var/log_file_game
	var/log_file_bug
	var/log_file_vote
	var/log_file_access
	var/log_file_say
	var/log_file_ooc
	var/log_file_construct