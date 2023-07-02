untyped
global function HudRevamp_Init

const int HEALTHBAR_INSTANCES = 7
const array<int> INVULNERABLE_BAR_COLOR = [127, 127, 127, 255]
const array<int> ENEMY_TITAN_BAR_COLOR = [200, 50, 50, 255]
const array<int> ENEMY_BAR_COLOR = [200, 50, 50, 255]
const array<int> FRIENDLY_BAR_COLOR = [70, 130, 255, 255]

struct
{
    entity selectedWeapon
    AnnouncementData toDisplay
    array<OffhandCooldownData&> cooldownData

    array<entity> healthbarEntities = [ null, null, null, null, null, null, null, null ]
    array<entity> titanHealthbarEntities = [ null, null, null, null, null, null, null, null ]
    entity hitEnt
    int healthbarIndex = 0
    int titanHealthbarIndex = 0

    EarnObject earnGoal
    EarnObject earnReward
} file

void function HudRevamp_Init()
{
    AddCallback_OnSelectedWeaponChanged( OnSelectedWeaponChanged )
    HudRevamp_AddLayout( "HudRevamp",
    null,
    HudRevamp_Update,
    HudRevamp_FlatUpdate,
    Announcement )
    OffhandCooldownData data
    file.cooldownData.append(data)
    file.cooldownData.append(clone data)
    file.cooldownData.append(clone data)
}

