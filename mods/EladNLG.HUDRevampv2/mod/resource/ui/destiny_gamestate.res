resource/ui/destiny_gamestate.res
{
	BG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 175"
		scaleImage			1

		wide				1200
		tall				200

		"xpos"			"0"
		"ypos"			"0"

		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
  Teams_Divider
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				2
		tall				50

		"xpos"			"-591"
		"ypos"			"-125"

    pin_to_sibling "BG"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Score
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 255 175"
		scaleImage			1

		wide				90
		tall				50

		"xpos"			"14"
		"ypos"			"0"

    pin_to_sibling "Teams_Divider"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_ScoreCount
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					90
		tall					50
		visible					1
		enabled					1
		labelText				"0"
		textAlignment			center
		font					DestinyMedium_43
		//font					NeueHaasGroteskTextProMedium_43

		pin_to_sibling			Team0_Score
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_ScoreBar
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 175"
		scaleImage			1

		wide				170
		tall				10

		"xpos"			"0"
		"ypos"			"10"

    pin_to_sibling "Team0_Score"
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Score
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 0 0 175"
		scaleImage			1

		wide				90
		tall				50

		"xpos"			"14"
		"ypos"			"0"

    pin_to_sibling "Teams_Divider"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_ScoreCount
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					90
		tall					50
		visible					1
		enabled					1
		labelText				"0"
		textAlignment			center
		font					DestinyMedium_43
		//font					NeueHaasGroteskTextProMedium_43

		pin_to_sibling			Team1_Score
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team1_ScoreBar
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 175"
		scaleImage			1

		wide				170
		tall				10

		"xpos"			"0"
		"ypos"			"10"

    pin_to_sibling "Team1_Score"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	// TEAMS //

	Team0
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 128 128 175"
		scaleImage			1

		wide				380 //(60*6) + (2*5)
		tall				60

		"xpos"			"20"
		"ypos"			"5"

		pin_to_sibling "Team0_Score"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team1
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 128 128 175"
		scaleImage			1

		wide				380 //(60*6) + (2*5)
		tall				60

		"xpos"			"20"
		"ypos"			"5"

		pin_to_sibling "Team1_Score"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	// PLAYERS //

	Team0_Player0
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 0 128 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling "Team0"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team0_Player1
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 0 128 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player0"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}


	Team1_Player0
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 0 128 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"0"
		"ypos"			"0"

		pin_to_sibling "Team1"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team1_Player1
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 0 128 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player0"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

  Name
  {
		ControlName				Label
		xpos					0
		ypos					0
		wide					256
		tall					64
		visible					1
		enabled					1
		auto_tall_tocontents	1
		labelText				"PLACEHOLDER"
		textAlignment			center
    pin_to_sibling "BG"
		font					OxaniumLight_24
  }
}