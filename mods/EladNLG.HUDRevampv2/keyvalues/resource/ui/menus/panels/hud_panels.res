// sidenote: wrong path, but it works :3
// DON'T FIX.
"resource/ui/menus/panels/hud_panels.res"
{
    // wowie :3
    
    // "Destiny2" is the name of the hud. Change it as you wish.
    // _Hud is what appears
    // _FullScreen is what appears as an overlay (flat)
    // KEEP THOSE SUFFIXES. THESE ARE HOW HUDREVAMP DETECTS YOUR LAYOUT.
    // THEY ARE CASE-SENSITIVE.

    Destiny2_Hud
    {
        "ControlName"				"CNestedPanel"
        "xpos"						"0"
        "ypos"						"0"
        "wide"						"%100"
        "tall"						"%100"
        "visible"					"1"
        "tabPosition"				"0"
        "zpos"						"-1"
        "controlSettingsFile"		"resource/ui/layouts/Destiny2/Hud.res"
    }

    Destiny2_Fullscreen
    {
        "ControlName"				"CNestedPanel"
        "xpos"						"0"
        "ypos"						"0"
        "wide"						"%100"
        "tall"						"%100"
        // KEEP THIS TO 0. 
        "visible"					"1"
        "tabPosition"				"0"
        "zpos"						"-1"
        "controlSettingsFile"		"resource/ui/layouts/Destiny2/Fullscreen.res"
    }
    
    HudRevamp_Hud
    {
        "ControlName"				"CNestedPanel"
        "xpos"						"0"
        "ypos"						"0"
        "wide"						"%100"
        "tall"						"%100"
        "visible"					"1"
        "tabPosition"				"0"
        "zpos"						"-1"
        "controlSettingsFile"		"resource/ui/layouts/HudRevamp.res"
    }
}