
untyped
global function HudRevampLayouts_Init
global function HudRevamp_AddLayout
global function HudRevamp_Announcement
global function HudRevamp_SetObituaryCallback
global function HUDMenuOpenState
global function HudRevamp_Obituary
global function ColorToHex

struct HUDLayout
{
	var panel = null
	var flatPanel = null
	void functionref( var ) initCallback
	void functionref( var ) updateCallback
	void functionref( var ) updateFlatCallback
	void functionref( var, var, string, vector, vector ) obituaryCallback
	void functionref( var, var, AnnouncementData ) announcementCallback
}

struct
{
	entity screen
    table<string, HUDLayout> layouts
} file

void function HudRevamp_AddLayout( string name,
	void functionref( var ) initCallback,
	void functionref( var ) updateCallback,
	void functionref( var ) updateFlatCallback,
	void functionref( var, var, AnnouncementData ) announcementCallback )
{
	HUDLayout layout
	layout.initCallback = initCallback
	layout.updateCallback = updateCallback
	layout.updateFlatCallback = updateFlatCallback
	layout.announcementCallback = announcementCallback
	file.layouts[name] <- layout
}

void function HudRevamp_SetObituaryCallback( string name, void functionref( var, var, string, vector, vector ) callback )
{
	file.layouts[name].obituaryCallback = callback
}

void function HudRevampLayouts_Init()
{
	RegisterSignal( "FrameUpdate" )
    AddCreateCallback( "titan_cockpit", InitHUD )

	thread FlatPanelUpdate()
}

void function HUDMenuOpenState( int state )
{
	clGlobal.isMenuOpen = (state == 1)
	clGlobal.isSoloDialogMenuOpen = (state == 2)
	if (IsValid(clGlobal.levelEnt))
		clGlobal.levelEnt.Signal( "FrameUpdate" )
}

void function FlatPanelUpdate()
{
	WaitFrame()
	var fullscreenVGUI = HudElement("HUDRevamp_panels")
	
	foreach (string name, HUDLayout layout in file.layouts)
	{
		if (Hud_HasChild(fullscreenVGUI, name + "_Hud"))
		{
			Hud_SetVisible(Hud_GetChild(fullscreenVGUI, name + "_Hud"), false)
		}
		if (Hud_HasChild(fullscreenVGUI, name + "_Fullscreen"))
		{
			layout.flatPanel = Hud_GetChild(fullscreenVGUI, name + "_Fullscreen")
			Hud_SetVisible(Hud_GetChild(fullscreenVGUI, name + "_Fullscreen"), false)
		}
	}

	while ( true )
	{
		int ceFlags = GetLocalClientPlayer().GetCinematicEventFlags()
		bool hideHud = ( ceFlags & CE_FLAG_HIDE_MAIN_HUD ) > 0 // MAIN_HUD hide event flag
			|| !GetConVarBool("r_drawvgui") 
			|| !GetConVarBool("rui_drawEnable")
			|| clGlobal.isMenuOpen || clGlobal.isSoloDialogMenuOpen // these are often used to hide hud 
		
		if (!IsValid(GetLocalViewPlayer()))
			hideHud = true
		foreach (string name, HUDLayout layout in file.layouts)
		{
			string selectedLayout = GetConVarString("comp_hud_layout")
			bool showHud = name == selectedLayout && !hideHud
			if (layout.flatPanel == null)
				continue
			Hud_SetVisible(layout.flatPanel, showHud)
			//print(index)
			if (showHud && layout.updateFlatCallback != null)
			{
				layout.updateFlatCallback( layout.flatPanel )
			}
		}
		WaitSignalTimeout( clGlobal.levelEnt, 0.001, "FrameUpdate" )
	}
}

void function HudRevamp_Announcement( AnnouncementData data )
{
	string layout = GetConVarString("comp_hud_layout")
	try
	{
		HUDLayout layout = file.layouts[layout]
		layout.announcementCallback( layout.panel, layout.flatPanel, data )
	}
	catch (ex)
	{
		print(ex)
	}
}

