untyped
global function HudRevamp_Init

struct
{
    entity selectedWeapon
    AnnouncementData toDisplay
    array<OffhandCooldownData&> cooldownData
} file

void function HudRevamp_Init()
{
    AddCallback_OnSelectedWeaponChanged( OnSelectedWeaponChanged )
    HudRevamp_AddLayout( "HudRevamp",
    null,
    HudRevamp_Update,
    null,
    Announcement )
    OffhandCooldownData data
    file.cooldownData.append(data)
    file.cooldownData.append(clone data)
    file.cooldownData.append(clone data)
}

void function Announcement( var panel, AnnouncementData data )
{
    if (panel == null)
    {
        return
    }
    var icon = HudElement("AnnouncementIcon", panel)
    var title = HudElement("AnnouncementTitle", panel)
    var desc = HudElement("AnnouncementDesc", panel)
    var bg = HudElement("AnnouncementTitleBG", panel)

    OnThreadEnd( function() : (title, desc, bg, icon) {
        try
        {
            Hud_SetVisible( icon, false )
            Hud_SetVisible( title, false )
            Hud_SetVisible( desc, false )
            Hud_SetVisible( bg, false )
        }
        catch (ex)
        {
            print(ex)
        }
    })
    bool showIcon = false
    switch (data.announcementStyle)
    {
        case ANNOUNCEMENT_STYLE_QUICK:
            showIcon = data.icon != $""
            break
    }
    Hud_SetVisible( icon, showIcon )
    Hud_SetVisible( bg, true )
    Hud_SetVisible( desc, true )
    Hud_SetVisible( title, true )
    icon.SetImage( data.icon )
    print(data.icon)
    // called when the announcement needs to be interrupted. Interruption
    // means the announcement disappears IMMEDIATELY, since the next
    // announcement of higher priority is called directly after.
    clGlobal.levelEnt.EndSignal( "AnnoucementPurge" )

    Hud_SetText(title, ExpandString(Localize(data.messageText).toupper()))
    Hud_EnableKeyBindingIcons(desc)
    //Hud_EnableKeyBindingIcons(title)
    Hud_SetText(desc, CleanString(Localize(data.subText)))

    float start = Time()
    float fadeInTime = 0.5
    while ( Time() - start <= data.duration )
    {
        float fadeInFrac = min( (Time() - start) / 0.75, 1 )
        float fadeOutFrac = min( (start + data.duration - Time()) / 0.75, 1 )
        Hud_SetColor( title, 255, 255, 255, 255 * min(fadeInFrac, fadeOutFrac) )
        Hud_SetColor( desc, 255, 255, 255, 255 * min(fadeInFrac, fadeOutFrac) )
        Hud_SetColor( icon, 255, 255, 255, 255 * min(fadeInFrac, fadeOutFrac) )
        int width = int((Hud_GetWidth(HudElement("AnnouncementTitle", panel)) + 40) * min(fadeInFrac, fadeOutFrac))
        width -= width % 2
        Hud_SetWidth( bg, width )
        WaitFrame()
    }
}

void function OnSelectedWeaponChanged( entity weapon )
{
    if (weapon == null || weapon.IsWeaponOffhand())
        return
    file.selectedWeapon = weapon
}

string function CleanString( string str )
{
    string newStr = str
    newStr = StringReplace( newStr, "`0", "", true )
    newStr = StringReplace( newStr, "`1", "", true )
    newStr = StringReplace( newStr, "`2", "", true )
    print(str)
    print(newStr)
    return newStr
}
string function ExpandString( string str )
{
    string newStr = CleanString(str)
    string result = "" + newStr.slice( 0, 1 )
    for (int i = 1; i < newStr.len(); i++)
    {
        result += " " + newStr.slice( i, i + 1 )
    }
    return result
}

void function HudRevamp_Update( var panel )
{
    entity player = GetLocalClientPlayer()
    if (!IsValid(file.selectedWeapon) || file.selectedWeapon.GetWeaponOwner() != GetLocalClientPlayer())
        return
    HudElement("WeaponIcon", panel).SetImage(
        GetWeaponInfoFileKeyFieldAsset_Global( file.selectedWeapon.GetWeaponClassName(), "hud_icon" )
    )

    Hud_SetBarProgress( HudElement("Bar", panel), GetHealthFrac(player) )
    int shield = 0
    int maxShield = 0
    if (player.IsTitan() && IsValid(player.GetTitanSoul()))
        shield = player.GetTitanSoul().GetShieldHealth()
    else shield = player.GetShieldHealth()
    if (player.IsTitan() && IsValid(player.GetTitanSoul()))
        maxShield = player.GetTitanSoul().GetShieldHealthMax()
    else maxShield = player.GetShieldHealthMax()

    if (shield > 0)
    {
        Hud_SetBarProgress( HudElement("SHBar", panel), float(shield) / float(maxShield) )
    }
    else Hud_SetBarProgress( HudElement("SHBar", panel), 0.0 )

    Hud_SetText( HudElement("Health", panel), (player.GetHealth() + shield).tostring() )
    Hud_SetText( HudElement("MaxHealth", panel), player.GetMaxHealth().tostring() )
    int weaponIndex = 0
    array<entity> weapons = player.GetMainWeapons()
    foreach (int index, entity weapon in weapons)
        if (weapon == file.selectedWeapon)
        {
            weaponIndex = index
            break
        }

    var ammoCount = HudElement("AmmoCount", panel)
    var stockpileCount = HudElement("AmmoStockpile", panel)

    array<var> weaponLabels = [HudElement("Weapon3Label", panel), 
        HudElement("Weapon2Label", panel), HudElement("Weapon1Label", panel)]
    int j = weapons.len() - 1
    for (int i = 0; i < 3; i++)
    {
        if (j >= 0)
        {
            
            switch (weapons[j].GetInventoryIndex())
            {
                case 3:
                    Hud_SetText( weaponLabels[i], "C" )
                    break
                default:
                    Hud_SetText( weaponLabels[i], (weapons[j].GetInventoryIndex() + 1).tostring() )
                    break
            }
            if (file.selectedWeapon == weapons[j])
                Hud_SetColor(weaponLabels[i], 200, 200, 200, 255)
            else Hud_SetColor(weaponLabels[i], 200, 200, 200, 127)
            j--
        }
        else Hud_SetText( weaponLabels[i], "" )
    }

    Hud_SetText( stockpileCount, GetStockpileString(file.selectedWeapon) )
    Hud_SetText( ammoCount, GetAmmoString(file.selectedWeapon) )

    array<entity> offhands = [ player.GetOffhandWeapon(0), player.GetOffhandWeapon(1), player.GetOffhandWeapon(2) ]
    for (int i = 0; i < offhands.len(); i++)
    {
        if (!IsValid(offhands[i])) {
            offhands.remove(i)
            i--
        }
    }

    Hud_SetVisible(HudElement( "OffhandRight", panel ), offhands.len() > 0)
    Hud_SetVisible(HudElement( "OffhandCenter", panel ), offhands.len() > 1)
    Hud_SetVisible(HudElement( "OffhandLeft", panel ), offhands.len() > 2)

    if (offhands.len() > 0)
        UpdateOffhand( HudElement( "OffhandRight", panel ), offhands[0], 0 )
    if (offhands.len() > 2)
    {
        UpdateOffhand( HudElement( "OffhandLeft", panel ), offhands[1], 1 )
        UpdateOffhand( HudElement( "OffhandCenter", panel ), offhands[2], 2 )
    }
    else if (offhands.len() > 1)
    {
        UpdateOffhand( HudElement( "OffhandCenter", panel ), offhands[1], 1 )
    }
}

