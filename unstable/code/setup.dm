#define CELLSTANDARD 3600000.0		// gas capacity of cell at STP

#define O2STANDARD 756000.0			// O2 standard value (21%)
#define N2STANDARD 2844000.0		// N2 standard value (79%)

#define T0C 273.15					// 0degC
#define T20C 293.15					// 20degC

#define FIREOFFSET 505				//bias for starting firelevel
#define FIREQUOT 15000				//divisor to get target temp from firelevel
#define FIRERATE 5					//divisor of temp difference rate of change

#define NORMPIPERATE 40					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process


//FLAGS BITMASK
#define ONBACK 1			// can be put in back slot
#define TABLEPASS 1 << 1	// can pass by a table or rack
#define HALFMASK 1 << 2		// mask only gets 1/2 of air supply from internals

#define HEADSPACE 1 << 2	// head wear protects against space

#define MASKINTERNALS 1 << 3// mask allows internals
#define SUITSPACE 1 << 3	// suit protects against space

#define USEDELAY 1 << 4		// 1 second extra delay on use
// 1 << 5 is an unused flag, because shields don't exist any more
// 1 << 6 is an unused flag, because everything's drivable by a mass driver now
// Don't reuse them until the flags are all cleaned up (using the #defined things rather than magic numbers)
// because some things probably still have them set
#define ONBELT 1 << 7		// can be put in belt slot
#define FPRINT 1 << 8		// takes a fingerprint
#define WINDOW 1 << 9		// window or window/door
#define GLASSESCOVERSEYES 1 << 10 // glasses/masks/headwear covering certain parts of the face
#define MASKCOVERSEYES 1 << 10
#define HEADCOVERSEYES 1 << 10
#define MASKCOVERSMOUTH 1 << 11
#define HEADCOVERSMOUTH 1 << 11

// channel numbers for power

#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4	//for total power used only

// bitflags for machine stat variable
#define BROKEN 1
#define NOPOWER 1 << 1
#define POWEROFF 1 << 2	// tbd
#define MAINT 1 << 3	// under maintaince
#define EMAGGED 1 << 4 // is something (such as airlocks!) emagged?

#define ENGINE_EJECT_Z 2

#define GAS_O2 1 << 0
#define GAS_N2 1 << 1
#define GAS_PL 1 << 2
#define GAS_CO2 1 << 3
#define GAS_N2O 1 << 4
