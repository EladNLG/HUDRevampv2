// This is the layout of the HUD. Works the same way as any other menu file.
// You need to RESTART YOUR GAME to see changes.
// Unfortunately, this makes editing quite annoying, but I can't do anything.
// sorry :(

hud_revamp.res
{
	Screen
	{
		ControlName		ImagePanel
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
		image			"vgui/hud/white"
		tall		"1080"
		wide		"1920"
		visible			1
		scaleImage		1
		visible			1
	}

	WeaponBG
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 175" // vanilla label color
		"visible" "1"
		"wide" "250"
		"tall" "64"
		"enabled"	"1"

		"xpos"			"1646"
		"ypos"			"992" // can't use rXXX, is relative to screen resolution and not parent panel.
	}
	
	Weapon3Label
	{
		ControlName				Label
		xpos					-8
		ypos					0
		wide					30
		tall					27
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		auto_tall_tocontents	1
		labelText				"3"
		fgcolor_override		"150 150 150 200"
		textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_36

		pin_to_sibling			WeaponBG
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Weapon2Label
	{
		ControlName				Label
		xpos					8
		ypos					0
		wide					30
		tall					27
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		auto_tall_tocontents	1
		labelText				"2"
		fgcolor_override		"150 150 150 200"
		textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_36

		pin_to_sibling			Weapon3Label
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner BOTTOM_LEFT
	}

	Weapon1Label
	{
		ControlName				Label
		xpos					8
		ypos					0
		wide					30
		tall					27
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		auto_tall_tocontents	1
		labelText				"1"
		fgcolor_override		"200 200 200 255"
		textAlignment			center
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_36

		pin_to_sibling			Weapon2Label
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner BOTTOM_LEFT
	}
	AmmoStockpile
	{
		ControlName				Label
		xpos					-12
		ypos					0
		wide					74
		tall					27
		visible					1
		enabled					1
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		labelText				"32"
		fgcolor_override		"200 200 200 255"
		textAlignment			north
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraLight_43

		pin_to_sibling			WeaponBG
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}
	AmmoCount
	{
		ControlName				Label
		xpos					-12
		ypos					0
		wide					30
		tall					48
		visible					1
		enabled					1
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		labelText				"32"
		textAlignment			east
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_43

		pin_to_sibling			AmmoSeparator
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	AmmoSeparator
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"fillColor"	"0 0 0 0"
		"visible" "1"
		"wide" "2"
		"tall" "32"
		"enabled"	"1"

		"xpos"			"12"
		"ypos"			"0"
		"pin_to_sibling"		"AmmoStockpile"
		"pin_to_sibling_corner"	"LEFT"
		"pin_corner_to_sibling"	"LEFT"
	}

	WeaponIcon
	{
		"ControlName" "ImagePanel"
		"image" "r2_ui/menus/loadout_icons/titan_weapon/titan_weapon_40mm"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"fillColor"	"0 0 0 0"
		"visible" "1"
		"wide" "128"
		"tall" "64"
		"enabled"	"1"

		"xpos"			"-12"
		"ypos"			"0"
		"pin_to_sibling"		"WeaponBG"
		"pin_to_sibling_corner"	"LEFT"
		"pin_corner_to_sibling"	"LEFT"
	}

	OffhandRight
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"128"
		"wide"						"64"
		"pin_to_sibling"			"WeaponBG"
		"xpos"						"16"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/layouts/HudRevamp/offhand.res"
	}

	OffhandCenter
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"128"
		"wide"						"64"
		"pin_to_sibling"			"OffhandRight"
		"xpos"						"16"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/layouts/HudRevamp/offhand.res"
	}

	OffhandLeft
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"128"
		"wide"						"64"
		"pin_to_sibling"			"OffhandCenter"
		"xpos"						"16"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/layouts/HudRevamp/offhand.res"
	}

	// HEALTHBAR //

	BarBG
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 175" // vanilla label color
		"visible" "1"
		"wide" "400"
		"tall" "48"	
		"enabled"	"1"

		"xpos"			"24" // can't use rXXX, is relative to screen resolution and not parent panel.
		"ypos"			"1008" // can't use rXXX, is relative to screen resolution and not parent panel.
	}

	Bar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		fgcolor_override	"255 255 255 255"
		bgcolor_override	"0 0 0 0"
		Inset				1
		Margin				1
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		xpos				0
		ypos				0
		wide				400
		tall				48
		visible				1
