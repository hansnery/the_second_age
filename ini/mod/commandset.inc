//------------------------------------------------------------------------------
// mod/commandSet.inc
//
// See what was for Generals below.  For LotR things have changed since we no longer have
// the same UI.
// If the Command in CommandButton.ini has a field Radial=Yes, then that command
// will show up in a radial menu above the object in the game world.
//
// If a command button has InPalantir=Yes then it will be displayed in the
// palantir when it's in a command set for the selected object.
//
// Locations for the Skill button in clockwise fashion.  The top right button
// being button 1. 

// If these actions are not taken, the commands will only show
// up if you pass in -OldGui to the game (but they are not usable right now)
// ------------------------------------------------------------------------------
//Command sets are groups of command buttons that will be displayed in the
//context sensitive user interface for a selected object showing what you
//can do with that object
//
//LHS numbers are the physical GUI buttons.  You can assign a command
//to any of the physical buttons, they do *NOT* need to appear in
//continuous order ... you may have gaps if you desire
//
//RHS strings are CommandButton.ini command names
//
//Buttons for a regular command context are ordered as:
//                    +--+
//+--+--+--+--+--+--+ |13|
//|01|03|05|07|09|11| +--+
//+--+--+--+--+--+--+ |14|    <-- Smaller buttons 3 fit within 11 & 12 in height.
//|02|04|06|08|10|12| +--+
//+--+--+--+--+--+--+ |15|
//                    +--+
//------------------------------------------------------------------------------

