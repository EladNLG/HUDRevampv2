resource/ui/layouts/Destiny2/FrontierDefense_ShieldStatus.res
{
    FD_STATUS_GRAPHIC
	{
		ControlName			ImagePanel
		image			"ui/destiny2/objectives/fd"
		fg_image			"ui/destiny2/objectives/fd"

		drawColor	"255 255 255 255"

		wide				1024
		tall				512

		xpos				0
		ypos				0
	}

    FD_STATUS_HEADER
	{
		ControlName			Label

		//auto_tall_tocontents	1
		labelText				"ACCORDING TO ALL KNOWN LAWS OF AVIATION"
		textAlignment			"WEST"
		font					DestinyMedium_24

		wide				523
		tall				33

		"xpos"			"-158"
		"ypos"			"-11"

		pin_to_sibling "FD_STATUS_GRAPHIC"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_STATUS_LINE0
	{
		ControlName			Label

		labelText				"Protect the harvester"
		textAlignment			"WEST"
		font					DestinyLight_24

		wide				523
		tall				33

		"xpos"			"-158"
		"ypos"			"-69"

		pin_to_sibling "FD_STATUS_GRAPHIC"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_STATUS_LINE1
	{
		ControlName			Label

		labelText				"Wave 2 of 5"
		textAlignment			"WEST"
		font					DestinyLight_24

		wide				523
		tall				33

		"xpos"			"-158"
		"ypos"			"-100"

		pin_to_sibling "FD_STATUS_GRAPHIC"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_STATUS_LINE2
	{
		ControlName			Label

		labelText				"Enemies: 108"
		textAlignment			"WEST"
		font					DestinyLight_24

		wide				523
		tall				33

		"xpos"			"-158"
		"ypos"			"-134"

		pin_to_sibling "FD_STATUS_GRAPHIC"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_STATUS_ICON
	{
		ControlName			ImagePanel
		image			    "ui/destiny2/gamestate/icon_titan"
		fg_image			"ui/destiny2/gamestate/icon_titan"

		drawColor	        "255 255 255 255"
        scaleImage          1

		wide				58
		tall				58

		xpos				-77
		ypos				-1

        pin_to_sibling "FD_STATUS_GRAPHIC"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_HARVESTER_HEALTH_BG_TEMP
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/health_16"
		"scaleImage" "1"
		"drawColor" "255 255 255 255"
		"visible" "1"
		"wide" "482"
		"tall" "22"
		"enabled"	"1"
			
		xpos				-155
		ypos				-186

		pin_to_sibling			FD_STATUS_GRAPHIC
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

    FD_HARVESTER_HEALTH
	{
		ControlName			CHudProgressBar
		bg_image			"ui/destiny2/health_16"
		fg_image			"ui/destiny2/health_16"

		fgcolor_override	"255 255 255 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0

		CircularEnabled 		0
		CircularClockwise		1

		xpos				-156
		ypos				-187
		wide				480
		tall				20
		visible				1

		pin_to_sibling			FD_STATUS_GRAPHIC
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}