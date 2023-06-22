
resource/ui/layouts/Destiny2/Healthbar.res
{
    Name
    {
		ControlName				Label
		xpos					0
		ypos					-2
		wide					256
		tall					28
		visible					1
		enabled					1
		//auto_tall_tocontents	1
		labelText				"Grunt/Pilot"
		//textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraLight_27
		//fgcolor_override		""
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

		wide				256
		tall				16

		"xpos"			"0"
		"ypos"			"24"
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

		wide				256
		tall				20

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling			BG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}