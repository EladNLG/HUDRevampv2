global function HudRevampSettings_Init

void function HudRevampSettings_Init()
{
	AddModTitle("HUD ^FF902000Revamp")
	AddModCategory("General")
	AddConVarSettingEnum("comp_hud_layout", "Layout", [ "HUDRevamp", "Destiny 2" ] )
	AddModCategory("Damage Indicator")
	AddConVarSettingEnum( "comp_hud_damage_indicator", "Enabled", [ "No", "Yes" ] )
	AddConVarSetting( "comp_hud_damage_indicator_duration", "Duration", "float" )
	AddConVarSetting( "comp_hud_damage_indicator_fade_time", "Fade Time", "float" )

	AddModCategory("Incoming Damage Indicator")
	AddConVarSettingEnum( "comp_hud_incoming_damage_indicator", "Enabled", [ "No", "Yes" ] )
	AddConVarSetting( "comp_hud_incoming_damage_indicator_duration", "Duration", "float" )
	AddConVarSetting( "comp_hud_incoming_damage_indicator_fade_time", "Fade Time", "float" )
	//AddConVarSetting("")
}

void function OpenMissingDepPopup_Thread()
{
	WaitFrame()
	OpenMissingDepPopup()
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