void function UpdateOffhand( var panel, entity weapon, int index )
{
    GetOffhandCooldownData( file.cooldownData[index], weapon )
    var BG = Hud_GetChild( panel, "BGFill" )
    var BG2 = Hud_GetChild( panel, "BGFill2" )
    //var BG = Hud_GetChild( panel, "BG" )
    var icon = Hud_GetChild( panel, "Icon" )
    var circleBar = Hud_GetChild( panel, "Bar" )
    var chargeCount = Hud_GetChild( panel, "Charges" )
    Hud_SetVisible( circleBar, file.cooldownData[index].charges > 1 )
    Hud_SetVisible( chargeCount, file.cooldownData[index].charges > 1 )
    Hud_SetImage( icon, GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapon.GetWeaponClassName(), weapon.GetMods(), "hud_icon" ) )
    if (file.cooldownData[index].charges > 1)
    {
        Hud_SetBarProgress( circleBar, file.cooldownData[index].nextChargeFrac )
        Hud_SetText( chargeCount, file.cooldownData[index].readyCharges.tostring() )
    }
    if (file.cooldownData[index].readyCharges < 1)
    {
        if (file.cooldownData[index].nextChargeFrac > 0.0)
        {
            CropBar_SetProgress( BG, GraphCapped( 
                file.cooldownData[index].nextChargeFrac - 0.05, 0, 1, 0.25, 0.75 ) )
            CropBar_SetColor( BG2, 255, 255, 255, 255)
            CropBar_SetProgress( BG2, GraphCapped( 
                file.cooldownData[index].nextChargeFrac, 0, 1, 0.25, 0.75 ),
                GraphCapped( file.cooldownData[index].nextChargeFrac, 0.05, 0.1, 0.25, 0.275 ) )
        }
        else
        {
            CropBar_SetProgress( BG, 0.0 )
            CropBar_SetProgress( BG2, 0.0 )
        }
        Hud_SetColor( icon, 150, 150, 150, 127 )
    }
    else
    {
        CropBar_SetProgress( BG, 0.0 )
        CropBar_SetProgress( BG2, 0.0 )
        Hud_SetColor( icon, 255, 255, 255, 255 )
    }
}

string function GetAmmoString( entity weapon )
{
	string result

    if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_clip) ||
        weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile) &&
        weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) < 1)
        return "∞"

    if (weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) < 1)
    {
        return weapon.GetWeaponPrimaryAmmoCount().tostring()
    }
		//if (file.selectedWeapon == weapon) RuiSetFloat(file.ruis["stockpile"], "msgAlpha", 0.0)
    if (weapon.GetWeaponSettingFloat(eWeaponVar.regen_ammo_refill_rate) > 0.0)
    {
        float ammoFrac = float( weapon.GetWeaponPrimaryClipCount() ) / float( weapon.GetWeaponPrimaryClipCountMax() )

        //if (file.selectedWeapon == weapon) RuiSetString(file.ruis["ammoDisplay"], "msgText", "HEAT")

        return int(RoundToNearestInt(99.0 - (ammoFrac * 99.0))).tostring() + "%"
    }
	return weapon.GetWeaponPrimaryClipCount().tostring()
}

string function GetStockpileString( entity weapon )
{
	string result

    if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_clip))
        return "∞"
		//if (file.selectedWeapon == weapon) RuiSetFloat(file.ruis["stockpile"], "msgAlpha", 0.0)
    if (weapon.GetWeaponSettingFloat(eWeaponVar.regen_ammo_refill_rate) > 0.0)
    {
        return weapon.GetLifetimeShotsRemaining().tostring()
    }
    if (weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) <= 0)
    {
        if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile))
            return "∞"
        return weapon.GetWeaponSettingInt(eWeaponVar.ammo_stockpile_max).tostring()
    }
	return weapon.GetWeaponPrimaryAmmoCount().tostring()
}