void function InitHUD( entity cockpit )
{
    entity player = GetLocalViewPlayer()
	entity mainVGUI = Create_Hud( "HudRevamp", cockpit, player )
	mainVGUI.s.panel.WarpEnable()
	file.screen = mainVGUI

	foreach (string name, HUDLayout layout in file.layouts)
	{
		// hide all the elements.
		try
		{
			layout.panel = mainVGUI.s.panel.HudElement(name + "_Hud")
			Hud_SetVisible(HudElement(name + "_Hud", mainVGUI.s.panel), false)
			if (layout.initCallback != null)
				layout.initCallback(HudElement(name + "_Hud", mainVGUI.s.panel))
		}
		catch (ex)
		{
			layout.panel = null
		}
		try
		{
			Hud_SetVisible(HudElement(name + "_Fullscreen", mainVGUI.s.panel), false)
		}
		catch (ex2)
		{}
	}

    thread DestroyOnCockpitEnd( cockpit )
}

void function DestroyOnCockpitEnd( entity cockpit )
{
    OnThreadEnd(
        function() : ()
        {
			file.screen.Destroy()
				file.screen = null
			
        }
    )

    cockpit.EndSignal("OnDestroy")
	int ceFlags = GetLocalClientPlayer().GetCinematicEventFlags()
	bool hideHud = !IsAlive(GetLocalClientPlayer()) || // player not alive (sp)
		( ceFlags & CE_FLAG_HIDE_MAIN_HUD ) > 0 || // MAIN_HUD hide event flag
		GetLocalViewPlayer() != GetLocalClientPlayer() || // Kill replay (no access to ammo, etc.)
		!GetConVarBool("r_drawvgui") || !GetConVarBool("rui_drawEnable") // these are often used to hide hud 
	
	if (!IsValid(GetLocalViewPlayer()))
        hideHud = true
	while ( 1 )
	{
		string selectedLayout = GetConVarString("comp_hud_layout")
		foreach (string name, HUDLayout layout in file.layouts)
		{
			bool showHud = name == selectedLayout && !hideHud
			if (layout.panel == null)
				continue
			Hud_SetVisible(layout.panel, showHud)
			//print(index)
			if (showHud && layout.updateCallback != null)
			{
				layout.updateCallback( layout.panel )
			}
		}
		WaitSignalTimeout( clGlobal.levelEnt, 0.0001, "FrameUpdate" )
	}
}

entity function Create_Hud( string cockpitType, entity cockpit, entity player )
{
	string attachment = "CAMERA_BASE"
	int attachId = cockpit.LookupAttachment( attachment )

	vector origin = < 40, 0, 0 >
	vector angles = < 0, 0, 0 >

	origin += AnglesToForward( angles ) * COCKPIT_UI_XOFFSET

	float COCKPIT_UI_WIDTH = 100
	float COCKPIT_UI_HEIGHT = 100 / 1.7665
	origin += AnglesToRight( angles ) * (-COCKPIT_UI_WIDTH / 2)
	origin += AnglesToUp( angles ) * (-COCKPIT_UI_HEIGHT / 2)

	angles = AnglesCompose( angles, < 0, -90, 90 > )

	entity vgui = CreateClientsideVGuiScreen( cockpitType,
		VGUI_SCREEN_PASS_HUD, origin, angles, COCKPIT_UI_WIDTH, COCKPIT_UI_HEIGHT )
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseOrigin <- origin

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	local panel = vgui.GetPanel()

	return vgui
}

bool function HudRevamp_Obituary( string data, vector string1Color, vector string2Color )
{
	string curLayout = GetConVarString("comp_hud_layout")
	if (curLayout in file.layouts && file.layouts[curLayout].obituaryCallback != null)
	{
		HUDLayout layout = file.layouts[curLayout]
		file.layouts[curLayout].obituaryCallback(layout.panel, layout.flatPanel, data, string1Color, string2Color)
		return true
	}
	return false
}

string function ColorToHex( vector color )
{
	return format("%02X%02X%02X", int(color.x), int(color.y), int(color.z))
}