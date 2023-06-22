resource/ui/layouts/Destiny2/Gamestate.res
{
	BG
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"0 0 0 0"
		scaleImage			1

		wide				1400
		tall				200

		"xpos"			"0"
		"ypos"			"0"

		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	//This is mainly just here as a point of reference so i can draw stuff out in gimp
	//DO NOT MOVE IT
  Teams_Divider
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 0"
		scaleImage			1

		wide				2
		tall				50

		"ypos"			"-10"

    	pin_to_sibling "BG"
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	BOTTOM
	}

	Deco
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/deco"
		fg_image			"ui/destiny2/gamestate/deco"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				512
		tall				128

		"xpos"			"184"
		"ypos"			"34"

    pin_to_sibling "Teams_Divider"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Round_Timer{
		ControlName				Label
		xpos					100
		ypos					0
		wide					200
		tall					100
		visible					1
		enabled					1
		labelText				"0:00"
		textAlignment			center
		font					DestinyLight_36

		pin_to_sibling			"Teams_Divider"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Score
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"79 121 1278 255"
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

		pin_to_sibling			Team0_Score
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_ScoreBar
	{
		ControlName			CHudProgressBar
		image			    "vgui/hud/white"
		fg_image			"vgui/hud/white"

		ProgressDirection			1
		CircularEnabled 		0
		SegmentFill			1
		SegmentSize			1000

		fgcolor_override	"79 121 1278 255"
		scaleImage			1

		wide				170
		tall				10

		"xpos"			"0"
		"ypos"			"10"

    pin_to_sibling "Team0_Score"
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team0_ScoreBar_Border_Winning
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/scorebar_outline_winning"
		fg_image			"ui/destiny2/gamestate/scorebar_outline_winning"

		drawColor	"79 121 1278 255"
		scaleImage			1

		wide				256
		tall				16

		"xpos"			"3"
		"ypos"			"3"

    pin_to_sibling "Team0_ScoreBar"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Team0_ScoreBar_Border
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/scorebar_outline"
		fg_image			"ui/destiny2/gamestate/scorebar_outline"

		drawColor	"255 255 255 255"
		scaleImage			1

		wide				256
		tall				16

		"xpos"			"3"
		"ypos"			"3"

    pin_to_sibling "Team0_ScoreBar"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Team0_Score_Border
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/score_outline"
		fg_image			"ui/destiny2/gamestate/score_outline"

		drawColor	"255 255 255 255"
		scaleImage			1

		wide				128
		tall				64

		"xpos"			"1"
		"ypos"			"1"

    pin_to_sibling "Team0_Score"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}



	Team1_Score
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"172 50 39 255"
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

		pin_to_sibling			Team1_Score
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team1_ScoreBar
	{
		ControlName			CHudProgressBar
		fg_image			"vgui/hud/white"
		bg_image			"vgui/hud/white"

		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0

		CircularEnabled 		0
		CircularClockwise		1

		fgcolor_override	"172 50 39 255"
		scaleImage			1

		wide				170
		tall				10

		"xpos"			"0"
		"ypos"			"10"

    pin_to_sibling "Team1_Score"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team1_ScoreBar_Border_Winning
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/scorebar_outline_winning"
		fg_image			"ui/destiny2/gamestate/scorebar_outline_winning"

		drawColor	"172 50 39 255"
		scaleImage			1

		wide				256
		tall				16

		"xpos"			"3"
		"ypos"			"3"

    pin_to_sibling "Team1_ScoreBar"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Team1_ScoreBar_Border
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/scorebar_outline"
		fg_image			"ui/destiny2/gamestate/scorebar_outline"

		drawColor	"255 255 255 255"
		scaleImage			1

		wide				256
		tall				16

		"xpos"			"3"
		"ypos"			"3"

    pin_to_sibling "Team1_ScoreBar"
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Team1_Score_Border
	{
		ControlName			ImagePanel
		image			"ui/destiny2/gamestate/score_outline"
		fg_image			"ui/destiny2/gamestate/score_outline"

		drawColor	"255 255 255 255"
		scaleImage			1

		wide				128
		tall				64

		"xpos"			"1"
		"ypos"			"1"

    pin_to_sibling "Team1_Score"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	// TEAMS //

	Team0
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"128 128 128 0"
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

		drawColor	"128 128 128 0"
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

		drawColor	"255 255 255 175"
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

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player0"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player2
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player1"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player3
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player2"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player4
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player3"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player5
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player4"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player6
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player5"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	Team0_Player7
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team0_Player6"
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}


	Team1_Player0
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
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

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player0"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player2
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player1"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player3
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player2"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player4
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player3"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player5
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player4"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player6
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player5"
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Team1_Player7
	{
		ControlName			ImagePanel
		image			"vgui/hud/white"
		fg_image			"vgui/hud/white"

		drawColor	"255 255 255 175"
		scaleImage			1

		wide				60
		tall				60

		"xpos"			"4"
		"ypos"			"0"

		pin_to_sibling "Team1_Player6"
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
		labelText				"WORK IN PROGRESS"
		textAlignment			center
    pin_to_sibling "BG"
		font					ChakraLight_24
  }
}