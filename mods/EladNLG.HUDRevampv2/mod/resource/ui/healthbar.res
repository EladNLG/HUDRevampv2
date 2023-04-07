
resource/ui/healthbar.res
{
	IconBG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		drawColor	"85 85 85 255"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1
		border				WhiteBorder
		visible				0

		wide				32
		tall				32

		"xpos"			"0"
		"ypos"			"0"
	}
	Icon
	{
		ControlName	RuiPanel

		rui		ui/basic_image.rpak
		wide	30
		tall	30
		visible	1

		pin_to_sibling			IconBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
    Name
    {
		ControlName				Label
		xpos					8
		ypos					0
		wide					256
		tall					14
		visible					1
		enabled					1
		auto_tall_tocontents	1
		labelText				"Grunt/Pilot"
		//textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyLight_16
		//fgcolor_override		""

		pin_to_sibling			IconBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
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
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1

		wide				192
		tall				12

		"xpos"			"0"
		"ypos"			"-20"

		pin_to_sibling			Name
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    Bar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		fgcolor_override	"200 50 50 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			256
		ChangeStyle			0
		scaleImage			1

		wide				192
		tall				12

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling			BG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}