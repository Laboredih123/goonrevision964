var/changes = {"<FONT color='blue'>
<P><B>Current Version: Goon 0.5 Prerelase</b></p>
<P>This version is a testbed of proposed fixes, changes, and features.</p>
<HR>

<P><B>Modified Tuesday, June 24th 2008 (Revision 233):</b><BR>
<ul>
<li>Server crash where a non-player-human died has been resolved (ie: monkeys-turned-humans or logged-off-humans)</li>
<li>You can now observe your own corpse</li>
<li>Examining someone will now show what is on their belt and glove slots</li>
<li>You can now examine yourself</li>
<li>OOC and SAY verbs now have a character limit of 1024 (so you can type long sonnets)</li>
<li>Emptying Pockets before game start caused a server error; no longer the case</li>
<li>The FLOWRATE global constant has been changed to 0.99. This should speed up gaseous flow in pipes (and therefore make the engine run smoother) but may have big unforseen consequences. Keep eyes open for bugs.</li>
<li>Fixed engine z-level definition preventing it from ejecting</li>
<li>Access_Medical_Records permission has been set appropriately (nobody could do it before)</li>
<li>There are now 3 atmos techs and 3 station techs instead of 5 and 1</li>
<li>CO2 now does 50 damage per second, and it takes 5 seconds to knock you out (instead of just being an insta-kill)</li>
<li>Added beer to the game, complete with HARM and HURT effects (when clicking on both yourself and others). It'll need some tweaking in the damage-dishing department before it becomes a common fixture on maps (it's a bit too powerful right now)</li>
<li>Admins can now manually authorize pubbies to enter the game (and to make them monkeys)</li>
<li>The traitor's radio is now hidden inside a normal radio device, so that you cannot figure out who the traitor is just by looking at his inventory.</li>
<li>Camera view now allows you to read papers one square away (AI and security terminals)</li>
<li>Camera view can papers more than one square away in a garbled state (similar to monkey reading)</li>
<li>Camera view can not see papers in people's hands, however, people can now hold papers up to the cameras (by clicking on them) which pops up a window on the AI's screen</li>
<li>Camera views are now cancelled when the camera is cut (it used to stay on until you switched)</li>
<li>Level 3 Biohazard closets no longer come with gas masks, oxygen, gloves, or lab coats.</li>
<li>Medical closets no longer come with gloves.</li>
<li>Fixed a bug that affected intercept-sending in traitor mode.</li>
<li>Fixed a bug that threw errors server side when playing with your belt</li>
<li>New area type - "AI Monitored" - with accompanying new "Motion Detection" camera. This will throw a warning to the AI player if anybody enters (currently in use in EVA storage)</li>
<li>Motion cameras can be deactivated now (screwdriver for 10 seconds, then wriecutters)</li>
<li>The AI is now notified if Oxygen or FireAlarms are tripped.</li>
<li>Monkeyizing sometimes threw an exception error - now fixed.</li>
<li>Fixed bug that stopped DNA_ADD to work correctly (it tried to add the data to the other disk)</li>
<li>The radio is no longer lockable in Nuke mode</li>
<li>Access levels are no longer reset when giving a custom job (to make it easier to give yourself Captain access and rename it after)</li>
<li>Fixed the ADMINHELP verb for this fork</li>
<li>Fixed a bug where you would stop in space if you laid down</li>
<li>Head of Research now has security access (so he can leave the bridge)</li>
<li>Fixed a floating point error that made radios go to 148.2 instead of 148.1</li>
<li>Made the endgame explosion in blob mode do more damage (to compensate for the bigger map)</li>
<li>Fire alarms no longer go off in space</li>
<li>Re-added the ENTER Verb in case you have trouble spawning</li>
<li>VOTE_NO_DEAD is now defaulted to OFF</li>
<li>AI can no longer "Follow" people hiding in closets (or similarly hidden)</li>
<li>Meteor mode now has 10x the meteors</li>
<li>There are now 2 Engineering positions</li>
<li>Clicking on closets with grab activated threw errors; now fixed</li>
<li>All security and forensic officers now have security_records access</li>
<li>The AI 'wander-off-camera' delay is now 5 seconds instead of 30</li>
<li>You can now wirecut atmos alert panels</li>
<li>Fixed a bug with AI cameras</li>
<li>Chaplain job fixes</li>
<li>APCs now have customizable cell capacities in the mapmaker(this will break old map power grids but is an easy fix)</li>
<li>APCs now have 3 "power draw" attributes in the mapmaker that allows you to artificially pump up the rooms power consumption</li>
<li>Added the most recent map changes to the SVN.</li>
</ul>
</p>

