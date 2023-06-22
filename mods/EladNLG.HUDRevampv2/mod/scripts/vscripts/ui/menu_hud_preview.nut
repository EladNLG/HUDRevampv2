global function HudPreview_Init
global function HudRevamp_AddLayout

struct
{
    var menu
    array<string> layouts
    array<string> displayNames
    array<string> authors
    array<var> panels
    int curLayoutIndex = 0
    string curLayout = ""
    var panelHolder
} file
void function HudPreview_Init()
{
    print("yo2")
    AddMenu("HUDPreview", $"resource/ui/menus/hud_preview.menu", HudPreviewMenu_Init, "HUDPreview" )
}

void function HudPreviewMenu_Init()
{
    file.menu = GetMenu( "HUDPreview" )
    file.panelHolder = Hud_GetChild( file.menu, "Hud_Panels" )
    Hud_EnableKeyBindingIcons( Hud_GetChild(file.menu, "ControlsLine1") )
    AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpen )
    AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnClose )
    HudRevamp_AddLayout( "HudRevamp", "Hud Revamp", "EladNLG" )
    HudRevamp_AddLayout( "Destiny2", "Destiny 2", "headassbtw, EladNLG" )
}

// updates the convar and menu.
void function UpdateLayouts()
{
    file.curLayout = file.layouts[file.curLayoutIndex]
    // disable all layout panels
    foreach (var panel in file.panels)
        Hud_SetVisible(panel, false)
    
    // show current layout
    if (Hud_HasChild(file.panelHolder, file.curLayout + "_Hud"))
        Hud_SetVisible(Hud_GetChild(file.panelHolder, file.curLayout + "_Hud"), true)
    if (Hud_HasChild(file.panelHolder, file.curLayout + "_Fullscreen"))
        Hud_SetVisible(Hud_GetChild(file.panelHolder, file.curLayout + "_Fullscreen"), true)
    
    Hud_SetText(Hud_GetChild(file.menu, "HUDName"), file.displayNames[file.curLayoutIndex])
    Hud_SetText(Hud_GetChild(file.menu, "HUDName2"), file.displayNames[file.curLayoutIndex])
    Hud_SetText(Hud_GetChild(file.menu, "HUDAuthor"), file.authors[file.curLayoutIndex])
}

void function OnOpen()
{
    // left
    /*
    table<int, string> keyTable
    foreach ( constant, value in getconsttable() )
    {
        if (typeof( constant ) == "string")
        {
            expect string( constant )
            if (constant.find("BUTTON_") == 0
            || constant.find("KEY_") == 0
            || constant.find("MOUSE_") == 0
            || constant.find("STICK") == 0)
                keyTable[expect int(value)] <- constant
        }
    }
    foreach ( int val, string constant in keyTable )
    {
        printt( val + " = " + constant )
    }
    */
    RegisterButtonPressedCallback( KEY_LEFT, OnLeft )
    RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnLeft )
    RegisterButtonPressedCallback( BUTTON_STICK_LEFT, OnLeft )
    RegisterButtonPressedCallback( KEY_RIGHT, OnRight )
    RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnRight )
    RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, OnRight )
    foreach (int index, string layout in file.layouts)
        if (layout == GetConVarString("comp_hud_layout"))
            file.curLayoutIndex = index

    UpdateLayouts()
}

void function OnClose()
{
    // left
    DeregisterButtonPressedCallback( KEY_LEFT, OnLeft )
    DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnLeft )
    DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, OnLeft )
    // right
    DeregisterButtonPressedCallback( KEY_RIGHT, OnRight )
    DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnRight )
    DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, OnRight )
}

void function OnLeft( var button )
{
    print("left!")
    file.curLayoutIndex--
    if (file.curLayoutIndex < 0)
        file.curLayoutIndex = file.layouts.len() - 1
    UpdateLayouts()
}
void function OnRight( var button )
{
    print("right!")
    file.curLayoutIndex++
    if (file.curLayoutIndex >= file.layouts.len())
        file.curLayoutIndex = 0
    UpdateLayouts()
}


void function HudRevamp_AddLayout(string name, string displayName, string authors) {
    if (Hud_HasChild(file.panelHolder, name + "_Hud"))
    {
        file.panels.append(Hud_GetChild(file.panelHolder, name + "_Hud"))
        if (name == "HudRevamp")
        {
            var hudpanel = Hud_GetChild(file.panelHolder, name + "_Hud")
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandRight"), "BGFill"), 
                GraphCapped( 0.75, 0, 1, 0.25, 0.75 ) )
            CropBar_SetColor( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandRight"), "BGFill2"),
                255, 255, 255, 255 )
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandRight"), "BGFill2"), 
                GraphCapped( 0.8, 0, 1, 0.25, 0.75 ), 0.1 )
            
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandCenter"), "BGFill"), 
                GraphCapped( 0.75, 0, 1, 0.25, 0.75 ) )
            CropBar_SetColor( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandCenter"), "BGFill2"),
                255, 255, 255, 255 )
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandCenter"), "BGFill2"), 
                GraphCapped( 0.8, 0, 1, 0.25, 0.75 ), 0.1 )
            
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandLeft"), "BGFill"), 
                GraphCapped( 0.75, 0, 1, 0.25, 0.75 ) )
            CropBar_SetColor( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandLeft"), "BGFill2"),
                255, 255, 255, 255 )
            CropBar_SetProgress( Hud_GetChild(Hud_GetChild(hudpanel, "OffhandLeft"), "BGFill2"), 
                GraphCapped( 0.8, 0, 1, 0.25, 0.75 ), GraphCapped( 0.1, 0, 1, 0.25, 0.75 ) )
        }
    }
    if (Hud_HasChild(file.panelHolder, name + "_Fullscreen"))
    {
        file.panels.append(Hud_GetChild(file.panelHolder, name + "_Fullscreen"))
    }
    file.layouts.append(name)
    file.displayNames.append(displayName)
    file.authors.append(authors)
}