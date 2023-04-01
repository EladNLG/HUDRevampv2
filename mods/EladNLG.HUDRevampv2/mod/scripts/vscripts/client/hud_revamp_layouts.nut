
untyped
global function HudRevampLayouts_Init
global function HudRevamp_AddLayout
global function HudRevamp_Announcement

struct
{
    array<string> layouts = []
	array<entity> screens = []
	array<void functionref( var )> updateCallbacks
	array<void functionref( var, AnnouncementData )> announcementCallbacks
} file

void function HudRevamp_AddLayout( string name,
	void functionref( var ) updateCallback,
	void functionref( var, AnnouncementData ) announcementCallback )
{
	file.layouts.append(name)
	file.updateCallbacks.append(updateCallback)
	file.announcementCallbacks.append(announcementCallback)
}

void function HudRevampLayouts_Init()
{
    AddCreateCallback( "titan_cockpit", InitHUD )
}

void function HudRevamp_Announcement( AnnouncementData data )
{
	int layout = GetConVarInt("comp_hud_layout")
	try
	{
		file.announcementCallbacks[layout]( file.screens[layout].GetPanel(), data )
	}
	catch (ex)
	{
		print(ex)
	}
}

void function InitHUD( entity cockpit )
{
    entity player = GetLocalViewPlayer()
	foreach (int index, string layout in file.layouts)
	{
		entity mainVGUI = Create_Hud( file.layouts[index], cockpit, player )

		local panel = mainVGUI.s.panel
		local warpSettings = mainVGUI.s.warpSettings
		printt("XWARP:", warpSettings.xWarp)
		mainVGUI.s.panel.WarpGlobalSettings( 34, 0, 34 / 1.7665, 0, warpSettings.viewDist )
		mainVGUI.s.panel.WarpEnable()

		file.screens.append(mainVGUI)
	}



    thread DestroyOnCockpitEnd( cockpit )
}

void function DestroyOnCockpitEnd( entity cockpit )
{
    OnThreadEnd(
        function() : ()
        {
			foreach (entity screen in file.screens)
				screen.Destroy()
			file.screens = []
        }
    )

    cockpit.EndSignal("OnDestroy")
	int ceFlags = GetLocalClientPlayer().GetCinematicEventFlags()
	bool hideHud = !IsAlive(GetLocalClientPlayer()) || ( ceFlags & CE_FLAG_HIDE_MAIN_HUD ) > 0 || GetLocalViewPlayer() != GetLocalClientPlayer()
	if (!IsValid(GetLocalViewPlayer()))
        hideHud = false
	while ( 1 )
	{
		foreach (int index, entity screen in file.screens)
		{
			//print(index)
			if (index == GetConVarInt("comp_hud_layout") && !hideHud)
			{
				screen.SetAttachOffsetOrigin( screen.s.baseOrigin )
				file.updateCallbacks[index]( screen.s.panel )
			}
			else screen.SetAttachOffsetOrigin( <170, 0, 1000 > )
		}
		WaitFrame()
	}
}

entity function Create_Hud( string cockpitType, entity cockpit, entity player )
{
	string attachment = "CAMERA_BASE"
	int attachId = cockpit.LookupAttachment( attachment )

	vector origin = < 190, 0, 0 >
	vector angles = < 0, 0, 0 >
	var warpSettings

	origin += AnglesToForward( angles ) * COCKPIT_UI_XOFFSET
	warpSettings = {
		xWarp = 24
		xScale = 1.0
		yWarp = 24 / 1.7665
		yScale = 1.0
		viewDist = 1.0
	}

	float COCKPIT_UI_WIDTH = 350
	float COCKPIT_UI_HEIGHT = 350 / 1.7665
	origin += AnglesToRight( angles ) * (-COCKPIT_UI_WIDTH / 2)
	origin += AnglesToUp( angles ) * (-COCKPIT_UI_HEIGHT / 2)

	angles = AnglesCompose( angles, < 0, -90, 90 > )

	entity vgui = CreateClientsideVGuiScreen( cockpitType,
		VGUI_SCREEN_PASS_HUD, origin, angles, COCKPIT_UI_WIDTH, COCKPIT_UI_HEIGHT )
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseOrigin <- origin
	vgui.s.warpSettings <- warpSettings

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	local panel = vgui.GetPanel()

	//Create_CommonHudElements( vgui, panel )

	/*HudElement( "Screen", panel ).SetColor( 0, 0, 0, 0 )
	HudElement( "AmmoBarr", panel ).SetSize( 32, 32 )
	HudElement( "AmmoBarr", panel ).SetPos( 0, 0)
	Hud_MoveOverTime( HudElement( "AmmoBarr", panel ), 1920 / 2 - 32, 1080 - 64, 10 )
	HudElement("AmmoBarr", panel).SetBarProgressAndRate(0.0, 0.1)*/

	return vgui
}