<p><B>Modified Thursday, June 19th 2008 (Revision 172):</b><BR>
<ul>
<li>Airlock access bug fixed</li>
<li>Added chapel_office and tech_storage access levels</li>
<li>Added the Chaplain job title</li>
<li>Made the working skin the default skin</li>
<li>Fixed bug where clicking on the belt slot without an active item would cause an error</li>
<li>Added Beer to the game (icons/items only at this time, no effects)</li>
<li>Fixed bug where emags weren't working properly on doors</li>
<li>Made doors not openable before the round starts</li>
<li>emags now have a higher priority, so if you have access to a locker the emag will still fry it</li>
<li>Fixed windoor and airlock display where running into it multiple times would restart the animation</li>
<li>Secured closets are no longer anchorable (you can push them now)</li>
<li>Teleporter now reports the area name instead of X/Y/Z coordinates</li>
<li>Thrown objects are no longer dense (fixes issues with launching several items at once)</li>
<li>Moved engine Z-level definition to the main globals file for easier editing</li>
<li>Random meteor spawn rate lowered by 80%</li>
<li>Blob now hurts the AI computer</li>
<li>Teleporter now pulls the default /area name from the name variable (instead of just calling it 'unknown')</li>
<li>The nuke in Blob mode is now bigger</li>
<li>Fixed a bug that prevented security closets from verifying access levels</li>
<li>Walking through girders is no longer allowed; you still build them directly under you though so watch out which way you step off.</li>
<li>Hitting an AI computer with an item caused an exception error. It now behaves in a sane fashion (only checks for modules).</li>
<li>Communications intercepts now print in any location (previous patch made it only print in the 'bridge' area)</li>
<li>Communications computers now have a prints_intercept attribute which can be set to OFF in the map editor</li>
<li>The SWAT helmet no longer hides your face, and is now organized into a more logical class</li>
<li>Stun baton stun time is now 5-20 seconds (instead of 20-60 seconds)</li>
<li>Server code now using the Slurm.spacestation13 hub</li>
</ul>
</p>


<P><B>Modified Tuesday, June 17th 2008 (Revision 129):</b><BR>
<ul>
<li>Removed random name code for now as it delayed spawning and caused some problems</li>
<li>Fixed exception error with empty pill cannister</li>
<li>Fixed bug with sandbox that threw errors if you logged out or died with the sandbox panel open</li>
<li>Fixed bug in sandbox where non-admins could spawn</li>
<li>Fixed bug where readying didn't spawn you</li>
<li>Changed headset trigger from / to ; as / clears the chatbox when in chat mode</li>
<li>Added the Chaplain position</li>
<li>Made some new access levels</li>
</ul>
</p>