//		image				vgui/HUD/white
		scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			BarBG
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	SHBar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		fgcolor_override	"75 255 255 255"
		bgcolor_override	"0 0 0 0"
		Inset				1
		Margin				1
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		wide				384
		tall				8
		visible				1
//		image				vgui/HUD/white
		scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			Bar
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	Health
	{
		ControlName				Label
		xpos					-8
		ypos					0
		wide					72
		tall					64
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"100"
		textAlignment			west
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_56

		pin_to_sibling			BarBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	MaxHealth
	{
		ControlName				Label
		xpos					8
		ypos					5
		wide					72
		tall					64
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"100"
		textAlignment			west
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		fgcolor_override 		"200 200 200 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraBold_43

		pin_to_sibling			Health
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	AnnouncementIcon
	{
		ControlName		ImagePanel
		ypos		-200
		tall		200
		wide		200
		//fillColor		"0 0 0 175"
		image			"rui/hud/titanfall_marker_arrow_ready"
		visible			0
		scaleImage		1

		pin_to_sibling	Screen
		pin_to_sibling_corner	TOP
		pin_corner_to_sibling	TOP
	}

	AnnouncementTitleBG
	{
		ControlName		ImagePanel
		ypos		0
		tall		64
		wide		400
		fillColor		"0 0 0 175"
		visible			0

		pin_to_sibling	AnnouncementIcon
		pin_to_sibling_corner	CENTER
		pin_corner_to_sibling	CENTER
	}

	AnnouncementTitle
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					256
		tall					56
		//auto_tall_tocontents	1
		visible					0
		enabled					1
		//auto_wide_tocontents	1
		labelText				"V I C T O R Y"
		textAlignment			center
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraLight_72

		pin_to_sibling			AnnouncementTitleBG
		pin_to_sibling_corner	CENTER
		pin_corner_to_sibling	CENTER
	}

	AnnouncementDesc
	{
		ControlName				Label
		xpos					0
		ypos					8
		wide					256
		tall					56
		//auto_tall_tocontents	1
		visible					0
		enabled					1
		//auto_wide_tocontents	1
		labelText				"Time Ran Out"
		textAlignment			center
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					ChakraLight_27_ShadowGlow

		pin_to_sibling			AnnouncementTitleBG
		pin_to_sibling_corner	BOTTOM
		pin_corner_to_sibling	TOP
	}

	TitanMeterBG
	{
		ControlName		ImagePanel
		ypos		-24
		tall		200
		wide		200
		//fillColor		"0 0 0 175"
		image			"ui/hudrevamp/titan_meter_bg"
		visible			1
		scaleImage		1

		pin_to_sibling	Screen
		pin_to_sibling_corner	BOTTOM
		pin_corner_to_sibling	BOTTOM
	}

	TitanEarnedMeter
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"ui/hudrevamp/circle"
		//change_image		vgui/HUD/white

		fgcolor_override	"250 200 50 255"
		bgcolor_override	"0 0 0 0"
		Inset				1
		Margin				1
		CircularEnabled		1
		CircularClockwise	1
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		xpos				0
		ypos				0
		wide				200
		tall				200
		visible				1
//		image				vgui/HUD/white
		scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			TitanMeterBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	TitanOwnedMeter
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"ui/hudrevamp/circle"
		//change_image		vgui/HUD/white

		fgcolor_override	"50 155 255 255"
		bgcolor_override	"0 0 0 0"
		Inset				1
		Margin				1
		CircularEnabled		1
		CircularClockwise	1
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		xpos				0
		ypos				0
		wide				200
		tall				200
		visible				1
//		image				vgui/HUD/white
		scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			TitanMeterBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	TitanPip
	{
		ControlName		ImagePanel
		tall		200
		wide		200
		//fillColor		"0 0 0 175"
		image			"ui/hudrevamp/pip"
		visible			1
		scaleImage		1

		pin_to_sibling			TitanMeterBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	TitanPercent
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					200
		tall					200
		visible					1
		enabled					1
		labelText				"100"
		textAlignment			center
		//auto_wide_tocontents	1
		//auto_tall_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_120

		pin_to_sibling			TitanMeterBG
		pin_to_sibling_corner	CENTER
		pin_corner_to_sibling	CENTER
	}

	BoostStatus
	{
		ControlName				Label
		xpos					8
		ypos					0
		wide					200
		tall					64
		visible					1
		enabled					1
		labelText				"2"
		textAlignment			west
		wrap					1
		//auto_wide_tocontents	1
		fgcolor_override 		"70 130 255 255"
		font					ChakraBold_120

		pin_to_sibling			TitanMeterBG
		pin_to_sibling_corner	RIGHT
		pin_corner_to_sibling	LEFT
	}

	BoostStatusLabel
	{
		ControlName				Label
		xpos					0
		ypos					-4
		wide					200
		auto_tall_tocontents	1
		visible					1
		enabled					1
		labelText				"Boosts Ready"
		textAlignment			west
		wrap					0
		//auto_wide_tocontents	1
		fgcolor_override 		"70 130 255 255"
		font					ChakraBold_27

		pin_to_sibling			BoostStatus
		pin_to_sibling_corner	TOP_LEFT
		pin_corner_to_sibling	BOTTOM_LEFT
	}


	// KILLFEED I THINK

	KillFeed0
	{
		ControlName				Label
		xpos					-20
		ypos					-24
		tall					24
		wide					180
		auto_wide_tocontents	0
		auto_tall_tocontents	0
		visible					1
		enabled					1
		labelText				"^4682FF00Player ^[Weapon] ^FF860D00Enemy"
		textAlignment			east
		//auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_27

		pin_to_sibling			Screen
		pin_to_sibling_corner	TOP_RIGHT
		pin_corner_to_sibling	TOP_RIGHT
	}

	KillFeed1
	{
		ControlName				Label
		xpos					0
		ypos					6
		tall					24
		wide					180
		auto_wide_tocontents	0
		auto_tall_tocontents	0
		visible					1
		enabled					1
		labelText				"^4682FF00Player ^[Weapon] ^FF860D00Enemy"
		textAlignment			east
		//auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_27

		pin_to_sibling			KillFeed0
		pin_to_sibling_corner	BOTTOM_RIGHT
		pin_corner_to_sibling	TOP_RIGHT
	}

	KillFeed2
	{
		ControlName				Label
		xpos					0
		ypos					6
		tall					24
		wide					180
		auto_wide_tocontents	0
		auto_tall_tocontents	0
		visible					1
		enabled					1
		labelText				"^4682FF00Player ^[Weapon] ^FF860D00Enemy"
		textAlignment			east
		//auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_27

		pin_to_sibling			KillFeed1
		pin_to_sibling_corner	BOTTOM_RIGHT
		pin_corner_to_sibling	TOP_RIGHT
	}

	KillFeed3
	{
		ControlName				Label
		xpos					0
		ypos					6
		tall					24
		wide					180
		auto_wide_tocontents	0
		auto_tall_tocontents	0
		visible					1
		enabled					1
		labelText				"^4682FF00Player ^[Weapon] ^FF860D00Enemy"
		textAlignment			east
		//auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_27

		pin_to_sibling			KillFeed2
		pin_to_sibling_corner	BOTTOM_RIGHT
		pin_corner_to_sibling	TOP_RIGHT
	}

	KillFeed4
	{
		ControlName				Label
		xpos					0
		ypos					6
		tall					24
		wide					180
		auto_wide_tocontents	0
		auto_tall_tocontents	0
		visible					1
		enabled					1
		labelText				"^4682FF00Player ^[Weapon] ^FF860D00Enemy"
		textAlignment			east
		//auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		font					ChakraBold_27

		pin_to_sibling			KillFeed3
		pin_to_sibling_corner	BOTTOM_RIGHT
		pin_corner_to_sibling	TOP_RIGHT
	}
}