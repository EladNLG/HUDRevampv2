resource/ui/layouts/Destiny2/Offhand.res
{
	BG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 175"
		Inset				0
		Margin				0
		ProgressDirection			2
		SegmentFill			1
		SegmentSize			72
		ChangeStyle			0
		scaleImage			1

		wide				56
		tall				56

		xpos				2
		ypos				2

		"xpos"			"0"
		"ypos"			"0"
	}
	BGFill
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		ui/white

		fgcolor_override	"255 150 50 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection	2
		SegmentFill			1
		SegmentSize			60
		ChangeStyle			0
		scaleImage			1

		wide				56
		tall				56

		xpos				2
		ypos				2

		"xpos"			"0"
		"ypos"			"0"
	}

	Border
	{
		"ControlName" "ImagePanel"
		"image" "ui/60px_1b"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		"wide" "64"
		"tall" "64"
		"enabled"	"0"

		"xpos"			"0"
		"ypos"			"0"
		pin_to_sibling			BGFill
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}


	Icon
	{
		"ControlName" "ImagePanel"
		"image" "ui/circle"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		wide				56
		tall				56
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"0"
		pin_to_sibling			BG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
	SecondChargeBox
	{
		ControlName			ImagePanel
		image			"ui/destiny2/health_16"

		drawColor	"255 150 50 255"
		scaleImage			1

		wide				60
		tall				8

		"xpos"			"0"
		"ypos"			"5"
		pin_to_sibling			Border
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
	ThirdChargeBox
	{
		ControlName			ImagePanel
		image			"ui/destiny2/health_16"

		drawColor	"255 150 50 255"
		scaleImage	1

		wide				60
		tall				8

		"xpos"			"0"
		"ypos"			"5"
		pin_to_sibling			SecondChargeBox
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
	FourthChargeBox
	{
		ControlName			ImagePanel
		image			"ui/destiny2/health_16"

		drawColor	"255 150 50 255"
		scaleImage	1

		wide				60
		tall				8

		"xpos"			"0"
		"ypos"			"5"
		pin_to_sibling			ThirdChargeBox
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
}