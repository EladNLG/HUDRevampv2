
resource/ui/healthbar_elite.res
{
	Icon
	{
		ControlName			ImagePanel
		image			"ui/destiny2/ChampionTriangle"
		fg_image			""
		//change_image		vgui/HUD/white

		drawColor	"200 150 50 255"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1

		wide				36
		tall				36

		"xpos"			"0"
		"ypos"			"1"
	}
	IconInner
	{
		ControlName			ImagePanel
		image			"ui/destiny2/ChampionTriangle"
		fg_image			""
		//change_image		vgui/HUD/white

		drawColor	"200 50 50 255"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1
		xpos				3
		ypos				3

		wide				30
		tall				30

		"xpos"			"0"
		"ypos"			"0"
	}
	IconSword
	{
		ControlName			ImagePanel
		image			"ui/destiny2/Sword"
		fg_image			""
		//change_image		vgui/HUD/white

		drawColor	"255 255 255 255"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1
		//xpos				2
		ypos				-3

		wide				16
		tall				16

		pin_to_sibling		IconInner
		pin_to_sibling_corner CENTER
		pin_corner_to_sibling CENTER

		"xpos"			"0"
		"ypos"			"0"
	}
    Name
    {
		ControlName				Label
		xpos					8
		ypos					1
		wide					400
		tall					16
		visible					1
		enabled					1
		auto_tall_tocontents	1
		labelText				"EladNLG (Brute)"
		//textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyLight_20
		//fgcolor_override		""
		allcaps					1

		pin_to_sibling			Icon
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
		ChangeStyle			0
		scaleImage			1

		wide				278
		tall				12

		"xpos"			"0"
		"ypos"			"-23"

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

		fgcolor_override	"200 150 50 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			38
		SegmentGap			2
		ChangeStyle			0
		scaleImage			1

		wide				278
		tall				12

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling			BG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}