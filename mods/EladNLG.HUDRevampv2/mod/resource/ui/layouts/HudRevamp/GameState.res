gamestate.res
{
	Screen
	{
		ControlName Label
		wide f0
		tall f0
		labelText ""
		visible 0
	}
    "TimerBG"
    {
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 175"
		scaleImage			1
        visible             1

		wide				64
		tall				27

		"xpos"			"0"
		"ypos"			"-24"

        pin_to_sibling          Screen
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
    }

    "Timer"
    {
        
		ControlName				Label
		xpos					0
		ypos					0
		wide					72
		tall					64
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"15:00"
		textAlignment			center
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraLight_27

		pin_to_sibling			TimerBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
    }

	ScoreBarFriendly
	{
		ControlName			CHudProgressBar
		image			    "vgui/hud/white"
		fg_image			"vgui/hud/white"

		ProgressDirection			1
		CircularEnabled 		0
		SegmentFill			1
		SegmentSize			1000
        Inset               4
        Margin              4

		fgcolor_override	"70 130 255 255"
        bgcolor_override    "0 0 0 175"
		scaleImage			1

		wide				170
		tall				18

		"xpos"			"8"
		"ypos"			"0"

    	pin_to_sibling "TimerBG"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

    "ScoreFriendly"
    {
		ControlName				Label
		xpos					8
		ypos					0
		wide					72
		tall					64
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"56"
		textAlignment			center
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		fgcolor_override 		"70 130 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_36

		pin_to_sibling			ScoreBarFriendly
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
    }

	ScoreBarEnemy
	{
		ControlName			CHudProgressBar
		image			    "vgui/hud/white"
		fg_image			"vgui/hud/white"

		ProgressDirection			0
		CircularEnabled 		0
		SegmentFill			1
		SegmentSize			1000
        Inset               4
        Margin              4

		fgcolor_override	"200 50 50 255"
        bgcolor_override    "0 0 0 175"
		scaleImage			1

		wide				170
		tall				18

		"xpos"			"8"
		"ypos"			"0"

    	pin_to_sibling "TimerBG"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

    "ScoreEnemy"
    {
		ControlName				Label
		xpos					8
		ypos					0
		wide					72
		tall					64
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"32"
		textAlignment			center
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		fgcolor_override 		"200 50 50 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_36

		pin_to_sibling			ScoreBarEnemy
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
    }

    "TitanStatusFriendly"
    {
		ControlName			CHudProgressBar
		image			    "vgui/hud/white"
		fg_image			"vgui/hud/white"

		ProgressDirection			1
		CircularEnabled 		0
		SegmentFill			1
		SegmentSize			19
        SegmentGap          2
        Inset               2
        Margin              2

		fgcolor_override	"200 200 200 255"
        bgcolor_override    "0 0 0 175"
		scaleImage			1

		wide				170
		tall				6

		"xpos"			"0"
		"ypos"			"3"

    	pin_to_sibling "ScoreBarFriendly"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT

    }

    "TitanStatusEnemy"
    {
		ControlName			CHudProgressBar
		image			    "vgui/hud/white"
		fg_image			"vgui/hud/white"

		ProgressDirection			0
		CircularEnabled 		0
		SegmentFill			1
		SegmentSize			19
        SegmentGap          2
        Inset               2
        Margin              2

		fgcolor_override	"200 200 200 255"
        bgcolor_override    "0 0 0 175"
		scaleImage			1

		wide				170
		tall				6

		"xpos"			"0"
		"ypos"			"3"

    	pin_to_sibling "ScoreBarEnemy"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT

    }
}