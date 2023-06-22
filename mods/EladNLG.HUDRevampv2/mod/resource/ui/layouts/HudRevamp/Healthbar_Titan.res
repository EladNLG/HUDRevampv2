
resource/ui/layouts/Destiny2/Healthbar_Champion.res
{
    Name
    {
		ControlName				Label
		xpos					0
		ypos					-2
		wide					400
		tall					28
		visible					1
		enabled					1
		//auto_tall_tocontents	1
		auto_wide_tocontents	1
		labelText				"EladNLG (Brute)"
		//textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_27
		//fgcolor_override		""
		allcaps					0
    }
	BG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		drawColor	"0 0 0 127"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		ChangeStyle			0
		scaleImage			1

		wide				398
		tall				20

		"xpos"			"0"
		"ypos"			"24"
	}

    Bar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		change_image		vgui/HUD/white

		fgcolor_override	"200 50 50 255"
		bgcolor_override	"255 255 255 0"
		ChangeColor			"255 255 255 255"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			48
		SegmentGap			2
		ChangeStyle			2
		ChangeTime			0.5
		scaleImage			1

		wide				398
		tall				20

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling			BG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	ShieldBar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		change_image		vgui/HUD/white

		fgcolor_override	"221 221 221 255"
		bgcolor_override	"255 255 255 0"
		ChangeColor			"255 255 255 0"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			10000
		SegmentGap			0
		ChangeStyle			0
		ChangeTime			0
		scaleImage			1

		wide				278
		tall				3

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling			Bar
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
}