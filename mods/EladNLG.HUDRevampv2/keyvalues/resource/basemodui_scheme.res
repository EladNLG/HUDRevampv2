///////////////////////////////////////////////////////////
// Tracker scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
///////////////////////////////////////////////////////////
Scheme
{
	InheritableProperties
	{
		ChatBox
		{
			bgcolor_override 		"0 0 0 180"

			chatBorderThickness		3

			chatHistoryBgColor		"24 27 30 0"
			chatEntryBgColor		"24 27 30 0"
			chatEntryBgColorFocused	"24 27 30 0"
		}
	}
	Fonts
	{
		ChatFont
		{
			1
			{
				shadowglow	0
				outline 1
			}
			2
			{
				shadowglow	0
				outline 1
			}
			3
			{
				shadowglow	0
				outline 1
			}
		}
		DestinyLight_16
		{
			isproportional only
			1
			{
				name			DestinyLight
				tall			16
				antialias 		1
			}
		}
		DestinyLight_20
		{
			isproportional only
			1
			{
				name			DestinyLight
				tall			20
				antialias 		1
			}
		}
		DestinyMedium_20
		{
			isproportional only
			1
			{
				name			DestinyMedium
				tall			20
				antialias 		1
			}
		}
		DestinyLight_24
		{
			isproportional only
			1
			{
				name			DestinyLight
				tall			24
				antialias 		1
			}
		}
		DestinyLight_36
		{
			isproportional only
			1
			{
				name			DestinyLight
				tall			36
				antialias 		1
			}
		}
		DestinyMedium_24
		{
			isproportional only
			1
			{
				name			DestinyMedium
				tall			24
				antialias 		1
			}
		}
		DestinyMedium_43
		{
			isproportional only
			1
			{
				name			DestinyMedium
				tall			43
				antialias 		1
			}
		}
		DestinyMedium_72
		{
			isproportional only
			1
			{
				name			DestinyMedium
				tall			72
				antialias 		1
			}
		}

		ChakraLight_43
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			43
				antialias 		1
			}
		}

		ChakraBold_56
		{
			isproportional both
			1
			{
				name			ChakraBold
				tall			56
				antialias 		1
			}
		}

		ChakraBold_120
		{
			isproportional only
			1
			{
				name			ChakraBold
				tall			120
				antialias 		1
			}
		}
		
		ChakraBold_56_Outline
		{
			isproportional both
			1
			{
				name			ChakraBold
				tall			56
				antialias 		1
				outline			1
			}
		}

		ChakraBold_43_DropShadow
		{
			isproportional only
			1
			{
				name			ChakraBold
				tall			43
				antialias 		1
				dropshadow		1
			}
		}

		ChakraBold_43
		{
			isproportional only
			1
			{
				name			ChakraBold
				tall			43
				antialias 		1
			}
		}

		ChakraBold_36
		{
			isproportional only
			1
			{
				name			ChakraBold
				tall			36
				antialias 		1
			}
		}

		ChakraBold_27
		{
			isproportional only
			1
			{
				name			ChakraBold
				tall			27
				antialias 		1
			}
		}

		ChakraLight_36
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			36
				antialias 		1
			}
		}

		ChakraLight_32
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			32
				antialias 		1
			}
		}

		ChakraLight_27
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			27
				antialias 		1
			}
		}

		ChakraLight_27_ShadowGlow
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			27
				antialias 		1
				shadowglow		7
			}
		}

		ChakraLight_27_Italic
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			27
				antialias 		1
				italic			1
			}
		}

		ChakraLight_24
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			24
				antialias 		1
			}
		}

		ChakraLight_18
		{
			isproportional only
			1
			{
				name			ChakraLight
				tall			18
				antialias 		1
			}
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
		BoxBorder
		{
			inset 	"32 32 32 32"
			bordertype				scalable_image
			//backgroundtype			2

			image					"ui/box"
			src_corner_height		32				// pixels inside the image
			src_corner_width		32
			draw_corner_width		32				// screen size of the corners ( and sides ), proportional
			draw_corner_height 		32
		}
		WhiteBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				1
				{
					color 	"255 255 255 50"
					offset	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	"255 255 255 50"
					offset	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	"255 255 255 50"
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	"255 255 255 50"
					offset 	"0 0"
				}
			}
		}
	}
}