void function HudRevamp_FlatUpdate( var panel )
{
    entity player = GetLocalViewPlayer()

    // GAMESTATE
    Hud_SetVisible( HudElement("GameState", panel), !IsSingleplayer() )
    if (!IsSingleplayer())
        GameState_Update( player, HudElement("GameState", panel) )
    // TEAM 1 STATUS
    
    //Hud_SetBarProgress()

    // HEALTHBAR CHECKS
    // side note - mem leak. can't fix because traceline creates a new instance of
    // the traceresults stack every time it's called :(
    // TARGET INFO BULLSHIT SEND HELP PLEASE
    // also this should be illegal
    vector attackDir = AnglesToForward( player.CameraAngles() )
    if (IsValid(player.GetActiveWeapon()) && player.GetActiveWeapon().GetWeaponOwner() == player)
        attackDir = player.GetActiveWeapon().GetAttackDirection()
    TraceResults results = TraceLine( player.CameraPosition(), player.CameraPosition() + attackDir * 8192, [ player ],
        TRACE_MASK_BLOCKLOS | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
    
    file.hitEnt = results.hitEnt
    string entities = "ents: [ "
    if (IsValid( results.hitEnt ))
    {
        if (results.hitEnt.IsNPC())
        {
            if (results.hitEnt.IsTitan())
            {
                if (!file.titanHealthbarEntities.contains(results.hitEnt))
                {
                    thread TitanHealthBar( panel, results.hitEnt )
                }
            }
            else
            {
                if (!file.healthbarEntities.contains(results.hitEnt))
                {
                    thread HealthBar( panel, results.hitEnt )
                }
            }
        }
        else if (results.hitEnt.IsPlayer())
        {
            if (results.hitEnt.IsTitan())
            {
                if (!file.titanHealthbarEntities.contains(results.hitEnt))
                {
                    thread TitanHealthBar( panel, results.hitEnt )
                }
            }
            else
            {
                if (!file.healthbarEntities.contains(results.hitEnt))
                {
                    thread HealthBar( panel, results.hitEnt )
                }
            }
        }
    }
}

entity function GetTopCompetitor( int team )
{
	array<entity> players = GetPlayerArrayOfEnemies( team )

	entity topCompetitor
	foreach ( player in players )
	{
		if ( !topCompetitor || (GameRules_GetTeamScore( player.GetTeam()) ) > GameRules_GetTeamScore( topCompetitor.GetTeam()) )
			topCompetitor = player
	}

	return topCompetitor
}

void function GameState_Update( entity player, var panel )
{
    int scoreLimit = GetScoreLimit_FromPlaylist()
    int friendlyTeam = player.GetTeam()
    entity topCompetitor = GetTopCompetitor( friendlyTeam )
    int enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
    if (IsValid(topCompetitor))
        enemyTeam = topCompetitor.GetTeam()

    int friendlyScore = GameRules_GetTeamScore( friendlyTeam )
    int enemyScore    = GameRules_GetTeamScore( enemyTeam )
    
    Hud_SetText(HudElement("ScoreFriendly", panel), string(friendlyScore))
    Hud_SetText(HudElement("ScoreEnemy", panel), string(enemyScore))
    Hud_SetBarProgress(HudElement("ScoreBarFriendly", panel), float(friendlyScore) / scoreLimit)
    Hud_SetBarProgress(HudElement("ScoreBarEnemy", panel), float(enemyScore) / scoreLimit)

    Hud_SetVisible(HudElement("TitanStatusFriendly", panel), !IsFFAGame())
    Hud_SetVisible(HudElement("TitanStatusEnemy", panel), !IsFFAGame())
    if (!IsFFAGame())
    {
        array<entity> friends = GetPlayerArrayOfTeam( friendlyTeam )
        array<entity> enemies = GetPlayerArrayOfTeam( enemyTeam )
        int friendTitans = 0
        foreach (entity friend in friends)
        {
            if ( friend.IsTitan() || IsValid( friend.GetPetTitan() ) )
                friendTitans++
        }
        int enemyTitans = 0
        foreach (entity enemy in enemies)
        {
            if ( enemy.IsTitan() || IsValid( enemy.GetPetTitan() ) )
                enemyTitans++   
        }
        var friendlyTitanBar = HudElement("TitanStatusFriendly", panel)
        var enemyTitanBar = HudElement("TitanStatusEnemy", panel)
        Hud_SetWidth( friendlyTitanBar, friends.len() * 21 - 2 + 4 )
        Hud_SetWidth( enemyTitanBar, enemies.len() * 21 - 2 + 4 )
        Hud_SetVisible( friendlyTitanBar, friends.len() > 0 )
        Hud_SetVisible( enemyTitanBar, enemies.len() > 0 )
        Hud_SetBarProgress( friendlyTitanBar, float(friendTitans) / friends.len() )
        Hud_SetBarProgress( enemyTitanBar, float(enemyTitans) / enemies.len() )
    }

    int timeLeft = int(ceil(level.nv.gameEndTime - Time()))
    if ( IsRoundBased() )
    {
        timeLeft = int(ceil(level.nv.roundEndTime - Time()))
    }
    Hud_SetText( HudElement("Timer", panel), format("%i:%02i", timeLeft / 60, timeLeft % 60))
}

vector function WorldToScreenPos( vector position )
{
    array pos = expect array( Hud.ToScreenSpace( position ) )

    vector result = <float( pos[0] ), float( pos[1] ), 0 >
    //print(result)
    return result
}

void function HealthBar( var panel, entity ent )
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

    var healthbar = Hud_GetChild( panel, "Healthbar" + index )
    Hud_SetVisible( healthbar, true )

    OnThreadEnd(
        function() : ( ent, index, healthbar )
		{
            Hud_SetVisible( healthbar, false )
            file.healthbarEntities[index] = null
		}
    )

    // set title
    string title = GetHealthbarTitle( ent )
    Hud_SetText( Hud_GetChild( healthbar, "Name" ), title )

    // alpha vars
    float alpha = 0.0
    float lastLookTime = Time()
    float lastFrameTime = Time()

    // children
    var bar = Hud_GetChild( healthbar, "Bar" )
    while (true)
    {
        if (ent.IsTitan())
        {
            file.titanHealthbarEntities[index] = null
            ent.Signal("EndTargetInfo")
        }
        
        Hud_SetVisible( healthbar, !clGlobal.isMenuOpen )

        // check team
        entity player = IsValid(GetLocalViewPlayer()) ? GetLocalViewPlayer() : GetLocalClientPlayer()
        bool isFriendly = player.GetTeam() == ent.GetTeam()

        // check if we're being looked at
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent && IsAlive(ent))
            lastLookTime = Time()

        // set alpha
        if (Time() - lastLookTime > 0.25)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        healthbar.SetPanelAlpha( alpha * 255.0 )

        if (isFriendly)
        {
            bar.SetColor( FRIENDLY_BAR_COLOR )
        }
        else
        {
            bar.SetColor( ENEMY_BAR_COLOR )
        }

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

void function TitanHealthBar( var panel, entity ent )
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

    var healthbar = Hud_GetChild( panel, "HealthbarTitan" + index )
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
    var shieldBar = Hud_GetChild( healthbar, "ShieldBar" )
    var barBG = Hud_GetChild( healthbar, "BG" )
    while (true)
    {
        if (!ent.IsTitan())
        {
            file.titanHealthbarEntities[index] = null
            ent.Signal("EndTargetInfo")
        }
        
        Hud_SetVisible( healthbar, !clGlobal.isMenuOpen )

        // check team
        entity player = IsValid(GetLocalViewPlayer()) ? GetLocalViewPlayer() : GetLocalClientPlayer()
        bool isFriendly = player.GetTeam() == ent.GetTeam()

        if (isFriendly)
        {
            bar.SetColor( FRIENDLY_BAR_COLOR )
        }
        else
        {
            bar.SetColor( ENEMY_TITAN_BAR_COLOR )
        }
        if (ent.IsInvulnerable())
        {
            bar.SetColor( INVULNERABLE_BAR_COLOR )
        }

        // check if we're being looked at
        float delta = Time() - lastFrameTime
        if (file.hitEnt == ent && IsAlive(ent))
            lastLookTime = Time()

        // alpha calculation
        if (Time() - lastLookTime > 0.25)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        healthbar.SetPanelAlpha( alpha * 255.0 )

        // calculate bar width with segment count
        int baseBarWidth = 398
        float healthPerSegment = 2500.0
        if (IsSingleplayer())
            healthPerSegment = 1500.0
        float segments = ent.GetMaxHealth() / healthPerSegment
        int width = int(segments) * 50
        entity soul = ent.GetTitanSoul()
        if (ent.GetMaxHealth() % healthPerSegment == 0)
            width -= 2
        else width += int((segments % 1.0) * 48)

        Hud_SetWidth( bar, width )
        Hud_SetWidth( shieldBar, width )
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
        Hud_SetBarProgress( shieldBar, IsValid(soul) && soul.GetShieldHealthMax() > 0.0 ? 
            float(soul.GetShieldHealth()) / float(soul.GetShieldHealthMax()) : 0.0 )

        lastFrameTime = Time()
        wait 0
    }
}
string function GetHealthbarTitle( entity ent )
{
    if (!IsValid(ent))
        return "\x1b[38;5;220mnull"
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
        if (ent.IsTitan())
            return ent.GetPlayerName() + " (" + Localize( title ) + ")"

        return ent.GetPlayerName()
    }

    return title
}

