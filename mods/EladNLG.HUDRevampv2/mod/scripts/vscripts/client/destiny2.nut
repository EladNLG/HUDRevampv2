untyped
global function Destiny2_Init

const int HEALTHBAR_INSTANCES = 7

struct
{
    entity selectedWeapon
    AnnouncementData toDisplay
    array<OffhandCooldownData&> cooldownData
    array<entity> healthbarEntities = [ null, null, null, null, null, null, null, null ]
    array<entity> eliteHealthbarEntities = [ null, null, null, null, null, null, null, null ]
    array<entity> titanHealthbarEntities = [ null, null, null, null, null, null, null, null ]
    int healthbarIndex = 0
    int eliteHealthbarIndex = 0
    int titanHealthbarIndex = 0
    vector attackDir
    entity hitEnt
} file

void function Destiny2_Init()
{
    RegisterSignal("EndTargetInfo")
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

void function HudRevamp_D2_Gamestate_Update(var gamestate, entity player){
    //this logic is safe to run every frame, i know this because respawn does it
    var friendly_score_number = Hud_GetChild(gamestate, "Team0_ScoreCount")
    var enemy_score_number = Hud_GetChild(gamestate, "Team1_ScoreCount")
    var friendly_score_bar = Hud_GetChild(gamestate, "Team0_ScoreBar")
    var enemy_score_bar = Hud_GetChild(gamestate, "Team1_ScoreBar")

    var friendly_score_bar_winning = Hud_GetChild(gamestate, "Team0_ScoreBar_BG_Border_Winning")
    var enemy_score_bar_winning = Hud_GetChild(gamestate, "Team1_ScoreBar_BG_Border_Winning")

    float score_limit = float(GetScoreLimit_FromPlaylist())
    int friendlyTeam = player.GetTeam()
    int enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

    int friendly_score = GameRules_GetTeamScore( friendlyTeam )
    int enemy_score    = GameRules_GetTeamScore( enemyTeam )

    Hud_SetVisible(friendly_score_bar_winning, friendly_score > enemy_score)
    Hud_SetVisible(enemy_score_bar_winning, enemy_score > friendly_score)

    Hud_SetText(friendly_score_number, string(friendly_score))
    Hud_SetText(enemy_score_number, string(enemy_score))
    Hud_SetBarProgress(friendly_score_bar, (float(friendly_score) / score_limit))
    Hud_SetBarProgress(enemy_score_bar, (float(enemy_score) / score_limit))

    array<entity> friendly_players = GetPlayerArrayOfTeam( friendlyTeam )
    array<entity> enemy_players    = GetPlayerArrayOfTeam( enemyTeam )

    //disable UI for players that aren't joined
    for(int i = friendly_players.len(); i < 6; i++){
        string player_ui_target = "Team0_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, false)
    }
    for(int i = enemy_players.len(); i < 6; i++){
        string player_ui_target = "Team1_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, false)
    }

    //update UI for players that are joined
    for(int i = 0; i < friendly_players.len(); i++){
        string player_ui_target = "Team0_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, true)

        if(!IsAlive(friendly_players[i]))
            player_ui.SetImage($"ui/destiny2/gamestate/icon_dead_friendly.vmt")
        else if(friendly_players[i].IsTitan())
            player_ui.SetImage($"ui/destiny2/gamestate/icon_titan.vmt")
        else
            player_ui.SetImage($"ui/destiny2/gamestate/icon_alive.vmt")
    }
    for(int i = 0; i < enemy_players.len(); i++){
        string player_ui_target = "Team1_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, true)

        if(!IsAlive(enemy_players[i]))
            player_ui.SetImage($"ui/destiny2/gamestate/icon_dead_enemy.vmt")
        else if(enemy_players[i].IsTitan())
            player_ui.SetImage($"ui/destiny2/gamestate/icon_titan.vmt")
        else
            player_ui.SetImage($"ui/destiny2/gamestate/icon_alive.vmt")
    }


}


float lastTimeHealthNotFull = -99
bool d2_healthbar_needs_update = false
bool d2_healthbar_updating = false

void function HudRevamp_Update( var panel )
{
    entity player = GetLocalClientPlayer()
    var gamestate = HudElement("Destiny_GameStatePanel", panel)
    EarnObject earnGoal = PlayerEarnMeter_GetGoal( player )
    EarnObject earnReward = PlayerEarnMeter_GetReward( player )
    if (IsSingleplayer())
    {
        Hud_SetVisible(gamestate, false)
    }
    else{
        HudRevamp_D2_Gamestate_Update(gamestate, player)
    }
    if (!IsValid(file.selectedWeapon) || file.selectedWeapon.GetWeaponOwner() != GetLocalClientPlayer())
        return

    var SuperBar = HudElement("SuperBar", panel)
    var SuperIcon_BG = HudElement("SuperImageBG", panel)
    var SuperIcon = HudElement("SuperImage", panel)

    //printt("earngoal.buildingImage")
    //printt(earnGoal.buildingImage)


    SuperIcon.SetImage( earnGoal.buildingImage )


    Hud_SetBarProgress( HudElement("HealthBar", panel), GetHealthFrac(player) )
    Hud_SetBarProgress( SuperBar, PlayerEarnMeter_GetEarnedFrac(player) )
    if(PlayerEarnMeter_GetEarnedFrac(player) >= 1){
        Hud_SetColor( SuperBar, 223, 194, 79, 255 )
        Hud_SetColor( SuperIcon_BG, 223, 194, 79, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 255, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_full.vmt")
    }
    else{
        Hud_SetColor( SuperBar, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon_BG, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 255, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_empty.vmt")
    }

    if(GetHealthFrac(player) < 1){
        lastTimeHealthNotFull = Time()
    }

    float d2_healthbar_opacity = GraphCapped(Time() - lastTimeHealthNotFull, 0, 1, 1, 0)
    Hud_SetColor( HudElement("HealthBar", panel), 255, 255, 255, d2_healthbar_opacity * 255 )
    Hud_SetColor( HudElement("HealthBarBG", panel), 0, 0, 0, d2_healthbar_opacity * 120 )
    UpdateMainWeapons( player, panel )

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

    array<entity> offhands = [ player.GetOffhandWeapon(0), player.GetOffhandWeapon(1), player.GetOffhandWeapon(2) ]

    for (int i = 0; i < offhands.len(); i++)
    {
        if (!IsValid(offhands[i])) {
            offhands.remove(i)
            i--
        }
    }

    Hud_SetText( HudElement("Health", panel), "") //(GetHealthFrac(player)).tostring() )
    Hud_SetText( HudElement("MaxHealth", panel), "")//player.GetMaxHealth().tostring() )

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

    // TARGET INFO BULLSHIT SEND HELP PLEASE
    // also this should be illegal

    file.attackDir = player.GetActiveWeapon().GetAttackDirection()

    TraceResults tr = TraceHull( player.CameraPosition(), player.CameraPosition() + file.attackDir * 8192, < -5, -5, -5>, <5,5,5>, [ player ], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

    file.hitEnt = tr.hitEnt
    if (IsValid(tr.hitEnt))
    {
        if (tr.hitEnt.IsNPC())
        {
            entity npc = tr.hitEnt
            if (npc.IsTitan())
            {

            }
            else
            {
                if (!file.healthbarEntities.contains(npc))
                {
                    thread HealthBar( npc )
                }
            }
        }
        else if (tr.hitEnt.IsPlayer())
        {
            // they are an npc. shut up
            entity npc = tr.hitEnt
            if (npc.IsTitan())
            {

            }
            else
            {
                if (!file.healthbarEntities.contains(npc))
                {
                    thread HealthBar( npc )
                }
            }
        }
    }
}

// util function
vector function WorldToScreenPos( vector position )
{
    array pos = expect array( Hud.ToScreenSpace( position ) )

    vector result = <float( pos[0] ), float( pos[1] ), 0 >
    //print(result)
    return result
}

void function HealthBar( entity ent )
{
    ent.EndSignal( "EndTargetInfo" )
    ent.EndSignal( "OnDestroy" )
    ent.EndSignal( "OnDeath" )
    int index = file.healthbarIndex++
    if (IsValid(file.healthbarEntities[index]))
    {
        file.healthbarEntities[index].Signal("EndTargetInfo")
    }
    file.healthbarEntities[index] = ent
    if (file.healthbarIndex > HEALTHBAR_INSTANCES)
        file.healthbarIndex = 0

    var healthbar = Hud_GetChild( HudElement("Healthbars"), "Healthbar" + index )

    OnThreadEnd(
        function() : ( ent, index, healthbar )
		{
            Hud_SetVisible( healthbar, false )
		}
    )

    Hud_SetVisible( healthbar, true )
    string title = ent.GetTitleForUI()
    if (title == "" && ent.IsNPC())
    {
        title = expect string( ent.Dev_GetAISettingByKeyField( "title" ) )
    }
    Hud_SetText( Hud_GetChild( healthbar, "Name" ), title )

    float alpha = 0.0
    float lastLookTime = Time()
    float lastFrameTime = Time()
    while (true)
    {
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent)
            lastLookTime = Time()

        if (Time() - lastLookTime > 0.1)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 1)
        healthbar.SetPanelAlpha( alpha * 255.0 )

        vector mins = ent.GetBoundingMins()
        vector maxs = ent.GetBoundingMaxs()
        vector worldPos = ent.GetOrigin() + <(mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 8>

        vector screenPos = WorldToScreenPos( worldPos )
        vector size = <Hud_GetWidth( healthbar ), Hud_GetHeight( healthbar ), 0>

        Hud_SetPos( healthbar, screenPos.x - size.x / 2, screenPos.y - size.y )

        Hud_SetBarProgress( Hud_GetChild( healthbar, "Bar" ), GetHealthFrac(ent) )

        lastFrameTime = Time()
        WaitFrame()
    }
}

asset function HUDGetIconForAI( entity npc )
{
    return $"rui/hud/gametype_icons/bounty_hunt/bh_titan"
    string classname = ""
    if (npc.IsNPC())
        classname = npc.GetClassName()
	switch( classname )
	{
		case "npc_titan":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_titan"
		case "npc_soldier":
		case "npc_spectre":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_spectre"
		case "npc_stalker":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_stalker"
		case "npc_turret_mega":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_megaturret"
		case "npc_super_spectre":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_reaper"
	}
	return $""
}

void function TitanHealthBar( entity ent )
{
    ent.EndSignal( "EndTargetInfo" )
    ent.EndSignal( "OnDestroy" )
    int index = file.titanHealthbarIndex++
    if (IsValid(file.titanHealthbarEntities[index]))
    {
        file.titanHealthbarEntities[index].Signal("EndTargetInfo")
    }
    file.titanHealthbarEntities[index] = ent
    if (file.titanHealthbarIndex > HEALTHBAR_INSTANCES)
        file.titanHealthbarIndex = 0

    var healthbar = Hud_GetChild( HudElement("Healthbars"), "HealthbarChampion" + index )

    OnThreadEnd(
        function() : ( ent, index, healthbar )
		{
            Hud_SetVisible( healthbar, false )
		}
    )

    Hud_SetVisible( healthbar, true )
    string title = ent.GetTitleForUI()
    if (title == "" && ent.IsNPC())
    {
        title = expect string( ent.Dev_GetAISettingByKeyField( "title" ) )
    }
    Hud_SetText( Hud_GetChild( healthbar, "Name" ), title )
    Hud_SetImage( Hud_GetChild( healthbar, "Icon" ), HUDGetIconForAI( ent ) )

    float alpha = 0.0
    float lastLookTime = Time()
    float lastFrameTime = Time()
    while (true)
    {
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent && IsAlive(ent))
            lastLookTime = Time()

        if (Time() - lastLookTime > 0.1)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 1)
        healthbar.SetPanelAlpha( alpha * 255.0 )

        vector mins = ent.GetBoundingMins()
        vector maxs = ent.GetBoundingMaxs()
        vector worldPos = ent.GetOrigin() + <(mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 8>

        vector screenPos = WorldToScreenPos( worldPos )
        vector size = <Hud_GetWidth( healthbar ), Hud_GetHeight( healthbar ), 0>

        Hud_SetPos( healthbar, screenPos.x - size.x / 2, screenPos.y - size.y )

        Hud_SetBarProgress( Hud_GetChild( healthbar, "Bar" ), GetHealthFrac(ent) )

        lastFrameTime = Time()
        WaitFrame()
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

    if(file.cooldownData[index].charges >= 2){
        Hud_SetVisible( chargeBox,  true)
        if (file.cooldownData[index].readyCharges >= 2)
        {
            Hud_SetColor(chargeBox, 255, 150, 50, 255)
        }
        else
        {
            Hud_SetColor(chargeBox, 50, 50, 50, 150)
        }
    }
    else{
        Hud_SetVisible( chargeBox,  false)
    }


    //Hud_SetBarProgress( circleBar, file.cooldownData[index].nextChargeFrac )
        //Hud_SetText( chargeCount, file.cooldownData[index].readyCharges.tostring() )

        //Hud_SetBarProgress( BG, file.cooldownData[index].nextChargeFrac )
    if(file.cooldownData[index].readyCharges >= 1) {
        Hud_SetColor(_BG, 255, 150, 50, 255)
        Hud_SetColor(BG, 200, 200, 200, 100)
    }
    else{
        Hud_SetColor(_BG, 50, 50, 50, 150)
        Hud_SetColor(BG, 200, 200, 200, 50)
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

void function UpdateMainWeapons( entity player, var panel )
{

    int weaponIndex = 0
    array<entity> weapons = player.GetMainWeapons()
    foreach (int index, entity weapon in weapons)
        if (weapon == file.selectedWeapon)
        {
            weaponIndex = index
            break
        }
    bool hasPrimary = weapons.len() > 0
    bool hasSecondary = weapons.len() > 1
    bool hasTertiary = weapons.len() > 2

    var ammoCount = HudElement("AmmoCount", panel)
    var stockpileCount0 = HudElement("AmmoStockpilePrimary", panel)

    var weaponIcon1 = HudElement("WeaponIcon1", panel)
    var weaponIcon2 = HudElement("WeaponIcon2", panel)
    var stockpileCount1 = HudElement("AmmoStockpileSecondary", panel)
    var stockpileCount2 = HudElement("AmmoStockpileTertiary", panel)

    var weaponRibbon0 = HudElement("DestinyPrimaryRibbon", panel)
    var weaponRibbon1 = HudElement("DestinySecondaryRibbon", panel)
    var weaponRibbon2 = HudElement("DestinyTertiaryRibbon", panel)


    Hud_SetVisible( stockpileCount1, hasSecondary )
    Hud_SetVisible( stockpileCount2, hasTertiary )
    Hud_SetVisible( HudElement("DestinyPrimarySlotDividerRibbon", panel), hasPrimary )
    Hud_SetVisible( HudElement("DestinyPrimaryAmmoDividerRibbon", panel), hasPrimary )
    Hud_SetVisible( HudElement("DestinyPrimarySlot", panel), hasPrimary )
    Hud_SetVisible( HudElement("WeaponIcon", panel), hasPrimary )
    Hud_SetVisible( HudElement("DestinySecondarySlot", panel), hasSecondary )
    Hud_SetVisible( HudElement("DestinySecondaryRibbon", panel), hasSecondary )
    Hud_SetVisible( HudElement("DestinySecondarySlotDividerRibbon", panel), hasTertiary )
    Hud_SetVisible( HudElement("DestinyTertiarySlot", panel), hasTertiary )
    Hud_SetVisible( HudElement("DestinyTertiaryRibbon", panel), hasTertiary )

    Hud_SetVisible(weaponRibbon0, hasPrimary)
    Hud_SetVisible(ammoCount, hasPrimary)
    Hud_SetVisible(stockpileCount0, hasPrimary)

    if (!hasPrimary)
        return

    HudElement("WeaponIcon", panel).SetImage(
        GetWeaponInfoFileKeyFieldAsset_Global( file.selectedWeapon.GetWeaponClassName(), "hud_icon" )
    )

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
}