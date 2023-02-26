untyped
global function Destiny2_Init

struct
{
    entity selectedWeapon
    AnnouncementData toDisplay
    array<OffhandCooldownData&> cooldownData
} file

void function Destiny2_Init()
{
    AddCallback_OnSelectedWeaponChanged( OnSelectedWeaponChanged )
    HudRevamp_AddLayout( "destiny2",
    HudRevamp_Update,
    Announcement )
    OffhandCooldownData data
    file.cooldownData.append(data)
    file.cooldownData.append(clone data)
    file.cooldownData.append(clone data)

    //if(player.GetMainWeapons().length < 3){
        //Hud_SetVisible( HudElement("DestinyTertiarySlot", panel), false )
    //}
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


float d2_healthbar_opacity = 1.0
bool d2_healthbar_needs_update = false
bool d2_healthbar_updating = false

void function HudRevamp_Update( var panel )
{
    entity player = GetLocalClientPlayer()
    EarnObject earnGoal = PlayerEarnMeter_GetGoal( player )
    EarnObject earnReward = PlayerEarnMeter_GetReward( player )
    if (!IsValid(file.selectedWeapon) || file.selectedWeapon.GetWeaponOwner() != GetLocalClientPlayer())
        return
    HudElement("WeaponIcon", panel).SetImage(
        GetWeaponInfoFileKeyFieldAsset_Global( file.selectedWeapon.GetWeaponClassName(), "hud_icon" )
    )

    var SuperBar = HudElement("SuperBar", panel)
    var SuperIcon_BG = HudElement("SuperImageBG", panel)
    var SuperIcon = HudElement("SuperImage", panel)

    //printt("earngoal.buildingImage")
    //printt(earnGoal.buildingImage)

    SuperIcon.SetImage( earnGoal.buildingImage )


    Hud_SetBarProgress( HudElement("HealthBar", panel), GetHealthFrac(player) )
    Hud_SetBarProgress( SuperBar, PlayerEarnMeter_GetEarnedFrac(player) )
    if(PlayerEarnMeter_GetEarnedFrac(player) >= 1){
        Hud_SetColor( SuperBar, 255, 255, 0, 255 )
        Hud_SetColor( SuperIcon_BG, 255, 255, 0, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 0, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_full.vmt")
    }
    else{
        Hud_SetColor( SuperBar, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon_BG, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 255, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_empty.vmt")
    }

    if(GetHealthFrac(player) < 1){
        d2_healthbar_opacity = 1
    }
    else{
        if(d2_healthbar_opacity > 0){
            d2_healthbar_opacity -= 0.01
        }
        else{
            d2_healthbar_opacity = 0
        }
    }

    Hud_SetColor( HudElement("HealthBar", panel), 255, 255, 255, d2_healthbar_opacity * 255 )


    int shield = 0
    int maxShield = 0
    if (player.IsTitan() && IsValid(player.GetTitanSoul()))
        shield = player.GetTitanSoul().GetShieldHealth()
    else
        shield = player.GetShieldHealth()
    if (player.IsTitan() && IsValid(player.GetTitanSoul()))
        maxShield = player.GetTitanSoul().GetShieldHealthMax()
    else
        maxShield = player.GetShieldHealthMax()

    Hud_SetColor( HudElement("SHBar", panel), 0, 255, 0, 255 )
    Hud_SetVisible( HudElement("SHBar", panel), false )

    if (shield > 0)
    {
        Hud_SetBarProgress( HudElement("SHBar", panel), float(shield) / float(maxShield) )

    }
    else Hud_SetBarProgress( HudElement("SHBar", panel), 0.0 )
    try
    {
        Hud_SetBarProgress( HudElement("HDBar", panel), player.GetPlayerNetFloat("hardDamage") / 100.0 )


        Hud_SetColor( HudElement("HDBar", panel), 255, 0, 0, 255 )
    }
    catch (ex)
    {}
    Hud_SetText( HudElement("Health", panel), "") //(GetHealthFrac(player)).tostring() )
    Hud_SetText( HudElement("MaxHealth", panel), "")//player.GetMaxHealth().tostring() )
    int weaponIndex = 0
    array<entity> weapons = player.GetMainWeapons()
    foreach (int index, entity weapon in weapons)
        if (weapon == file.selectedWeapon)
        {
            weaponIndex = index
            break
        }
    bool hasSecondary = weapons.len() > 1
    bool hasTertiary = weapons.len() > 2

    var weaponIcon1 = HudElement("WeaponIcon1", panel)
    var weaponIcon2 = HudElement("WeaponIcon2", panel)
    var stockpileCount1 = HudElement("AmmoStockpileSecondary", panel)
    var stockpileCount2 = HudElement("AmmoStockpileTertiary", panel)

    var weaponRibbon0 = HudElement("DestinyPrimaryRibbon", panel)
    var weaponRibbon1 = HudElement("DestinySecondaryRibbon", panel)
    var weaponRibbon2 = HudElement("DestinyTertiaryRibbon", panel)


    Hud_SetVisible( stockpileCount1, hasSecondary )
    Hud_SetVisible( stockpileCount2, hasTertiary )
    Hud_SetVisible( HudElement("DestinySecondarySlot", panel), hasSecondary )
    Hud_SetVisible( HudElement("DestinySecondaryRibbon", panel), hasSecondary )
    Hud_SetVisible( HudElement("DestinySecondarySlotDividerRibbon", panel), hasTertiary )
    Hud_SetVisible( HudElement("DestinyTertiarySlot", panel), hasTertiary )
    Hud_SetVisible( HudElement("DestinyTertiaryRibbon", panel), hasTertiary )



    if (weaponIndex == 0)
    {
        SetColorForWeaponType( weaponRibbon0, weapons[0] )
        if(hasSecondary) Hud_SetText( stockpileCount1, GetStowedAmmoString(weapons[1]) )
        if(hasTertiary) Hud_SetText( stockpileCount2, GetStowedAmmoString(weapons[2]) )
        if (weapons.len() > 1) {

            weaponIcon1.SetColor( 200, 200, 200, 175 )
            weaponIcon1.SetImage(
                GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[1].GetWeaponClassName(), weapons[1].GetMods(), "hud_icon" )
            )
            SetColorForWeaponType( weaponRibbon1, weapons[1] )

        }
        else weaponIcon1.SetColor( 0, 0, 0, 0 )
        if (weapons.len() > 2) {
            weaponIcon2.SetColor( 200, 200, 200, 175 )
            weaponIcon2.SetImage(
                GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[2].GetWeaponClassName(), weapons[2].GetMods(), "hud_icon" )
            )
            SetColorForWeaponType( weaponRibbon2, weapons[2] )
        }
        else weaponIcon2.SetColor( 0, 0, 0, 0 )

    }
    else if (weaponIndex == 1)
    {
        SetColorForWeaponType( weaponRibbon0, weapons[1] )
        SetColorForWeaponType( weaponRibbon1, weapons[0] )
        if(hasSecondary) Hud_SetText( stockpileCount1, GetStowedAmmoString(weapons[0]) )
        if(hasTertiary) Hud_SetText( stockpileCount2, GetStowedAmmoString(weapons[2]) )
        weaponIcon1.SetColor( 200, 200, 200, 175 )
        weaponIcon1.SetImage(
            GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[0].GetWeaponClassName(), weapons[0].GetMods(), "hud_icon" )
        )
        if (weapons.len() > 2) {
            weaponIcon2.SetColor( 200, 200, 200, 175 )
            weaponIcon2.SetImage(
                GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[2].GetWeaponClassName(), weapons[2].GetMods(), "hud_icon" )
            )
            SetColorForWeaponType( weaponRibbon2, weapons[2] )
        }
        else weaponIcon2.SetColor( 0, 0, 0, 0 )

    }
    else if (weaponIndex == 2)
    {
        if(hasSecondary) Hud_SetText( stockpileCount1, GetStowedAmmoString(weapons[0]) )
        if(hasTertiary) Hud_SetText( stockpileCount2, GetStowedAmmoString(weapons[1]) )
        weaponIcon1.SetColor( 200, 200, 200, 175 )
        weaponIcon2.SetColor( 200, 200, 200, 175 )
        weaponIcon1.SetImage(
            GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[0].GetWeaponClassName(), weapons[0].GetMods(), "hud_icon" )
        )
        weaponIcon2.SetImage(
            GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapons[1].GetWeaponClassName(), weapons[1].GetMods(), "hud_icon" )
        )
        SetColorForWeaponType( weaponRibbon0, weapons[2] )
        SetColorForWeaponType( weaponRibbon1, weapons[0] )
        SetColorForWeaponType( weaponRibbon2, weapons[1] )
    }

    var ammoCount = HudElement("AmmoCount", panel)
    var stockpileCount0 = HudElement("AmmoStockpilePrimary", panel)


    bool displayStockpile = (!file.selectedWeapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile) &&
    file.selectedWeapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) > 0) ||
    file.selectedWeapon.GetLifetimeShotsRemaining() > -1

    Hud_SetVisible( stockpileCount0, true )
    Hud_SetVisible( ammoCount, true )

    Hud_SetText( ammoCount, GetAmmoString(file.selectedWeapon) )
    if (displayStockpile)
    {
        Hud_SetText( stockpileCount0, GetStockpileString(file.selectedWeapon) )
    }
    else{
        if (!file.selectedWeapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile) || file.selectedWeapon.GetLifetimeShotsRemaining() > -1){
            Hud_SetText( stockpileCount0, "0" )
        }
        else{
            Hud_SetText( stockpileCount0, "∞" )
        }


    }

    array<entity> offhands = [ player.GetOffhandWeapon(0), player.GetOffhandWeapon(1), player.GetOffhandWeapon(2) ]

    for (int i = 0; i < offhands.len(); i++)
    {
        if (!IsValid(offhands[i])) {
            offhands.remove(i)
            i--
        }
    }

    Hud_SetVisible(HudElement( "OffhandRight",  panel ), offhands.len() > 0)
    Hud_SetVisible(HudElement( "OffhandCenter", panel ), offhands.len() > 1)
    Hud_SetVisible(HudElement( "OffhandLeft",   panel ), offhands.len() > 2)

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
    var _BG = Hud_GetChild( panel, "BG" )
    var chargeBox = Hud_GetChild( panel, "SecondChargeBox" )
    var icon = Hud_GetChild( panel, "Icon" )
    var chargeCount = Hud_GetChild( panel, "Charges" )

    Hud_SetImage( icon, GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapon.GetWeaponClassName(), weapon.GetMods(), "hud_icon" ) )

    if(file.cooldownData[index].readyCharges >= 1 && file.cooldownData[index].charges >= 2){
        Hud_SetVisible( chargeBox,  true)
    }
    else{
        Hud_SetVisible( chargeBox,  false)
    }


    //Hud_SetBarProgress( circleBar, file.cooldownData[index].nextChargeFrac )
        //Hud_SetText( chargeCount, file.cooldownData[index].readyCharges.tostring() )

        //Hud_SetBarProgress( BG, file.cooldownData[index].nextChargeFrac )
    if(file.cooldownData[index].nextChargeFrac <= 0 && file.cooldownData[index].readyCharges == file.cooldownData[index].charges) {
        Hud_SetColor(_BG, 255, 150, 50, 255)
        Hud_SetColor(BG, 100, 100, 100, 175)
    }
    else{
        Hud_SetColor(_BG, 50, 50, 50, 150)
        Hud_SetColor(BG, 150, 150, 150, 100)
    }
    //Hud_SetText( chargeCount, file.cooldownData[index].readyCharges.tostring() + "|" + file.cooldownData[index].charges.tostring() )
    Hud_SetText( chargeCount, "" )
    Hud_SetBarProgress( BG, file.cooldownData[index].nextChargeFrac )
}