void function Announcement( var panel, var flatPanel, AnnouncementData data )
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

    array<string> args = data.optionalTextArgs
    Hud_SetText(title, ExpandString(Localize(data.messageText, args[0], args[1], args[2], args[3], args[4]).toupper()))
    Hud_EnableKeyBindingIcons(desc)
    //Hud_EnableKeyBindingIcons(title)
    args = data.optionalSubTextArgs
    Hud_SetText(desc, CleanString(Localize(data.subText, args[0], args[1], args[2], args[3], args[4])))

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

    // boosts

    float ownedFrac = PlayerEarnMeter_GetOwnedFrac( player )
    float earnedFrac = PlayerEarnMeter_GetEarnedFrac( player )
    float rewardFrac = PlayerEarnMeter_GetRewardFrac( player )
    int goalId = player.GetPlayerNetInt( EARNMETER_GOALID )
    if (player.IsTitan())
    {
        entity soul = player.GetTitanSoul()
        ownedFrac = 0.0
        earnedFrac = 0.0
        Hud_SetVisible( HudElement("TitanOwnedMeter", panel), IsValid(player.GetOffhandWeapon(3)) )
        Hud_SetVisible( HudElement("TitanEarnedMeter", panel), IsValid(player.GetOffhandWeapon(3)) )
        Hud_SetVisible( HudElement("TitanPercent", panel), IsValid(player.GetOffhandWeapon(3)) )
        Hud_SetVisible( HudElement("TitanMeterBG", panel), IsValid(player.GetOffhandWeapon(3)) )
        Hud_SetVisible( HudElement("TitanPip", panel), IsValid(player.GetOffhandWeapon(3)) )
        if (IsValid(soul))
        {
            earnedFrac = soul.GetTitanSoulNetFloat( "coreAvailableFrac" )
            if (soul.GetCoreChargeExpireTime() > Time() && soul.GetCoreChargeStartTime() < Time())
            {
                earnedFrac = GraphCapped(Time(), soul.GetCoreChargeStartTime(), soul.GetCoreChargeExpireTime(), 1, 0)
            }
        }
    }
    else if (IsValid(player.GetPetTitan()))
    {
        ownedFrac = 0.0
        earnedFrac = float(player.GetPetTitan().GetHealth()) / player.GetPetTitan().GetMaxHealth()
    }
    else
    {
        Hud_SetVisible( HudElement("TitanOwnedMeter", panel), goalId != 0 )
        Hud_SetVisible( HudElement("TitanEarnedMeter", panel), goalId != 0 )
        Hud_SetVisible( HudElement("TitanPercent", panel), goalId != 0 )
        Hud_SetVisible( HudElement("TitanMeterBG", panel), goalId != 0 )
        Hud_SetVisible( HudElement("TitanPip", panel), goalId != 0 )
    }

    SetConVarFloat( "hud_revamp_pip_rotation", rewardFrac * -360 )
    Hud_SetBarProgress( HudElement("TitanOwnedMeter", panel), ownedFrac )
    Hud_SetBarProgress( HudElement("TitanEarnedMeter", panel), earnedFrac )
    Hud_SetText( HudElement("TitanPercent", panel), int( earnedFrac * 100.0 ).tostring() )

    
    bool hasBoosts = IsMultiplayer() && player.GetPlayerNetInt("itemInventoryCount") > 0
    Hud_SetVisible(HudElement("BoostStatusLabel", panel), hasBoosts)
    Hud_SetVisible(HudElement("BoostStatus", panel), hasBoosts)
    if (hasBoosts)
        Hud_SetText(HudElement("BoostStatus", panel), player.GetPlayerNetInt("itemInventoryCount").tostring())
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
    if (weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile))
        return weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size).tostring()
	return weapon.GetWeaponPrimaryAmmoCount().tostring()
}

