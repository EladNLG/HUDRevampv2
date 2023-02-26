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
	// HEALTHBAR //

	HealthBarBG
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 50" // vanilla label color
		"visible" "1"
		"wide" "500"
		"tall" "18"
		"enabled"	"1"

		"xpos"			"710" // can't use rXXX, is relative to screen resolution and not parent panel.
		"ypos"			"160" // can't use rXXX, is relative to screen resolution and not parent panel.
	}

	HealthBar
	{
		ControlName			CHudProgressBar
		bg_image			"ui/destiny2/health_16"
		fg_image			"ui/destiny2/health_16"
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

		xpos				-4
		ypos				-5
		wide				492
		tall				16
		visible				1
		//image				vgui/HUD/white
		//scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			HealthBarBG
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	DestinyLoadoutPanel
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 0" // vanilla label color
		"visible" "1"
		"wide" "560"
		"tall" "200"
		"enabled"	"1"

		"xpos"			"0150" // can't use rXXX, is relative to screen resolution and not parent panel.
		"ypos"			"880" // can't use rXXX, is relative to screen resolution and not parent panel.
	}

	DestinyPrimarySlot
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "50 52 60 150" // vanilla label color
		"visible" "1"
		"wide" "260"
		"tall" "59"
		"enabled"	"1"

		"xpos"			"-5"
		"ypos"			"-55"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DestinyPrimaryRibbon
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		"wide" "5"
		"tall" "60"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"-55"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DestinyPrimaryAmmoDividerRibbon
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/vertical_bar"
		"scaleImage" "1"
		"drawColor" "250 250 250 100" // vanilla label color
		"visible" "1"
		"wide" "3"
		"tall" "60"
		"enabled"	"1"

		"xpos"			"-50"
		"ypos"			"0"
		pin_to_sibling  			DestinyPrimarySlot
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	DestinyPrimarySlotDividerRibbon
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/weapon0_bottom_8"
		"scaleImage" "1"
		"drawColor" "200 200 200 250" // vanilla label color
		"visible" "1"
		"wide" "265"
		"tall" "8"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"3"
		pin_to_sibling  			DestinyPrimarySlot
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	WeaponIcon
	{
		"ControlName" "ImagePanel"
		"image" "r2_ui/menus/loadout_icons/titan_weapon/titan_weapon_40mm"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"fillColor"	"0 0 0 0"
		"visible" "1"
		"wide" "100"
		"tall" "50"
		"enabled"	"1"

		"xpos"			"-10"
		"ypos"			"-5"
		"pin_to_sibling"		"DestinyPrimarySlot"
		"pin_to_sibling_corner"	"TOP_LEFT"
		"pin_corner_to_sibling"	"TOP_LEFT"
	}

	AmmoCount
	{
		ControlName				Label
		xpos					-60
		ypos					-2
		wide					120
		tall					60
		//auto_tall_tocontents	1
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"32"
		textAlignment			east
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyMedium_43
		//font					NeueHaasGroteskTextProMedium_43

		pin_to_sibling			DestinyPrimarySlot
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	AmmoStockpilePrimary
	{
		ControlName				Label
		xpos					-5
		ypos					0
		wide					60
		tall					60
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"128"
		fgcolor_override		"200 200 200 255"
		textAlignment			east
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyLight_24

		pin_to_sibling			DestinyPrimarySlot
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	DestinySecondarySlot
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 0" // vanilla label color
		"visible" "1"
		"wide" "260"
		"tall" "30"
		"enabled"	"1"

		"xpos"			"-5"
		"ypos"			"-115"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DestinySecondaryRibbon
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		"wide" "5"
		"tall" "30"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"-115"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DestinySecondarySlotDividerRibbon
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/weapon1_bottom_4"
		"scaleImage" "1"
		"drawColor" "150 150 150 175" // vanilla label color
		"visible" "1"
		"wide" "265"
		"tall" "4"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"3"
		pin_to_sibling  			DestinySecondarySlot
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	WeaponIcon1
	{
		"ControlName" "ImagePanel"
		"image" "r2_ui/menus/loadout_icons/primary_weapon/primary_r102"
		"scaleImage" "1"
		"drawColor" "200 200 200 255"
		"visible" "1"
		"wide" "40"
		"tall" "20"
		"enabled"	"1"

		"xpos"			"-10"
		"ypos"			"0"
		"pin_to_sibling"	"DestinySecondarySlot"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}
	AmmoStockpileSecondary
	{
		ControlName				Label
		xpos					-4
		ypos					0
		wide					60
		tall					60
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"128"
		fgcolor_override		"200 200 200 255"
		textAlignment			east
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyLight_24

		pin_to_sibling			DestinySecondarySlot
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	DestinyTertiarySlot
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "0 0 0 0" // vanilla label color
		"visible" "1"
		"wide" "260"
		"tall" "30"
		"enabled"	"1"

		"xpos"			"-5"
		"ypos"			"-145"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DestinyTertiaryRibbon
	{
		"ControlName" "ImagePanel"
		"image" "vgui/hud/white"
		"scaleImage" "1"
		"drawColor" "255 255 255 255" // vanilla label color
		"visible" "1"
		"wide" "5"
		"tall" "30"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"-145"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	WeaponIcon2
	{
		"ControlName" "ImagePanel"
		"image" "r2_ui/menus/loadout_icons/primary_weapon/primary_r102"
		"scaleImage" "1"
		"drawColor" "200 200 200 255" // vanilla label color
		"visible" "1"
		"wide" "40"
		"tall" "20"
		"enabled"	"1"

		"xpos"			"-10"
		"ypos"			"0"
		"pin_to_sibling"	"DestinyTertiarySlot"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	AmmoStockpileTertiary
	{
		ControlName				Label
		xpos					-4
		ypos					0
		wide					60
		tall					60
		visible					1
		enabled					1
		//auto_wide_tocontents	1
		labelText				"128"
		fgcolor_override		"200 200 200 255"
		textAlignment			east
		//fgcolor_override 		"255 255 255 255"
		//bgcolor_override 		"0 0 0 200"
		font					DestinyLight_24

		pin_to_sibling			DestinyTertiarySlot
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	OffhandRight
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"75"
		"wide"						"60"
		"pin_to_sibling"			"DestinyPrimarySlot"
		"xpos"						"8"
		"ypos"						"15"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/destiny_offhand.res"
	}

	OffhandCenter
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"75"
		"wide"						"60"
		"pin_to_sibling"			"OffhandRight"
		"xpos"						"8"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/destiny_offhand.res"
	}

	OffhandLeft
	{
		"ControlName"				"CNestedPanel"
		"classname"					"ModButton"
		"tall"						"75"
		"wide"						"60"
		"pin_to_sibling"			"OffhandCenter"
		"xpos"						"8"
		"pin_corner_to_sibling"		"BOTTOM_RIGHT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
		"controlSettingsFile"		"resource/ui/destiny_offhand.res"
	}

	SuperImageBG
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/super_empty"
		"scaleImage" "1"
		"drawColor" "250 250 0 250" // vanilla label color
		"visible" "1"
		"wide" "80"
		"tall" "80"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"0"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	SuperImage
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/super_empty"
		"scaleImage" "1"
		"drawColor" "0 0 0 0" // vanilla label color
		"visible" "1"
		"wide" "80"
		"tall" "80"
		"enabled"	"1"

		"xpos"			"0"
		"ypos"			"0"
		pin_to_sibling  			SuperImageBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	SuperBarBG
	{
		"ControlName" "ImagePanel"
		"image" "ui/destiny2/health_16"
		"scaleImage" "1"
		"drawColor" "155 155 155 50"
		"visible" "1"
		"wide" "482"
		"tall" "16"
		"enabled"	"1"

		"xpos"			"-78"
		"ypos"			"-31.5"
		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	SuperBar
	{
		ControlName			CHudProgressBar
		bg_image			"ui/destiny2/health_16"
		fg_image			"ui/destiny2/health_16"
		//change_image		vgui/HUD/white

		fgcolor_override	"255 255 255 255"
		bgcolor_override	"0 0 0 0"
		Inset				0
		Margin				0
		ProgressDirection			0
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		xpos				-78
		ypos				-31.5
		wide				482
		tall				16
		visible				1
		//image				vgui/HUD/white
		//scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling  			DestinyLoadoutPanel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
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

	HDBar
	{
		ControlName			CHudProgressBar
		bg_image			"vgui/hud/white"
		fg_image			"vgui/hud/white"
		//change_image		vgui/HUD/white

		fgcolor_override	"175 175 175 255"
		bgcolor_override	"0 0 0 0"
		Inset				1
		Margin				1
		ProgressDirection			1
		SegmentFill			1
		SegmentSize			1000
		ChangeStyle			0
		//ChangeTime			0.5
		//ChangeDir			2
		//ChangeColor			"255 128 64 255"

		CircularEnabled 		0
		CircularClockwise		1

		xpos				-8
		ypos				0
		wide				384
		tall				32
		visible				1
		//image				vgui/HUD/white
		//scaleImage			1

		//drawColor			"160 160 160 128"

		pin_to_sibling			BarBG
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	Health
	{
		ControlName				Label
		xpos					-8
		ypos					0
		wide					72
		tall					72
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
		font					OxaniumBold_56

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
		tall					72
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
		font					OxaniumBold_43_DropShadow

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
		tall		72
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
		font					OxaniumLight_72

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
		font					OxaniumLight_27_ShadowGlow

		pin_to_sibling			AnnouncementTitleBG
		pin_to_sibling_corner	BOTTOM
		pin_corner_to_sibling	TOP
	}
}