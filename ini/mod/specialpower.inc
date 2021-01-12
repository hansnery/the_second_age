; FILE: mod/specialpower.inc //////////////////////////////////////////////////////
; This file contains all the special power definitions and the common data
; to all special powers.  Special powers are things like the super 
; weapons that are available after a certain time is up and the player 
; meets all the prereqs.  The don't have to be weapons tho, some special powers
; heal units, or steal units from other players

; Please note that the Enum must one-for-one correspond with the power within a unit.  Too many
; places in the code have accidentally crossed the distinction of instance and type, such
; that units can't handle having two powers of the same type.  
; /////////////////////////////////////////////////////////////////////////////