string function GetAmmoString( entity weapon )
{
	string result

    if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_clip) ||
        weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile) &&
        weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) < 1)
        return "--"

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
    if (weapon.GetWeaponSettingFloat(eWeaponVar.regen_ammo_refill_rate) > 0.0)
    {
        return weapon.GetLifetimeShotsRemaining().tostring()
    }
	return weapon.GetWeaponPrimaryAmmoCount().tostring()
}

string function GetStowedAmmoString( entity weapon)
{
    //thanks elad
    if (weapon.GetLifetimeShotsRemaining() > -1)
    {
        return weapon.GetLifetimeShotsRemaining().tostring()
    }
    if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile))
    {
        return "∞"
    }
    if (file.selectedWeapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) <= 0)
    {
        return weapon.GetWeaponPrimaryAmmoCount().tostring()
    }
    return (weapon.GetWeaponPrimaryAmmoCount() + weapon.GetWeaponPrimaryClipCount()).tostring()
}

void function SetColorForWeaponType( var element, entity weapon )
{
    if (!IsValid(weapon))
        return
    switch (weapon.GetWeaponInfoFileKeyField( "menu_category" ))
    {
        case "at":
            element.SetColor(178, 134, 255, 255)
            break
        case "sniper":
        case "shotgun":
        case "special":
        case "lmg":
            element.SetColor(122, 244, 139, 255)
            break
        default:
            element.SetColor(255, 255, 255, 255)
    }
}