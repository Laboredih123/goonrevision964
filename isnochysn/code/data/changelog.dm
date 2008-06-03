var/changes = {"<FONT color='blue'><B>Changes from base version 40.93.2</B></FONT><BR>
<HR>

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