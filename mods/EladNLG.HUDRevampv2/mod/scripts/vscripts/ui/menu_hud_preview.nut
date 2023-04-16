global function HudPreview_Init

struct
{
    var menu
} file
void function HudPreview_Init()
{
    print("yo2")
    AddMenu("HUDPreview", $"resource/ui/menus/hud_preview.menu", HudPreviewMenu_Init, "HUDPreview" )
}

void function HudPreviewMenu_Init()
{
    print("yo")
    file.menu = GetMenu( "HUDPreview" )
    Hud_EnableKeyBindingIcons( Hud_GetChild(file.menu, "ControlsLine1") )
}