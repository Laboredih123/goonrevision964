/obj/closet/secure
	desc = "An immobile card-locked storage closet."
	name = "Security Locker"
	icon = 'stationobjs.dmi'
	icon_state = "1secloset0"
	density = 1
	var/locked = 1.0
	var/broken = 0
/obj/closet/secure/animal
	name = "Animal Control"
	req_access = list(access_medical_supplies)
/obj/closet/secure/highsec
	name = "Experimental Technology"
	req_access = list(access_heads)
/obj/closet/secure/captains
	name = "Captain's Closet"
	req_access = list(access_captain)
/obj/closet/secure/medical1
	name = "Medicine Closet"
	req_access = list(access_medical_supplies)
/obj/closet/secure/medical2
	name = "Anesthetic"
	req_access = list(access_medical_supplies)
/obj/closet/secure/personal
	desc = "The first card swiped gains control."
	name = "Personal Closet"
	icon_state = "0secloset0"
/obj/closet/secure/security1
	name = "Security Equipment"
	req_access = list(access_security_lockers)
/obj/closet/secure/security2
	name = "Forensics Locker"
	req_access = list(access_forensics_lockers)
/obj/closet/secure/toxin
	name = "Toxin Researcher Locker"
	req_access = list(access_tox_storage)