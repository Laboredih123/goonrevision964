var/changes = {"<FONT color='blue'><B>Changes</B></FONT><BR>
<HR>

<p><b>Welcome to the Goon edition of SS13. As best I can tell this is the complete changelog since forking from the original codebase.</b></p>

<P><B>Thursday, July 24th, 2008: Revisions</b></p>

<ul>
<li><B>471</b> - <em>Bug</em>: You can no longer throw things through dense items (such as canisters)</li>
<li><B>470</b> - <em>Feature</em>: Authorized-people-MOTD now included, plus fixed up some issues with other MOTD files.</li>
<li><B>469</b> - <em>Change</em>: Character setup is now done on the client level instead of the mob level, fixing some issues and improving consistency.</li>
<li><B>468</b> - <em>Change</em>: Teleporters now have a 5% chance of sending you to deep space, hand teleporters have a 10% chance. No more telefragging, blue light zone, or wrong areas.</li>
<li><B>465</b> - <em>Feature</em>: You can now do character setup during rounds.</li>
<li><B>464</b> - <em>Feature</em>: Wirebundles now contain 24 wires; wire code is now more generalized so it works with pretty much anything that sends r_signal (such as timer/radio/prox/infra); adds a lot of opportunity to extendability of the game.</li>
<li><B>463</b> - <em>Feature</em>: Admin-only chat (via adminsay command)</li>
<li><B>462</b> - <em>Feature</em>: Pipe filters! Adds color-coded overlays to the pipe filter; now requires atmospherics ID to tamper with; can now close the filter (stops gas flow). Fixes bug where filters would no longer function if the lights went out.</li>
<li><B>459</b> - <em>Feature</em>: AI can now click anywhere on the screen and move to the closest camera to the clicked spot. This makes playing the AI one hundred thousand times easier (as calculated by Kurper in playtesting)</li>
<li><B>458</b> - <em>Feature</em>: AI can now use arrow keys to move to the nearest camera N/E/S/W of current location. Due to camera layout this will not necessarily allow you to travel to every camera on the map.</li>
<li><B>457</b> - <em>Change</em>: Speeding up the game by: adding a room equilibrium value so gasses aren't called every tick; updating gas code; making misc. minor optimizations. Pipes under the floor no longer do heat exchange with the gasses above; buggy unburnable floors fixed.</li>
<li><B>456</b> - <em>Change</em>: Old CO2 behaviour restored; will not perma-knock-you-out unless there's a LOT of CO2 in the area.</li>
</ul>

<P><B>Saturday, July 20th, 2008: Revisions</b></p>

<ul>
<li><B>455</b> - <em>Bug</em>: Fixed an error where you'd breath negative amounts of CO2</li>
<li><B>453</b> - <em>Change</em>: Some small changes made to the UpdateGasses and pipe code</li>
<li><B>452</b> - <em>Bug</em>: Fixed up the ID computer and access levels, which seemed to have been bummed in previous updates</li>
<li><B>450</b> - <em>Change</em>: Updated a lot of Gas code to conform to new standards and not be stupid, etc.</li>
<li><B>449</b> - <em>Bug</em>: Unlit welders used to open firedoors and regular doors required power. Both these issues fixed.</li>
<li><B>448</b> - <em>Bug</em>: Unlit welders could disassemble RWalls. Fixed.</li>
<li><B>447</b> - <em>Bug</em>: Creating or destroying walls no longer alters the gas levels on the square (it used to generate gas which would make it suddenly windy, especially near space)</li>
<li><B>446</b> - <em>Bug</em>: Fixed exploit where you could trigger the fire alarms rapidly in succession to make odd situations with firedoors.</li>
<li><B>445</b> - <em>Bug</em>: When examined, connectors now properly show the "desc" field (from mapmaker)</li>
<li><B>444</b> - <em>Bug</em>: Fixed improper ordering of cameras - should now be alphabetical.</li>
<li><B>442</b> - <em>Change</em>: Fingerprints are now randomly assigned (instead of a code being based off your name), and fingerprint scanners have been fixed. There are only 65,536 possible prints now, which means there may be the odd one or two sets of people with identical fingerprints.</li>
<li><B>441</b> - <em>Bug</em>: The cloaking device overlay bug has been fixed.</li>
<li><B>439</b> - <em>Change</em>: Walking into a blue light now randomly teleports you to the Lost in Space area.</li>
<li><B>436</b> - <em>Change</em>: "I want to be syndicate" is now on by default.</li>
<li><B>435</b> - <em>Change</em>: Sparks can no longer teleport.</li>
<li><B>433</b> - <em>Change</em>: Created new pipe icons.</li>
<li><B>432</b> - <em>Change</em>: Allowing AI to play is now on by default; config file option added to disable it.</li>
<li><B>429</b> - <em>Bug</em>: Fixed playercount reporting bug; removed obscenities from remote commands</li>
<li><B>428</b> - <em>Feature</em>: When cutting the ID scan wire, now allows anyone to access airlocks. Removed power assist and raising bolts. Open door wire added; if pulsed will toggle the door state, if cut door will not function. Remote signalling devices can be attached to airlock wires; when receiving a signal they will pulse the wire.</li>
<li><B>427</b> - <em>Feature</em>: Inventory swapping is now easier - clicking on your ID tag will switch it with the one in your hand for example.</li>
<li><B>426</b> - <em>Change</em>: Shuttle now pushes people away when warping in, so you cannot stand under the shuttle and be "inside" automatically.</li>
<li><B>425</b> - <em>Bug</em>: Fixed bug where doors would flicker when clicked on.</li>
<li><B>424</b> - <em>Bug</em>: Players no longer spawn on the same square (and instead cycle through the available squares as designated on the mapmaker)</li>
<li><B>422</b> - <em>Change</em>: Dead turrets no longer obstruct movement.</li>
<li><B>421</b> - <em>Bug</em>: Medical records now work properly.</li>
<li><B>420</b> - <em>Change</em>: Teleporters can now teleport you into places such as closets (if the random accuracy gets you onto the right square anyway)</li>
<li><B>419</b> - <em>Bug</em>: Properly shuffling occupations now so you don't always get station engineers before researchers (as an example).</li>
<li><B>416</b> - <em>Change</em>: Job assignment has been revamped. Captain, AI, HoP, HoR, Station Engineer, and Doctor are now all 'required' positions (if there are enough players). Also better parses your second and third choices to be more fair.</li>
<li><B>415</b> - <em>Change</em>: Monkeys now have gender flags. Settle down, boys.</li>
<li><B>414</b> - <em>Change</em>: The Comm Console now uses a proper left-click menu instead of the old right-click.</li>
<li><B>413</b> - <em>Feature</em>: It is now marginally easier to tell if you are dragging something.</li>
<li><B>412</b> - <em>Change</em>: Light switches and APCs now self-illuminate so that the AI can turn them off and on in the dark.</li>
<li><B>411</b> - <em>Change</em>: Solar panels are no longer invincible, making them less useful in Meteor mode.</li>
<li><B>410</b> - <em>Change</em>: Changing access levels for Station Engineer and Atmos Tech slightly.</li>
<li><B>409</b> - <em>Change</em>: Using wirecutters on electrified grills will now cut them AND shock you (instead of just shocking you)</li>
<li><B>408</b> - <em>Change</em>: Non-hand-teleporters no longer go to the blue-light-zone; sparks now originate from the landing point (instead of the intended landing point), and beacons are now pick-up-able.</li>
<li><B>406</b> - <em>Change</em>: Secure Area signs are now decorative and walk-through-able(they are not invincible walls)</li>
<li><B>404</b> - <em>Feature</em>: Difference function added to the DNA computer</li>
<li><B>399</b> - <em>Bug</em>: Fixed a bug where people had "switch language" set</li>
<li><B>397</b> - <em>Bug</em>: When your DNA changes you now drop any items you couldn't hold (ie: changed to monkey)</li>
<li><B>396</b> - <em>Change</em>: Renamed everything "medlab" to "Genetics Research"</li>
<li><B>393</b> - <em>Change</em>: The game client now starts in "chat" mode.</li>
<li><B>391</b> - <em>Feature</em>: Disconnected players' bodies now randomly wander and emote (and fixed some emote bugs)</li>
<li><B>389</b> - <em>Bug</em>: Anyone could open APCs with the new security system. Fixed.</li>
<li><B>388</b> - <em>Change</em>: Removed naming the traitor in the intercept.</li>
<li><B>387</b> - <em>Bug</em>: Fixed closet behaviour - clicking should no longer place items on top of a closet and it should behave properly when trying to open/close it.</li>
<li><B>386</b> - <em>Bug</em>: Fixed glitch where the welding tool reduced the amount of fire in a tile.</li>
<li><B>385</b> - <em>Change</em>: Chairs and beds can no longer enter closets; you can now bind people to beds; fixed some metal stacking bugs</li>
<li><B>384</b> - <em>Bug</em>: Laying down people can no longer move.</li>
<li><B>383</b> - <em>Bug</em>: Laying down people no longer get standy-up clothes.</li>
<li><B>381</b> - <em>Bug</em>: Fixes issue with handcuffs</li>
<li><B>379</b> - <em>Bug</em>: Fixes display issue with items on your belt</li>
<li><B>378</b> - <em>Feature</em>: Adding pipe pumps to the game.</li>
<li><B>377</b> - <em>Bug</em>: Monkey mode should now work.</li>
<li><B>376</b> - <em>Bug</em>: Fixed bug where people couldn't stand up.</li>
<li><B>375</b> - <em>Bug</em>: Fixed bug where headset was not displaying properly.</li>
<li><B>374</b> - <em>Bug</em>: Fixed bug preventing Medical Analyzer to not display properly.</li>
<li><B>373</b> - <em>Feature</em>: Once you take 500 damage, you become 'unknown,' making body identification difficult.</li>
<li><B>372</b> - <em>Bug</em>: If you had no name you couldn't change it. Fixed.</li>
<li><B>371</b> - <em>Change</em>: Handcuffed people can no longer BANG BANG BANG.</li>
<li><B>370</b> - <em>Change</em>: Closet Changes! People in closets can now hear and be heard; can't transmit/receive on the radio</li>
<li><B>369</b> - <em>Change</em>: Eyedroppers no longer work if you are wearing eye protection.</li>
<li><B>368</b> - <em>Change</em>: Default intent is now DISARM instead of HARM.</li>
<li><B>367</b> - <em>Bug</em>: Fixed show_inv (the inventory menu that appears when you drag and drop people onto you)</li>
<li><B>366</b> - <em>Feature</em>: Added dismemberment at extreme damages (and removed it in update 407 as it caused too much lag - but is in development)</li>
<li><B>365</b> - <em>Feature</em>: Analyzers now work on atmospheric equipment; 3-way-pipe filter introduced for fancy plumbing.</li>
<li><B>360</b> - <em>Change</em>: Only altering apperance-related genes changes your name now. Removed random mutations on startup.</li>
<li><B>358</b> - <em>Change</em>: Removing "You hear a faint noise..." patch from way earlier.</li>
<li><B>356</b> - <em>Change</em>: Updated intercom frequencies</li>
<li><B>355</b> - <em>Feature</em>: Doctors now start with Dr. in front of their name.</li>
<li><B>354</b> - <em>Feature</em>: Lit welders will now ignite plasma that enters the same tile.</li>
<li><B>353</b> - <em>Bug</em>: Fixed bug where sometimes you could not pickup items in diagonal directions from you.</li>
<li><B>352</b> - <em>Bug</em>: Unconscious people can no longer throw.</li>
<li><B>351</b> - <em>Bug</em>: Fixed an issue introduced that prevented AI from watching cameras.</li>
<li><B>350</b> - <em>Feature</em>: Windoors now work in all directions!</li>
<li><B>349</b> - <em>Feature</em>: Added "lost in space," a blank Z-level you cannot escape (except via teleport). Also fixed meteor mode so they now come from the West.</li>
</ul>

<P><B>Tuesday, July 8th 2008: Revisions</b></P>

<ul>
<li><B>345</b> - <em>Change</em>: Updated code conventions file</li>
<li><B>344</b> - <em>Change</em>: Replaced many airlocks on the map with windoors, removed some RWalls from the Western storage area</li>
<li><B>343</b> - <em>Change</em>: Updated SVN to latest map design, removed heavy armour and black firesuit</li>
<li><B>342</b> - <em>Change</em>: Added an /area directory and populated it with files</li>
<li><B>242</b> - <em>Bug fix</em>: Fixes an exception error caused when cameras cease to exist</li>
</ul>

<p><B>Monday, July 7th 2008: Revisions</b><BR><BR>

Hooray, merges. The Unstable fork is now (Barely) playable and all the changes since Revision 107 are slowly being incorporated in, catching all the patches up and porting old broken changes to the new system so they all work. Changelog will show some duplicate entries, but that is porting some of the broken fixes/changes to the new codebase. There is a chance some things have been missed (or intentionally left out).<BR><BR>

Because so many changes have been made I organized all the revisions into Feature, Change, and Bug fix piles, but will go back to random jumble after this update.</p>

<ul>
<li><B>329</b> - <em>Feature</em>: Added a maximum-message-length variable to let servers control how long single messages can be in the chatbox. It enforces both speaking and hearing limits.</li>
<li><b>301</b> - <em>Feature</em>: Added beer bottles. They respond differently depending on if you have HARM or HELP set, and if you click on yourself or others. They currently do way too much damage so they will have to be tweaked for gameplay.</li>
<li><b>294</b> - <em>Feature</em>: Dead observers can now see everything, instead of having their sight restricted as those they are observing would.</li>
<li><b>292</b> - <em>Feature</em>: Adding "Hosted by" and "respawn default off" to configuration options</li>
<li><b>290</b> - <em>Feature</em>: Examining tanks (including bombs) will now show their temperature.</li>
<li><b>285</b> - <em>Feature</em>: Added a "show_genes" verb to help with debugging</li>
<li><b>282</b> - <em>Feature</em>: Added language genes, removed some useless items from maps, bunch of other small fixes</li>
<li><b>281</b> - <em>Feature</em>: Added infectious genes; now monkey mode should work</li>
<li><b>278</b> - <em>Feature</em>: Added Quivering Mass, Fire Immunity, Super Strength, Telepathy, and X-Ray Vision genes. The DNA Computer can now produce gamma radiation.</li>
<li><b>277</b> - <em>Feature</em>: Added gender gene, added splicing to the DNA computer, and fixed mob rendering</li>
<li><b>276</b> - <em>Feature</em>: You can now View DNA from the DNA Computer</li>
<li><b>274</b> - <em>Feature</em>: The DNA computer now has basic functionality; you can exchange DNA with someone/thing (such as monkeys)</li>
<li><b>273</b> - <em>Feature</em>: Adding deafness and blindness back into the game (removed with previous code changes); added skin color gene; few other small changes</li>
<li><b>269</b> - <em>Feature</em>: New "Willing to play as Syndicate" checkbox in character setup. This is scanned for both Traitor mode and Nuke mode. Overrides if nobody (or too few) people select it.</li>
<li><b>264</b> - <em>Feature</em>: New Chaplain job and associated access rights</li>
<li><b>263</b> - <em>Feature</em>: APCs now have an attribute (in map maker) to artificially draw power, to pump up power consumption in specific rooms.</li>
<li><b>261</b> - <em>Feature</em>: New digital valve object - an AI controllable variant that requires power to switch (but not operate) with associated icons</li>
<li><b>256</b> - <em>Feature</em>: Genes have a new design implementation, and have pre_apply and apply procs to allow for more flexibility in gene design (such as multiple unique but interconnecting genes, such as baldness being seperate from hairstyle)</li>
<li><b>245</b> - <em>Feature</em>: Added Super Strength gene</li>
<li><B>227</B> - <em>Feature</em>: Disabling atmospheric alert panels (with wirecutters) and motion-sensing cameras (wirecutters and screwdriver) is now possible.</li>
<li><B>216</b> - <em>Feature</em>: The AI is no longer able to track people hidden in closets (or otherwise sealed up).</li>
<li><B>198</b> - <em>Feature</em>: The radio is no longer lockable in Nuclear Emergency mode, and fixed some compilation errors from the previous patch.</li>
<li><B>195</b> - <em>Feature</em>: The AI is now alerted when somebody enters motion-detectored rooms, or if anybody sets off an Oxygen or Fire Alarm.</li>
<li><B>189</b> - <em>Feature</em>: Bunch of AI features/changes - cameras currently being viewed now close when cut; Camera users can now read papers on flors or tables up to one square away. Cannot read papers in players hands. Using a piece of paper on a camera will popup the text on the camera user's screen.</li>
<li><B>188</b> - <em>Feature</em>: The traitor radio is now hidden inside your normal radio device (headset, belt radio, whatever you happen to spawn with) and instructions go to your memory on how to use it. Also fixes some bugs introduced in previous patches.</li>
<li><B>187</b> - <em>Feature</em>: Administrators can now manualy authorize users (pubbies or those having issues authenticating). Also changes the player listing to be a more readable table-based format.</li>
<li><B>178</b> - <em>Feature</em>: Examining someone now tells you what is in their hands and on their belts.</li>
<li><B>167</b> - <em>Feature</em>: Communications Computers now have a "prints intercept" attribute the mapmaker can set. It defaults to true (so will not break old maps), but allows for the mapmaker to restrict where the intercept prints in traitor mode.</li>

<li><B>314</b> - <em>Change</em>: Changing default chat message length to 1024 characters.</li>
<li><b>303</b> - <em>Change</em>: Secured closets are no longer anchored to the ground.</li>
<li><b>297</b> - <em>Change</em>: Updated the code conventions document</li>
<li><b>295</b> - <em>Change</em>: Removed CTF mode</li>
<li><b>291</b> - <em>Change</em>: Custom job selection no longer resets access levels (so you can more easily make a "Janitor" card with Captain access levels)</li>
<li><b>288</b> - <em>Change</em>: Engineer and Station tech jobs rolled into one single job (with some nerfing so they don't have uber-access), and all the Assistant jobs merged into one, slightly better access job (so the job doesn't suck so much)</li>
<li><b>284</b> - <em>Change</em>: Removed "randomize_dna" command, fixed biting with super strength, some changes made to the code conventions document.</li>
<li><b>280</b> - <em>Change</em>: Monkeys now start with randomized cosmetic genes (So they don't all have the same hair and skin color)</li>
<li><b>270</b> - <em>Change</em>: New atmospherics access level</li>
<li><b>265</b> - <em>Change</em>: areas.dmi and levels.txt files moved to new locations</li>
<li><b>259</b> - <em>Change</em>: Added is_ai_interactable variable in /atom to simplify code in tons of other places</li>
<li><b>255</b> - <em>Change</em>: Removed megamonkey from the code, did some reorganization and optimizations</li>
<li><B>226</b> - <em>Change</em>: The AI's "wandered off camera" delay is now 5 seconds rather than 30.</li>
<li><B>215</b> - <em>Change</em>: The dead-people-can-vote option is now off by default.</li>
<li><B>205</b> - <em>Change</em>: Gave Head of Research security access so they are able to leave the bridge. Made some other minor security level clearance changes. The security clearance rights should be overhauled sometime.</li>
<li><B>191</b> - <em>Change</em>: Level 3 Biohazard closets no longer come with gas masks, oxygen, gloves, or lab coats. Also removed gloves from medical closets.</li>
<li><B>183</b> - <em>Change</em>: Adding in the Medical Records Access permission and granting it to those that need it.</li>
<li><B>181</b> - <em>Change</em>: Pipe FlowRate changed to 0.99. This may or may not have unforseen consequences, but seems to be doing a good job at keeping the engine running efficiently. Also setting the engine Z level to 2, and moving the variable to a more easily acccessible location.</li>
<li><B>168</b> - <em>Change</em>: The SWAT Helmet now hides your face, and moves it to be a subclass of the standard helmet (will break the object if your maps have them)</li>
<li><b>163</b> - <em>Change</em>: Girders are no longer walk-through-able. You still build them right underneath you when constructing walls, so be careful which way you move.</li>
<li><b>160</b> - <em>Change</em>: Makes the nuke in blob mode much bigger now that the map is larger.</li>
<li><b>157</b> - <em>Change</em>: Lowered meteor spawn rate by 80% (for all game modes).</li>
<li><b>156</b> - <em>Change</em>: Updated engine and shuttle Z Levels for new map design, and moved the #defines into setup.dm with all the other #defines.</li>
<li><b>145</b> - <em>Change</em>: Teleporter now reports area name instead of X Y Z coordinates.</li>

<li><B>338</B> - <em>Bug fix</em>: Exception error generated when cameras cease to exist.</li>
<li><B>337</B> - <em>Bug fix</em>: Fixed typo in Airlock code</li>
<li><b>???</b> - <em>Bug fix</em>: When building girders, the tile now starts with much less air by default. This has not been tested but should make you less likely to be blown out into space when building walls near it.</li>
<li><b>296</b> - <em>Bug fix</em>: Fixed a bug that occurs when you die or logout with the sandbox panel. Also cleaned up some sandbox panel code.</li>
<li><b>293</b> - <em>Bug fix</em>: People's names no longer show up as "unknown" when holding their ID card in their hand.</li>
<li><b>289</b> - <em>Bug fix</em>: Syringes didn't output a message in certain situations upon use.</li>
<li><b>287</b> - <em>Bug fix</em>: EMag'd airlocks still closed if they were linked. Added a new bitfield to properly track the airlock EMag status.</li>
<li><b>286</b> - <em>Bug fix</em>: AdminHelp now works with unstable, shows reply-to link and colors it so it stands out.</li>
<li><b>272</b> - <em>Bug fix</em>: Mobs now have names and icons, a bug introduced with previous changes. Also fixed a great many other things in the code.</li>
<li><b>271</b> - <em>Bug fix</em>: Bug where things in your hand rendered as if you were wearing them is now fixed; many other small changes</li>
<li><b>268</b> - <em>Bug fix</em>: Suicide bugs fixed, and the life() proc is now called for things like AI (which should make it susceptible to things like, oh, death)</li>
<li><b>266</b> - <em>Bug fix</em>: AI Suicide message now appears less organic and actually dies.</li>
<li><b>262</b> - <em>Bug fix</em>: Cannisters and tanks can now be filled to the brim on maps (used to have hard limits to initial storage capacities)</li>
<li><b>258</b> - <em>Bug fix</em>: People could run faster when injured than when not. Fixed along with several other things.</li>
<li><b>257</b> - <em>Bug fix</em>: Added a bunch of checks to see if the HUD exists (so monkeys no longer throw errors server side), and a few other small changes. There is now a Blobbishness gene as well.</li>
<li><b>254</b> - <em>Bug fix</em>: Fixed some issues with the damage system, some other small changes</li>
<li><B>243</b> - <em>Bug fix</em>: The AI camera no longer resets when using other machines.</li>
<li><B>235</B> - <em>Bug fix</em>: Hopefully fixed bug that occured while pulling things</li>
<li><B>222</b> - <em>Bug fix</em>: When trying to stuff things into lockers the server would generate a backtrace bug. This is now fixed.</li>
<li><B>206</b> - <em>Bug fix</em>: Floating point error that caused radios to tune 148.2 instead of 148.1 has been fixed.</li>
<li><B>204</b> - <em>Bug fix</em>: People are no longer able to stop floating through space by lying down.</li>
<li><B>194</b> - <em>Bug fix</em>: Clicking on an empty belt slot generated yet another server-side error. This has been fixed.</li>
<li><B>193</b> - <em>Bug fix</em>: Additionalfix to help prevent the intercept-transmission generation bug in traitor mode.</li>
<li><B>192</b> - <em>Big fix</em>: Fixed an issue that caused the intercept-transmisison to not send properly in traitor mode.</li>
<li><B>182</b> - <em>Bug fix</em>: An item somehow had flags turned to NULL. Fixing this.</li>
<li><B>164</b> - <em>Bug fix</em>: Hitting the AI Computer with an EMAG caused the server to throw an exception error. Changed it up so it does checking for upload objects only.</li>
<li><b>162</b> - <em>Bug fix</em>: The bug where security closets no longer needed any access rights has been fixed.</li>
<li><b>143</b> - <em>Bug fix</em>: EMags now have a higher processing priorty (making them work better on things like closets) and fixed up an EMag-on-airlock bug.</li>
<li><b>134</b> - <em>Bug fix</em>: Fixed an error caused when clicking on an empty belt slot.</li>
<li><b>131</b> - <em>Bug fix</em>: Old debugging code made airlocks require forensics and medical supply access. Woops</li>
<li><b>128</b> - <em>Bug fix</em>: Server threw an exception error when clicking on an empty pill cannister. Fixed.</li>
</ul>

<HR>

<P><B>"Stable" Fork production discontinued.</b></p>

<HR>

<P><B>Goon Modifications up to Tuesday, June 24th 2008 (Revision 233):</b><BR>
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
</ul></p>

<p><B>Goon Modifications up to Thursday, June 19th 2008 (Revision 172):</b><BR>
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
</ul></p>

<P><B>Goon Modifications up to Tuesday, June 17th 2008 (Revision 129):</b><BR>
<ul>
<li>Removed random name code for now as it delayed spawning and caused some problems</li>
<li>Fixed exception error with empty pill cannister</li>
<li>Fixed bug with sandbox that threw errors if you logged out or died with the sandbox panel open</li>
<li>Fixed bug in sandbox where non-admins could spawn</li>
<li>Fixed bug where readying didn't spawn you</li>
<li>Changed headset trigger from / to ; as / clears the chatbox when in chat mode</li>
<li>Added the Chaplain position</li>
<li>Made some new access levels</li>
</ul></p>

<HR>

<P><B>At this point the codebase was split into "Stable" and "Unstable" forks. Most of the changes that follow were applied to Stable only (for the time being), as major revisions to the DNA and the code layout in general were being done.</b></P>

<HR>

<P><B>Goon Modifications up to Monday, June 16th 2008 (Revision 117):</b><BR>
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
</ul></p>

<HR>

<P><B>Gibbed is going on SS13 vacation, leaving the SVN in Kurper's hands. Most of the changes from here on out are made by Kurper himself though there are contributions from many others.</b></p>

<HR>

<P><B>Gibbed's changes #12 5/20/2008</b><BR>
(svn revision 64)
<ul>
<li>Tasers now use charges for melee attacks and are increased to 4 charges instead of 3. </li>
<li>Admin help now has better formatting and requires you to be authenticated. </li>
<li>Optical Thermal/MESON scanners are now only optical thermal scanners. </li>
<li>Shuttle doors no longer using their verb to open close and work like normal doors. </li>
<li>Traitor selection messages are big and red!</li>
</ul></p>

<P><B>Gibbed's changes #11 5/19/2008</B><BR>
<ul>
<li>Authentication! Unauthenticated users cannot enter the game or use OOC. </li>
<li>Stuttering now happens before HTML encoding, meaning no more excessive &&&qqqquuuooot;;;;. </li>
<li>Health analyzer now shows offline status. </li>
<li>New command adminhelp which allows you to broadcast messages to only admins. </li>
<li>Several patches by Kurper: APC bug fix, fingerprints on door controls, observe patch, staff assistant rank fix. </li>
<li>Suicide command, thanks to Kurper.</li>
</ul></p>

<p><b>Gibbed's changes #10 4/27/2008</b><br>
<ul>
<li>Added inner cameras to the AI satellite.</li>
<li>Added APC to the external turret area of the AI satellite.</li>
<li>Added turret controls to the external turret area of the AI satellite.</li>
</ul></p>

<p><b>Gibbed's changes #9 4/27/2008</b><br>
<ul>
<li>Updated graphic for the floor in the chapel.</li>
<li>Fixed several APCs that were not properly hooked up to power systems.</li>
<li>Fixed the north solar array so that the battery could not feed power from the main system.</li>
<li>Fixed the APCs for north and south solar array.</li>
<li>Moved the AI Upload Foyer onto its own power network using its own solar array.</li>
<li>Widened the south hallway.</li>
</ul></p>

<p><b>Gibbed's changes #8 4/27/2008</b><br>
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
</ul></p>

<p><b>Gibbed's changes #7 4/27/2008</b><br>
<ul>
<li>Fixed exploit with rechargers charging tasers to 10 charges.</li>
<li>Added hologram generators that the AI can control to a few places around the station.</li>
</ul></p>

<p><b>Gibbed's changes #6 4/27/2008</b><br>
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
</ul></p>

<p><b>Gibbed's changes #5 4/26/2008</b><br>
<ul>
<li>Went through and all exterior floor tiles so they start out with no oxygen, these can be identified by the fact that their name starts with 'airless'. If you spot any exterior floor tiles that are not airless by default please let me know so I can fix it.</li>
<li>APCs can now be cut with wirecutters (only while open!) to disable AI control of the APC. I plan to add a hack type deal (like airlock doors) into them later.</li>
<li>Fixed the chapel pod door controls (oops).</li>
<li>Blob mode: removed some blob spawn points that might cause it to die pretty much instantly.</li>
</ul></p>

<p><b>Gibbed's changes #4 4/25/2008</b><br>
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
</ul></p>

<p><b>Gibbed's changes #3 4/24/2008</b>
<ul>
<li>Blob mode: when you are dead you no longer receive the 'The blob attacks you!' message.</li>
<li>Blob mode: blob should no longer expand to air tunnel / shuttle tiles.</li>
<li>Blob mode: blob should no longer propogate into space.</li>
<li>New toxin researcher locker.</li>
<li>Default anesthetic mix changed.</li>
<li>Added a security camera to the Toxin Research Lab Test Room.</li>
</ul></p>

<p><b>Gibbed's changes #2 4/24/2008</b>
<ul>
<li>Syndicate radio will now spawn in the users backpack if they started with one.</li>
<li>Syndicate radio will now self-destruct in 10 seconds rather than 3.</li>
<li>New traitor objective: eject engine.</li>
<li>Added OxygenIsToxicToHumans AI module, it can be obtained through a syndicate radio.</li>
<li>Decreased size of morgue and increased size of coffin storage.</li>
<li>Changed some engine walls to rwall and lined the interior of the engine with glass.</li>
<li>Fixed a small harmless bug with job picking code that was preventing selection of assistant jobs.</li>
</ul></p>

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
</ul></p>

<HR>

<P><B>Gibbed Forked from base version 40.93.2</B></P>

<HR>
"}
