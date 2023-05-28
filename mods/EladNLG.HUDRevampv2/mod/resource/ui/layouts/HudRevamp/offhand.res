resource/ui/offhand.res
{
	BG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		drawColor	"0 0 0 175"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1

		wide				72
		tall				72

		"xpos"			"0"
		"ypos"			"56"
	}
    BGFill
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		fgcolor_override	"255 150 50 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1

		wide				72
		tall				72

		"xpos"			"0"
		"ypos"			"56"
	}
	Icon
	{
		"ControlName" "ImagePanel"
		"image" "rui/pilot_loadout/ordnance/frag"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		"wide" "64"
		"tall" "64"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"0"
		pin_to_sibling			BG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
    Bar
	{
		ControlName			CHudProgressBar
		bg_image			"ui/circle"
		fg_image			"ui/circle"
		//change_image		vgui/HUD/white

		fgcolor_override	"255 150 50 255"
		bgcolor_override	"0 0 0 175"
		Inset				1
		Margin				1
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		1
		CircularClockwise		1

		xpos				0
		ypos				8
		wide				36
		tall				36
		visible				1
//		image				vgui/HUD/white
		scaleImage			1

		//drawColor			"160 160 160 128"

		zpos				201

		pin_to_sibling			BG
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}

	"Charges"
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					64
		tall					64
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"1"
		textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					OxaniumBold_27
		//fgcolor_override		""

		pin_to_sibling			Bar
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
}