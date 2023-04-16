global function HudRevampSettings_Init
global function TestDialog

void function TestDialog()
{
	DialogData dialogData
	dialogData.header = "help"
	dialogData.message = "please"

	AddDialogButton( dialogData, Localize("%%$r2_ui/menus/loadout_icons/primary_weapon/primary_kraber%%") )
	AddDialogButton( dialogData, "#YES" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_BACK" )

	OpenDialog( dialogData )
}

void function HudRevampSettings_Init()
{
	AddModTitle("HUD ^FF902000Revamp")
	AddModCategory("General")
	AddConVarSettingEnum("comp_hud_layout", "Layout", [ "HUDRevamp", "Destiny 2" ] )
	AddModSettingsButton( "Preview HUD", void function() : () {
		AdvanceMenu( GetMenu( "HUDPreview" ) )
		//print("Advance!")
	})
	AddModCategory("Damage Indicator")
	AddConVarSettingEnum( "comp_hud_damage_indicator", "Enabled", [ "No", "Yes" ] )
	AddConVarSetting( "comp_hud_damage_indicator_duration", "Duration", "float" )
	AddConVarSetting( "comp_hud_damage_indicator_fade_time", "Fade Time", "float" )

	AddModCategory("Incoming Damage Indicator")
	AddConVarSettingEnum( "comp_hud_incoming_damage_indicator", "Enabled", [ "No", "Yes" ] )
	AddConVarSetting( "comp_hud_incoming_damage_indicator_duration", "Duration", "float" )
	AddConVarSetting( "comp_hud_incoming_damage_indicator_fade_time", "Fade Time", "float" )
	thread UpdateHUDMenuOpenState()
	//AddConVarSetting("")
}

void function OpenMissingDepPopup_Thread()
{
	WaitFrame()
	OpenMissingDepPopup()
}


void function UpdateHUDMenuOpenState()
{
	for ( ;; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( CanRunClientScript() )
		{
			int newState = 0
			if ( IsDialogOnlyActiveMenu() )
				newState = 2
			else if ( uiGlobal.activeMenu != null )
				newState = 1

			RunClientScript( "HUDMenuOpenState", newState )
		}
	}
}
void function OpenMissingDepPopup()
{
	DialogData dialogData
	dialogData.header = "MISSING REQUIRED DEPENDENCY"
	dialogData.message = "HUDRevamp requires ModSettings to function. The mod was not found. Please download it."
	dialogData.image = $"ui/menu/common/dialog_error"
	AddDialogButton( dialogData, "Retry", void function() {
		ClientCommand("uiscript_reset")
	} )
	AddDialogButton( dialogData, "Download", void function() {
		LaunchExternalWebBrowser( "https://northstar.thunderstore.io/package/EladNLG/ModSettings/", WEBBROWSER_FLAG_FORCEEXTERNAL )
		OpenMissingDepPopup()
	} )

	OpenDialog(dialogData)
}