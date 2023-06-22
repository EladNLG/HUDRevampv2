untyped
global function CropBar_SetProgress
global function CropBar_SetColor

// bar, 0.9, 0.1
// 
void function CropBar_SetProgress( var bar, float progress, float minProgress = 0.0 )
{
    progress = clamp( progress, minProgress, 1 )
    minProgress = clamp( minProgress, 0, progress )
    int height = Hud_GetHeight( bar )
    int width = Hud_GetWidth( bar )
    float inverse = 1 - progress

    var image = Hud_GetChild( bar, "ImagePanel" )
    var aa = Hud_GetChild( bar, "BarAA" )
    Hud_SetY( aa, -2 )
    // 0.8
    Hud_SetHeight( image, height * (progress - minProgress) )
    Hud_SetY( image, height * (inverse) )
    Hud_SetWidth( image, width )

    image = Hud_GetChild( image, "FG" )
    Hud_SetHeight( image, height )
    Hud_SetY( image, height * (inverse) * -1 )
    Hud_SetWidth( image, width )
}

void function CropBar_SetColor( var bar, arg0, arg1 = null, arg2 = null, arg3 = null )
{
    var image = Hud_GetChild( bar, "ImagePanel" )
    var aa = Hud_GetChild( bar, "BarAA" )
    image = Hud_GetChild( image, "FG" )
    if ( ( arg0 != null ) && ( arg1 == null ) && ( arg2 == null ) && ( arg3 == null ))
    {
        image.SetColor( arg0 )
        aa.SetColor( arg0 )
    }
    else if ( ( arg0 != null ) && ( arg1 != null ) && ( arg2 != null ) && ( arg3 != null ) )
    {
        local args = [arg0, arg1, arg2, arg3]

        image.SetColor( args )
        aa.SetColor( args )
    }
}