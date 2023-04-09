untyped
global function Destiny2_Init
global function HUDMenuOpenState

const array<int> ENEMY_BAR_COLOR = [200, 150, 50, 255]
const array<int> FRIENDLY_BAR_COLOR = [70, 130, 255, 255]
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
    entity hitEnt
    bool isMenuOpen
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

void function HudRevamp_D2_SetFriendlyScoreObjectNotWinningCol(var obj){
    Hud_SetColor(obj, 80, 120, 176, 63.75)
}
void function HudRevamp_D2_SetFriendlyScoreObjectWinningCol(var obj){
    Hud_SetColor(obj, 80, 120, 176, 255)
}
void function HudRevamp_D2_SetEnemyScoreObjectNotWinningCol(var obj){
    Hud_SetColor(obj, 173, 52, 43, 63.75)
}
void function HudRevamp_D2_SetEnemyScoreObjectWinningCol(var obj){
    Hud_SetColor(obj, 173, 52, 43, 255)
}

void function HudRevamp_D2_Gamestate_Update(var gamestate, entity player){
    //this logic is safe to run every frame, i know this because respawn does it
    var friendly_score_number = Hud_GetChild(gamestate, "Team0_ScoreCount")
    var friendly_score_box = Hud_GetChild(gamestate, "Team0_Score")
    var enemy_score_number = Hud_GetChild(gamestate, "Team1_ScoreCount")
    var enemy_score_box = Hud_GetChild(gamestate, "Team1_Score")
    var friendly_score_bar = Hud_GetChild(gamestate, "Team0_ScoreBar")
    var enemy_score_bar = Hud_GetChild(gamestate, "Team1_ScoreBar")
    var clock = Hud_GetChild(gamestate, "Round_Timer")

    var friendly_score_bar_winning = Hud_GetChild(gamestate, "Team0_ScoreBar_Border_Winning")
    var friendly_score_bar_border = Hud_GetChild(gamestate, "Team0_ScoreBar_Border")
    var friendly_score_border = Hud_GetChild(gamestate, "Team0_Score_Border")
    var enemy_score_bar_winning = Hud_GetChild(gamestate, "Team1_ScoreBar_Border_Winning")
    var enemy_score_bar_border = Hud_GetChild(gamestate, "Team1_ScoreBar_Border")
    var enemy_score_border = Hud_GetChild(gamestate, "Team1_Score_Border")

    float endTime
	if ( IsRoundBased() )
	{
        //line 351 in vscripts/client/cl_gamestate.nut
		endTime = expect float( level.nv.roundEndTime)
	}
	else
	{
      endTime = expect float( level.nv.gameEndTime )
	}

    float score_limit = float(GetScoreLimit_FromPlaylist())
    int friendlyTeam = player.GetTeam()
    int enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

    int friendly_score = GameRules_GetTeamScore( friendlyTeam )
    int enemy_score    = GameRules_GetTeamScore( enemyTeam )

    int seconds = int(endTime - Time()) % 60
    int mins = int(floor(int(endTime - Time()) / 60))

    Hud_SetText(clock, (mins + ":" + (seconds < 10 ? "0" : "") + seconds))

    if(friendly_score > enemy_score){
        HudRevamp_D2_SetFriendlyScoreObjectWinningCol(friendly_score_box)
        Hud_SetVisible(friendly_score_bar_winning, true)
        Hud_SetColor(friendly_score_bar_border, 255, 255, 255, 255)
        Hud_SetColor(friendly_score_border, 255, 255, 255, 255)
    }
    else{
        HudRevamp_D2_SetFriendlyScoreObjectNotWinningCol(friendly_score_box)
        Hud_SetVisible(friendly_score_bar_winning, false)
        Hud_SetColor(friendly_score_bar_border, 255, 255, 255, 63.75)
        Hud_SetColor(friendly_score_border, 255, 255, 255, 63.75)
    }

    if(enemy_score > friendly_score){
        HudRevamp_D2_SetEnemyScoreObjectWinningCol(enemy_score_box)
        Hud_SetVisible(enemy_score_bar_winning, true)
        Hud_SetColor(enemy_score_bar_border, 255, 255, 255, 255)
        Hud_SetColor(enemy_score_border, 255, 255, 255, 255)
    }
    else{
        HudRevamp_D2_SetEnemyScoreObjectNotWinningCol(enemy_score_box)
        Hud_SetVisible(enemy_score_bar_winning, false)
        Hud_SetColor(enemy_score_bar_border, 255, 255, 255, 63.75)
        Hud_SetColor(enemy_score_border, 255, 255, 255, 63.75)
    }




    Hud_SetVisible(enemy_score_bar_winning, enemy_score > friendly_score)

    Hud_SetText(friendly_score_number, string(friendly_score))
    Hud_SetText(enemy_score_number, string(enemy_score))
    Hud_SetBarProgress(friendly_score_bar, (float(friendly_score) / score_limit))
    Hud_SetBarProgress(enemy_score_bar, (float(enemy_score) / score_limit))

    array<entity> friendly_players = GetPlayerArrayOfTeam( friendlyTeam )
    array<entity> enemy_players    = GetPlayerArrayOfTeam( enemyTeam )

    //disable UI for players that aren't joined
    for(int i = friendly_players.len(); i < 8; i++){
        string player_ui_target = "Team0_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, false)
    }
    for(int i = enemy_players.len(); i < 8; i++){
        string player_ui_target = "Team1_Player" + string(i)
        var player_ui = Hud_GetChild(gamestate, player_ui_target)
        Hud_SetVisible(player_ui, false)
    }

    //update UI for players that are joined
    for(int i = 0; i < min(8,friendly_players.len()); i++){
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
    for(int i = 0; i < min(8,enemy_players.len()); i++){
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
    //HudElement("Screen", panel).SetColor(0, 0,0,127)
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
    if (IsSingleplayer())
        d2_healthbar_opacity = 1.0
    if (player.IsTitan())
        d2_healthbar_opacity = 0.0
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
    vector attackDir = AnglesToForward( player.CameraAngles() )
    if (IsValid(player.GetActiveWeapon()))
        attackDir = player.GetActiveWeapon().GetAttackDirection()

    TraceResults result = TraceLine( player.CameraPosition(), player.CameraPosition() + attackDir * 8192, [ player ],
        TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

    file.hitEnt = result.hitEnt

    entity npc = file.hitEnt
    if (IsValid( npc ))
    {
        if (npc.IsNPC())
        {
            if (npc.IsTitan())
            {
                if (!file.titanHealthbarEntities.contains(npc))
                {
                    thread TitanHealthBar( npc )
                }
            }
            else
            {
                if (!file.healthbarEntities.contains(npc))
                {
                    thread HealthBar( npc )
                }
            }
        }
        else if (npc.IsPlayer())
        {
            // they are an npc. shut up
            if (npc.IsTitan())
            {
                if (!file.titanHealthbarEntities.contains(npc))
                {
                    thread TitanHealthBar( npc )
                }
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

    // allocate healthbar
    int index = file.healthbarIndex++
    if (file.healthbarIndex > HEALTHBAR_INSTANCES)
        file.healthbarIndex = 0

    if (IsValid(file.healthbarEntities[index]))
    {
        file.healthbarEntities[index].Signal("EndTargetInfo")
    }
    file.healthbarEntities[index] = ent

    var healthbar = Hud_GetChild( HudElement("Healthbars"), "Healthbar" + index )
    Hud_SetVisible( healthbar, true )

    OnThreadEnd(
        function() : ( ent, index, healthbar )
		{
            Hud_SetVisible( healthbar, false )
		}
    )

    // set title
    string title = GetHealthbarTitle( ent )
    Hud_SetText( Hud_GetChild( healthbar, "Name" ), title )

    // set icon
    var rui = Hud_GetRui( Hud_GetChild( healthbar, "Icon" ) )
    RuiSetImage( rui, "basicImage", HUDGetIconForAI( ent ) )

    // alpha vars
    float alpha = 0.0
    float lastLookTime = Time()
    float lastFrameTime = Time()

    // children
    var bar = Hud_GetChild( healthbar, "Bar" )
    while (true)
    {
        Hud_SetVisible( healthbar, !file.isMenuOpen )

        // check team
        entity player = IsValid(GetLocalViewPlayer()) ? GetLocalViewPlayer() : GetLocalClientPlayer()
        bool isFriendly = player.GetTeam() == ent.GetTeam()

        // check if we're being looked at
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent && IsAlive(ent))
            lastLookTime = Time()

        // set alpha
        if (Time() - lastLookTime > 0.5)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        healthbar.SetPanelAlpha( alpha * 255.0 )
        RuiSetFloat( rui, "basicImageAlpha", alpha )

        // calculate screen pos
        vector mins = ent.GetBoundingMins()
        vector maxs = ent.GetBoundingMaxs()
        vector worldPos = ent.GetOrigin() + <(mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 8>

        vector screenPos = WorldToScreenPos( worldPos )
        vector size = <Hud_GetWidth( healthbar ), Hud_GetHeight( healthbar ), 0>

        Hud_SetPos( healthbar, screenPos.x - size.x / 2, screenPos.y - size.y )

        // set health frac
        // TODO: set shield frac
        Hud_SetBarProgress( bar, GetHealthFrac(ent) )

        lastFrameTime = Time()
        wait 0
    }
}

asset function HUDGetIconForAI( entity npc )
{
    string classname = ""
    if (npc.IsNPC())
        classname = npc.GetAISettingsName()
    if (npc.IsPlayer())
        classname = npc.GetPlayerSettings()
	switch( classname )
	{
		case "npc_titan":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_titan"
		case "npc_soldier":
        return $"rui/hud/gametype_icons/bounty_hunt/bh_grunt"
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

void function HUDMenuOpenState( int state )
{
    printt("HUDMENUOPENSTATE", state)
    file.isMenuOpen = (state != 0)
}

void function TitanHealthBar( entity ent )
{
    ent.EndSignal( "EndTargetInfo" )
    ent.EndSignal( "OnDestroy" )

    // allocate healthbar
    int index = file.titanHealthbarIndex++
    if (file.titanHealthbarIndex > HEALTHBAR_INSTANCES)
        file.titanHealthbarIndex = 0
    if (IsValid(file.titanHealthbarEntities[index]))
    {
        file.titanHealthbarEntities[index].Signal("EndTargetInfo")
    }
    file.titanHealthbarEntities[index] = ent

    var healthbar = Hud_GetChild( HudElement("Healthbars"), "HealthbarChampion" + index )
    Hud_SetVisible( healthbar, true )

    OnThreadEnd(
        function() : ( ent, index, healthbar )
		{
            Hud_SetVisible( healthbar, false )
		}
    )

    // set title
    string title = GetHealthbarTitle( ent )
    Hud_SetText( Hud_GetChild( healthbar, "Name" ), title )

    // alpha variables
    float alpha = 0.0
    float lastLookTime = Time()
    float lastFrameTime = Time()

    // children
    var bar = Hud_GetChild( healthbar, "Bar" )
    var triangle = Hud_GetChild( healthbar, "Icon" )
    var barBG = Hud_GetChild( healthbar, "BG" )
    while (true)
    {
        Hud_SetVisible( healthbar, !file.isMenuOpen )

        // check team
        entity player = IsValid(GetLocalViewPlayer()) ? GetLocalViewPlayer() : GetLocalClientPlayer()
        bool isFriendly = player.GetTeam() == ent.GetTeam()

        if (isFriendly)
        {
            triangle.SetImage( $"ui/destiny2/ChampionTriangle" )
            bar.SetColor( FRIENDLY_BAR_COLOR )
        }
        else
        {
            triangle.SetImage( $"ui/destiny2/ChampionTriangleEnemy" )
            bar.SetColor( ENEMY_BAR_COLOR )
        }

        // check if we're being looked at
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent && IsAlive(ent))
            lastLookTime = Time()

        // alpha calculation
        if (Time() - lastLookTime > 0.5)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        // P.S. no rui here since we don't use basic_images
        healthbar.SetPanelAlpha( alpha * 255.0 )

        // calculate bar width with segment count
        int baseBarWidth = 278
        float segments = ent.GetMaxHealth() / 2500.0
        int width = int(segments) * 40
        if (ent.GetMaxHealth() % 2500 == 0)
            width -= 2
        else width += int((segments % 1.0) * 38)

        Hud_SetWidth( bar, width )
        Hud_SetWidth( barBG, width )

        // calculate screen pos
        vector mins = ent.GetBoundingMins()
        vector maxs = ent.GetBoundingMaxs()
        vector worldPos = ent.GetOrigin() + <(mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 8>

        vector screenPos = WorldToScreenPos( worldPos )
        vector size = <Hud_GetWidth( healthbar ), Hud_GetHeight( healthbar ), 0>

        Hud_SetPos( healthbar, screenPos.x - (size.x - baseBarWidth + width) / 2, screenPos.y - size.y )

        // set health frac
        // TODO: set shield frac
        Hud_SetBarProgress( bar, GetHealthFrac(ent) )

        lastFrameTime = Time()
        wait 0
    }
}

string function GetHealthbarTitle( entity ent )
{
    string title = ent.GetTitleForUI()
    if (ent.IsNPC())
    {
        title = ent.GetTitleForUI()
        if (title == "")
            title = expect string( ent.Dev_GetAISettingByKeyField( "title" ) )
        if (IsValid(ent.GetBossPlayer()))
        {
            return ent.GetBossPlayerName() + "'s " + Localize( title )
        }
    }
    if (ent.IsPlayer())
    {
        print("IS PLAYER")
        if (ent.IsTitan())
            return ent.GetPlayerName() + " (" + Localize( title ) + ")"

        return ent.GetPlayerName()
    }

    return title
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

    if(file.cooldownData[index].readyCharges >= 1) {
        Hud_SetColor(_BG, 255, 150, 50, 255)
        Hud_SetColor(BG, 200, 200, 200, 100)
    }
    else{
        Hud_SetColor(_BG, 50, 50, 50, 150)
        Hud_SetColor(BG, 200, 200, 200, 50)
    }

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