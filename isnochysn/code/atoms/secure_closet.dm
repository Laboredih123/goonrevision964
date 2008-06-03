/obj/secloset
	desc = "An immobile card-locked storage closet."
	name = "Security Locker"
	icon = 'stationobjs.dmi'
	icon_state = "1secloset0"
	density = 1
	var/opened = 0.0
	var/locked = 1.0
	var/allowed = null
	var/access = null
	var/broken = 0
	anchored = 1.0
/obj/secloset/animal
	name = "Animal Control"
/obj/secloset/highsec
	name = "Experimental Technology"
	allowed = "Captain/Head of Personnel/Head of Research"
/obj/secloset/captains
	name = "Captain's Closet"
	allowed = "Captain"
/obj/secloset/medical1
	name = "Medicine Closet"
	allowed = "Medical Researcher/Prison Doctor/Medical Doctor/Captain/Head of Research"
/obj/secloset/medical2
	name = "Anesthetic"
	allowed = "Medical Researcher/Prison Doctor/Medical Doctor/Captain/Head of Research"
/obj/secloset/personal
	desc = "The first card swiped gains control."
	name = "Personal Closet"
	icon_state = "0secloset0"
/obj/secloset/security1
	name = "Security Equipment"
	allowed = "Prison Security/Prison Warden/Security Officer/Captain/Head of Personnel/Head of Research"
/obj/secloset/security2
	name = "Forensics Locker"
	allowed = "Prison Security/Prison Warden/Forensic Technician/Security Officer/Captain/Head of Personnel/Head of Research"
/obj/secloset/toxin
	name = "Toxin Researcher Locker"
	allowed = "Toxin Researcher/Captain/Head of Research"
