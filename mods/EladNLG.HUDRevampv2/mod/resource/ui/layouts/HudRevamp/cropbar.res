
cropbar.res
{
	ImagePanel
	{
		"ControlName"				"CNestedPanel"
		"tall"						"80"
		"wide"						"128"
		pin_to_sibling			BG
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	BOTTOM
		"ypos"			"48"
		"controlSettingsFile"		"resource/ui/layouts/HudRevamp/cropbar_fg.res"
	}
    BarAA
    {
        
		ControlName		ImagePanel
		fillColor		"0 0 0 0"
		drawColor				"255 150 50 255"
		image			"ui/hudrevamp/baraa"
		tall		"4"
		wide		"128"
        ypos        "-1"
        
		visible			1
		scaleImage		1
        pin_to_sibling  ImagePanel
        pin_to_sibling_corner TOP
        pin_corner_to_sibling BOTTOM
    }
}