<HR>
<P><B>Modified Monday, June 16th 2008 (Revision 117):</b><BR>
<ul>
<li>You are now told what your job is and are offered to change your name, even if you aren't AI. This implementation is kind of kludgy and will be rolled into a new character sheet in the future.</li>
<li>Fixed the default state of req_access_txt to make things easier for mapmakers.</li>
<li>Fixed a bug with how req_access_txt was being read</li>
<li>Removed the "THROW" icon from the AI's HUD</li>
<li>Shuttle arrival and holding times have been cleaned up to make them easier to modify in the future.</li>
<li>Fixed bug that would prevent rounds from ending.</li>
<li>Meteors do more damage, but no longer blind/deafen/mute you.</li>
<li>Meteors can now fly in from all directions, not just the East.</li>
<li><B>ACCESS LEVEL REVAMP</b>. The old 4>2-2-0 security cards are gone and have been replaced with a permission-based system. That means you are given actual permissions such as
"Access security" or "access the bridge" or "eject engine core". All items (computers, doors, etc.) check your security card for the required permission to be set. As this changes how station
equipment works, it <B>breaks all previous maps</b>. There is a .txt in the root folder of the SVN detailing how to convert old maps. All appropriate security computers and interfaces have been
updated for ease of use. The added benefit of this update is that adding new and wild permissions is now VERY easy to implement, both on the map side and code side.</li>
<li>Asleep and unconscious people now hear muffled voices instead of clear text.</li>
<li>Fixed problems that occur when two people have the same name.</li>
<li>Turning off your internals now generates a refresh (it only worked when you turned them on before)</li>
<li>Timer-igniter combinations now ignite things other than bombs.</li>
<li>The Camera item has been removed from the forensics locker (it was broken and lagged out servers anyway)</li>
<li>Left clicking on the teleporter computer now brings up the command dialogue (instead of having to right-click)</li>
<li>The teleporter dialogue now lists only beacons, not all things with frequencies (and you can only lock onto beacons)</li>
<li>The AI can now operate the teleporter (with some difficulty, particularly locking onto things - camera must be in follow mode)</li>
<li>Left-clicking the teleportation hub now toggles it on and off.</li>
<li>The teleportation target now follows the becaon (instead of the first reported beacon location)</li>
<li>Turrets now hit people lying down.</li>
<li>Turrets now shoot you in random body parts, not just the chest (which fixes the turrets-never-kill-you bug)</li>
<li>Turrets now have a 3 second cooldown between shots so they don't spam you to death in the first second</li>
<li>RWalls now produce and consume the same amount of materials when building or dismantling. No more free metal, kids.</li>
<li>EMags now open (and break) secure closets. Added a new icon (by Judenhauer and weasello) that shows FANCY SPARK EFFECTS!</li>
<li>People wearing a face-obscuring mask and wearing no ID now show up as "unknown"</li>
<li>Gas masks no longer count as helmets (they used to shield from head damage)</li>
<li>The nuclear disk can now be observed, so dead/admin can follow it</li>
<li>The sandbox panel now requires authentication (pubbies were spawning toolboxes in the start area and beating each other)</li>
<li>The sandbox panel now appears even if you spawn in mid-round</li>
<li>The "enter" verb has been removed and it's functionality has been rolled into "ready" (you only have to type READY to spawn in now)</li>
<li>You now spawn into the game with all the equipment associated with your job assignment (toolbox in hand, clothes on, etc.)</li>
<li>You no longer start mid-round naked</li>
<li>Walls are now built directly under you, making your 'facing' direction no longer important. To make this happen, girders are now passable tiles (you can walk through them).</li>
<li>"Repair wall" is now gone, instead you use metal on the exposed girders.</li>
<li>Time to build and dismantle walls has been increased to compensate for the new ease of building them.</li>
<li>Traitors no longer get the "Hijack" verb (there was no legitimate use for it)</li>
<li>The "Eject Engine" objective no longer appears for the Traitor, and has been replaced with "Cut power to 80% of the station" (that figure can be easily adjusted in the code)</li>
<li>Added "Kill all monkeys on the station" traitor objective</li>
<li>Added "Destroy 70% of plasma containers on the station" traitor objective (value easily changed in code)</li>
<li>Added "Destroy AI" traitor objective</li>
<li>Fixed some traitor text to make more sense</li>
<li>The Intercept now only prints on the bridge (no longer in engineering or security)</li>
<li>The AI mission of "kill everyone" was actually coded as a percentage value. The mission now reflects the code (and defaults to 75% murder rate - which is higher than before)</li>
<li>Fixed the bug where it was impossible to steal a fully charged laser (since laser charges were reduced below the threshold)</li>
<li>Fixed issue where airlocks would attempt to close even if they were already closed.</li>
<li>Air tanks now start with a flow rate of 100 enabled (instead of 350), oxygen in the tank is now 25% of what it used to be, and jetpacks have half of THAT.</li>
<li>Tasers have 4 charges instead of 8.</li>
<li>Game Kit is now fixed (chessboard)</li>
<li>Stacking large piles is fixed (previously clicking a pile of 50 on another pile of 50 created one pile of 5 and another of 95. They now both stay at 50)</li>
<li><B>Radio communications methods have changed.</b> You would now use:<br>
say "/words words"<BR>
instead of:<br>
say "\[h]words words<BR>
All other commands, such as \[r], \[1], etc. have been replaced with :r and :1, etc.</li>
<li>Unauthenticated users can no longer vote.</li>
<li>There is now an indicator if the person you are observing is dead.</li>
<li>Rearranged the order of suffixes in the observe code.</li>
<li>Regular batons are now replaced with stun batons. They look cooler, do more damage, and stun people for 10-60 seconds with each hit. They can still talk while stunned.</li>
<li><B>The throwing system has been completely replaced</b>. Now you can click throw, then click on the square you want to try to throw to. Your facing direction no longer has any effect.</li>
<li>Throwing items no longer alters your direction of travel. If you slip into space, throwing your shoes will move you one square backwards but you will continue to float in the direction you slipped.</li>
<li>Mass drivers can now drive anything, and they can (With some trivial code changes) even drive diagonally.</li>
<li>Only spacesuits protect you from the vacuum of space. Firesuits and biohazard suits will now send you to the morgue.</li>
<li>Suicide verb fixed so you can use it in the spawn area (in case you want to observe), you can no longer suicide if you are dead (duh), and you can attempt suicide once every 20 seconds now (in case some jerk doctor is healing you or you are monkeyed back to life).</li>
<li>Attacking people at spawn should now be disabled. You might be able to hit people with ID cards but they do zero damage. Admin spawned weapons still hurt.</li>
<li>Personal lockers now have smarter stacking (headsets and backpacks on the top)</li>
<li>False walls now work properly whether you are holding a tool or not (it doesn't auto-open if you are holding a tool)</li>
<li>False wall display bug fixed</li>
<li>A lot of code cleaning was done, making things niiice and pretty.</li>
</ul>
</p>

<HR>
<B>Changes from base version 40.93.2</B></FONT><BR>
<HR>

<P><B>Gibbed's changes #6 (svn revision 64) 5/20/2008</b><BR>

<ul>
<li>Tasers now use charges for melee attacks and are increased to 4 charges instead of 3. </li>
<li>Admin help now has better formatting and requires you to be authenticated. </li>
<li>Optical Thermal/MESON scanners are now only optical thermal scanners. </li>
<li>Shuttle doors no longer using their verb to open close and work like normal doors. </li>
<li>Traitor selection messages are big and red!</li>
</ul></p>

<P><B>Gibbed's changes #5 5/19/2008</B><BR>

<ul>
<li>Authentication! Unauthenticated users cannot enter the game or use OOC. </li>
<li>Stuttering now happens before HTML encoding, meaning no more excessive &&&qqqquuuooot;;;;. </li>
<li>Health analyzer now shows offline status. </li>
<li>New command adminhelp which allows you to broadcast messages to only admins. </li>
<li>Several patches by Kurper: APC bug fix, fingerprints on door controls, observe patch, staff assistant rank fix. </li>
<li>Suicide command, thanks to Kurper.</li>
</ul>
</p>

<p><b>Gibbed's changes #4 - TEST VERSION #7 4/27/2008</b><br>
<ul>
<li>Added inner cameras to the AI satellite.</li>
<li>Added APC to the external turret area of the AI satellite.</li>
<li>Added turret controls to the external turret area of the AI satellite.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #6 4/27/2008</b><br>
<ul>
<li>Updated graphic for the floor in the chapel.</li>
<li>Fixed several APCs that were not properly hooked up to power systems.</li>
<li>Fixed the north solar array so that the battery could not feed power from the main system.</li>
<li>Fixed the APCs for north and south solar array.</li>
<li>Moved the AI Upload Foyer onto its own power network using its own solar array.</li>
<li>Widened the south hallway.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #5 4/27/2008</b><br>
<ul>
<li>New graphic for the floor in the chapel thanks to NuclearMailman.</li>
<li>Redid escape pod and recon pod code so that they share code.</li>
<li>Escape pods can no longer rotate, except the one in the pod repair bay.</li>
<li>Syndicate station now has recon pods instead of escape pods.</li>
<li>Syndicate station now has syndicate personal lockers instead of everything being on the ground.</li>
<li>Syndicate station now starts with some breach bombs during nuclear mode.</li>
<li>Instead of standard blank id cards, syndicate personal lockers spawn syndicate cards which block AI tracking.</li>
<li>Fixed up the handling of warping between maps, this means you should no longer end up fucked from traveling too far to the west.</li>
<li>Fixed an issue with the double airlocks unwelding a welded airlock when the other opens.</li>
<li>AI's Track With Camera and Observe should now properly handle duplicate names and names with invalid characters in them.</li>
<li>Nuked all verb admin commands except for variables and show_ctf.</li>
<li>Administrator panel is now enabled for the host of a game (instead of those stupid fucking verbs).</li>
<li>Added Who command.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #4 4/27/2008</b><br>
<ul>
<li>Fixed exploit with rechargers charging tasers to 10 charges.</li>
<li>Added hologram generators that the AI can control to a few places around the station.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #3 4/27/2008</b><br>
<ul>
<li>AI's #2 radio microphone now defaults to being on.</li>
<li>Fixed an issue where the captain could be assigned to another job.</li>
<li>The airlocks for the shuttle bay and shuttle docking arm are no longer infinitely powered.</li>
<li>Fixed the nuke deployable verb not showing up.</li>
<li>For most double airlocks, opening one will cause the other to close automatically before opening (if it can).</li>
<li>New coffin graphic thanks to NuclearMailman</li>
<li>Small changes to closet code so it properly handles opened/closed graphics.</li>
<li>Fixed the pod repair bay not allowing the pod in it to move.</li>
<li>Reduced Athmospheric Technician to 2 slots (was 4).</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #2 4/26/2008</b><br>
<ul>
<li>Went through and all exterior floor tiles so they start out with no oxygen, these can be identified by the fact that their name starts with 'airless'. If you spot any exterior floor tiles that are not airless by default please let me know so I can fix it.</li>
<li>APCs can now be cut with wirecutters (only while open!) to disable AI control of the APC. I plan to add a hack type deal (like airlock doors) into them later.</li>
<li>Fixed the chapel pod door controls (oops).</li>
<li>Blob mode: removed some blob spawn points that might cause it to die pretty much instantly.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #1 4/25/2008</b><br>
<ul>
<li>Anesthetic tanks now default to a rate of 250.</li>
<li>Blob mode: blob in a tile with plasma is inhibited from propogating to surrounding tiles.</li>
<li>Oxygen tank capacity has been reduced (roughly halved). Too much? let me know!</li>
<li>Removed insulated gloves from athmospherics and added a glove to engine control.</li>
<li>Taser charges reduced to 3.</li>
<li>The map size has been expanded to 140x140 (was 100x100).</li>
<li>The many engine areas have been moved around and reorganized.</li>
<li>The airlock between medbay and engine has been broken up into two airlocks that have some distance between them. This means to get to the engine from the medbay you now have to spacewalk.</li>
<li>The teleporter room has been moved to the south part of the station.</li>
<li>Small aesthetical changes to the medbay and medlab.</li>
<li>Redid chapel entrance.</li>
<li>Northeast solar panel array has been redone. Note that it is damaged by default and will need to be repaired to be usable.</li>
<li>Northeast solar panel control room has been redone.</li>
<li>Auxillary engine has been moved to north of the northeast solar panel control room.</li>
</ul>

<p><b>Gibbed's changes #3 4/24/2008</b>
<ul>
<li>Blob mode: when you are dead you no longer receive the 'The blob attacks you!' message.</li>
<li>Blob mode: blob should no longer expand to air tunnel / shuttle tiles.</li>
<li>Blob mode: blob should no longer propogate into space.</li>
<li>New toxin researcher locker.</li>
<li>Default anesthetic mix changed.</li>
<li>Added a security camera to the Toxin Research Lab Test Room.</li>
</ul>

<p><b>Gibbed's changes #2 4/24/2008</b>
<ul>
<li>Syndicate radio will now spawn in the users backpack if they started with one.</li>
<li>Syndicate radio will now self-destruct in 10 seconds rather than 3.</li>
<li>New traitor objective: eject engine.</li>
<li>Added OxygenIsToxicToHumans AI module, it can be obtained through a syndicate radio.</li>
<li>Decreased size of morgue and increased size of coffin storage.</li>
<li>Changed some engine walls to rwall and lined the interior of the engine with glass.</li>
<li>Fixed a small harmless bug with job picking code that was preventing selection of assistant jobs.</li>
</ul>

<p><b>Gibbed's changes #1 4/24/2008</b>
<ul>
<li>Prison (and prison jobs) removed.</li>
<li>Athmospheric Technician job slots increased to 4 (was 1).</li>
<li>'Super battery cell' used for AI Upload foyer energy decreased to 2500 (was 5000).</li>
<li>Command Station has been reduced to a Supply Station.</li>
<li>AI Station has been redone.</li>
<li>AI Upload area in Space Station 13 has been redone.</li>
<li>Job picking code for game starting rewritten, should stop crashouts that prevent people from spawning properly.</li>
<li>Removed blob debug messages (this might make blob playable).</li>
<li>AI can now hop to other cameras by clicking them.</li>
<li>Camera lists (for AI, security console) now get sorted.</li>
<li>Getting spaced on new game should no longer happen.</li>
<li>Main solar panel array for Space Station 13 was redone.</li>
<li>Minor tweaks to teleporter room.</li>
<li>Fixed issue where if you are naked when the game starts you don't get your ID.</li>
<li>Character setup no longer opens by default if you have saved data.</li>
</ul>"}
