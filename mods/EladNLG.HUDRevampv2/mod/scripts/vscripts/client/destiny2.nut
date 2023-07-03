untyped
global function Destiny2_Init

const array<int> INVULNERABLE_BAR_COLOR = [127, 127, 127, 255]
const array<int> ENEMY_TITAN_BAR_COLOR = [200, 150, 50, 255]
const array<int> ENEMY_BAR_COLOR = [200, 50, 50, 255]
const array<int> FRIENDLY_BAR_COLOR = [70, 130, 255, 255]
const array<int> SUBCLASS_COLOR = [230, 133, 64, 255] //Solar
//connt array<int> SUBCLASS_COLOR = [84, 64, 113, 255] //Void
//const array<int> SUBCLASS_COLOR = [114, 151, 170, 255] //Arc
const array<int> SUPER_COL_RGB = [223, 194, 79]
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
    EarnObject& earnGoal
    EarnObject& earnReward
    int goalId = 0
} file

void function Destiny2_Init()
{
    RegisterSignal("EndTargetInfo")
    AddCallback_OnSelectedWeaponChanged( OnSelectedWeaponChanged )
    HudRevamp_AddLayout( "Destiny2",
    null,
    Destiny2_Update,
    Destiny2_FlatUpdate,
    Announcement )
    OffhandCooldownData data
    file.cooldownData.append(data)
    file.cooldownData.append(clone data)
    file.cooldownData.append(clone data)

    //if(player.GetMainWeapons().length < 3){
        //Hud_SetVisible( HudElement("DestinyTertiarySlot", panel), false )
    //}
}

void function Announcement( var panel, var flatPanel, AnnouncementData data )
{
    if (panel == null)
    {
        return
    }
    var icon  = HudElement("AnnouncementIcon",     panel)
    var title = HudElement("AnnouncementTitle",    panel)
    var desc  = HudElement("AnnouncementDesc",     panel)
    var bg    = HudElement("AnnouncementTitleBG",  panel)

    //the two "curtains"
    var bg_lb = HudElement("AnnouncementTitle_LB", panel)
    var bg_rb = HudElement("AnnouncementTitle_RB", panel)

    //these are the border you actually see
    var jank_border_assist = HudElement("AnnouncementTitle_JankBorder",        panel)
    var jank_border_left   = HudElement("AnnouncementTitle_JankBorder_Left",   panel)
    var jank_border_right  = HudElement("AnnouncementTitle_JankBorder_Right",  panel)
    var jank_border_bottom = HudElement("AnnouncementTitle_JankBorder_Bottom", panel)
    var jank_border_top    = HudElement("AnnouncementTitle_JankBorder_Top",    panel)

    OnThreadEnd( function() : (title, desc, bg, icon) {
        try
        {
            Hud_SetVisible( icon,  false )
            Hud_SetVisible( title, false )
            Hud_SetVisible( desc,  false )
            Hud_SetVisible( bg,    false )
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
    Hud_SetVisible( bg,    true )
    //Hud_SetVisible( desc,  true )
    Hud_SetVisible( title, true )
    icon.SetImage( data.icon )

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

    //Hud_SetVisible(bg, false)

    Hud_SetHeight(jank_border_bottom, 4)
    Hud_SetHeight(jank_border_top,    4)
    Hud_SetWidth(jank_border_left,    4)
    Hud_SetWidth(jank_border_right,   4)

    Hud_SetWidth(jank_border_assist, (Hud_GetWidth(title) + 40))
    Hud_SetWidth(jank_border_bottom, (Hud_GetWidth(title) + 40))
    Hud_SetWidth(jank_border_top,    (Hud_GetWidth(title) + 40))

    //Here's how the D2 super animation flow goes

    //fade in:
    //first half:
    //  text not visible
    //  l/r borders sliding in from center (to create the big rectangle)
    //second half:
    //  text active
    //  l/r borders revealing the center
    ////////////////// Just vibing there
    //fade out:
    //  icon fading to 0 opacity throughout
    //  first half:
    //    text visible
    //    l/r borders sliding in from center to create rectangle again
    //  second half:
    //    text invisible
    //    l/r borders revealing center again


    Hud_SetVisible( bg_lb, true )
    Hud_SetVisible( bg_rb, true )

    float start = Time()
    float fadeInTime = 0.5
    while ( Time() - start <= data.duration )
    {
        float fadeInFrac = min( (Time() - start) / 0.75, 1 )
        float fadeOutFrac = min( (start + data.duration - Time()) / 0.75, 1 )
        float fadeInCap = min(fadeInFrac*2, 1)
        float fadeOutCap = min(fadeOutFrac*2, 1)

        float jank_frac = 0.0
        if(fadeInFrac < 1) jank_frac = fadeInFrac
        else if (fadeOutFrac < 1) jank_frac = 1 - fadeOutFrac
        else jank_frac = 1
        float jank_cap = min(jank_frac * 2,1)

        int width = int((Hud_GetWidth(title) + 40) * jank_cap)
        width -= width % 2
        Hud_SetWidth( bg, width )


        float yeah_frac = 0.0
        if(fadeInFrac < 1) yeah_frac = fadeInFrac
        else if (fadeOutFrac < 1) yeah_frac = 1 - fadeOutFrac
        else yeah_frac = 0

        if(yeah_frac <= 0.5){
            Hud_SetWidth(bg_lb, (width/2))
            Hud_SetWidth(bg_rb, (width/2))
        }
        else if(yeah_frac > 0.5){ //0.5 to 1
            Hud_SetWidth(bg_lb, (width/2) * ( 1 - ((yeah_frac - 0.5)*2)))
            Hud_SetWidth(bg_rb, (width/2) * ( 1 - ((yeah_frac - 0.5)*2)))
        }
        if(fadeInFrac == 1 && fadeOutFrac == 1){
            Hud_SetWidth(bg_lb, 1)
            Hud_SetWidth(bg_rb, 1)
        }


        if(fadeInFrac >= 0.5 && fadeOutFrac >= 0.5) Hud_SetVisible( title, true )
        else Hud_SetVisible( title, false )

        if(fadeOutFrac >= 0.5 && fadeInFrac >= 0.5){
            Hud_SetVisible(jank_border_left, true)
            Hud_SetVisible(jank_border_right, true)
            Hud_SetVisible(jank_border_top, true)
            Hud_SetVisible(jank_border_bottom, true)

        }
        else{
            Hud_SetVisible(jank_border_left, false)
            Hud_SetVisible(jank_border_right, false)
            Hud_SetVisible(jank_border_top, false)
            Hud_SetVisible(jank_border_bottom, false)
        }


        //Hud_SetColor( title, 255, 255, 255, 255 * min(fadeInFrac, fadeOutFrac) )

        Hud_SetColor(title, SUPER_COL_RGB, 255)
        Hud_SetColor(bg_lb, SUPER_COL_RGB, 255)
        Hud_SetColor(bg_rb, SUPER_COL_RGB, 255)
        Hud_SetColor(jank_border_left, SUPER_COL_RGB, 255)
        Hud_SetColor(jank_border_right, SUPER_COL_RGB, 255)
        Hud_SetColor(jank_border_top, SUPER_COL_RGB, 255)
        Hud_SetColor(jank_border_bottom, SUPER_COL_RGB, 255)
        //Hud_SetColor(bg, 0,0,0, 0)
        Hud_SetVisible(bg, false)

        //Hud_SetText(desc, "fadeIn: " + string(fadeInFrac) + "| fadeOut: " + string(fadeOutFrac) + "| time: " + string(start + data.duration - Time()))

        //Hud_SetColor( desc, 255, 255, 255, 255 * min(fadeInFrac, fadeOutFrac) )
        Hud_SetColor( icon, SUPER_COL_RGB, 150 * min(fadeInFrac, fadeOutFrac) )

        WaitFrame()
    }
    Hud_SetVisible( bg_lb, false )
    Hud_SetVisible( bg_rb, false )
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

void function HudRevamp_D2_SetGamestateClassIcon(entity player, var ui_object, bool friendly){

    if(!IsAlive(player)){
        ui_object.SetImage(friendly ? $"ui/destiny2/gamestate/icon_dead_friendly.vmt" : $"ui/destiny2/gamestate/icon_dead_enemy.vmt")
        return
    }
    switch (player.GetPlayerSettings()){

        //PILOTS


        case "pilot_geist_male":
        case "pilot_geist_female": //cloak
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/cloak")
            break
        case "pilot_medium_male":
        case "pilot_medium_female": //pulse blade
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/pulse")
            break
        case "pilot_grapple_male":
        case "pilot_grapple_female": //the only one worth using
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/grapple")
            break
        case "pilot_nomad_male":
        case "pilot_nomad_female": //crack
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/stim")
            break
        case "pilot_heavy_male":
        case "pilot_heavy_female": //a-wall
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/awall")
            break
        case "pilot_light_male":
        case "pilot_light_female": //phase shift
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/phase")
            break
        case "pilot_stalker_male":
        case "pilot_stalker_female": //holo
             ui_object.SetImage($"ui/destiny2/gamestate/pilot_classes/holo")
            break

        //TITANS

        case "titan_stryder_leadwall":
        case "titan_stryder_ronin_prime": //ronin
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/ronin")
            break
        case "titan_atlas_stickybomb":
        case "titan_atlas_ion_prime": //ion
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/ion")
            break
        case "titan_ogre_scorch_prime":
        case "titan_ogre_meteor": //scorch
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/scorch")
            break
        case "titan_stryder_northstar_prime":
        case "titan_stryder_sniper": //northstar
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/northstar")
            break
        case "titan_atlas_tone_prime":
        case "titan_atlas_tracker": //tone
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/tone")
            break
        case "titan_ogre_legion_prime":
        case "titan_ogre_minigun": //legion
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/legion")
            break
        case "titan_atlas_vanguard": //battery whore
            ui_object.SetImage($"ui/destiny2/gamestate/titan_classes/batterywhore")
            break

        //GENERIC

        default:
            if(player.IsTitan())
                ui_object.SetImage($"ui/destiny2/gamestate/icon_titan.vmt")
            else
                ui_object.SetImage($"ui/destiny2/gamestate/icon_alive.vmt")
            break
    }
}

//RESPAWN FUNCTION, /vscripts/_utility_shared.nut
int function GetWinningTeam_FFA2()
{
	if ( level.nv.winningTeam != null )
		return expect int( level.nv.winningTeam )

	int maxScore = 0
	int playerTeam
	int currentScore
	int winningTeam = TEAM_UNASSIGNED

	foreach( player in GetPlayerArray() )
	{
		playerTeam = player.GetTeam()
		if ( IsRoundBased() )
			currentScore = GameRules_GetTeamScore2( playerTeam )
		else
			currentScore = GameRules_GetTeamScore( playerTeam )

		if ( currentScore == maxScore) //Treat multiple teams as having the same score as no team winning
			winningTeam = TEAM_UNASSIGNED

		if ( currentScore > maxScore )
		{
			maxScore = currentScore
			winningTeam = playerTeam
		}
	}

	return winningTeam

}


void function HudRevamp_D2_Gamestate_Update(var gamestate, entity player){
    //this logic is safe to run every frame, i know this because respawn does it
    var friendly_score_number = Hud_GetChild(gamestate, "Team0_ScoreCount")
    var friendly_score_box = Hud_GetChild(gamestate, "Team0_Score")
    var enemy_score_number = Hud_GetChild(gamestate, "Team1_ScoreCount")
    var enemy_score_box = Hud_GetChild(gamestate, "Team1_Score")
    var friendly_score_bar = Hud_GetChild(gamestate, "Team0_ScoreBar")
    var enemy_score_bar = Hud_GetChild(gamestate, "Team1_ScoreBar")

    var ffa_you_name = Hud_GetChild(gamestate, "FFA_You")
    var ffa_leader_name = Hud_GetChild(gamestate, "FFA_Leader")

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
		endTime = expect float( level.nv.roundEndTime )
	}
	else
	{
      endTime = expect float( level.nv.gameEndTime )
	}

    float score_limit = float(GetScoreLimit_FromPlaylist())
    int friendlyTeam = player.GetTeam()
    int enemyTeam = 0

    if ( IsFFAGame() ) 
    {
        int highestScore = 0
        int playerTeam = 0
        int playerCheckScore = 0
        int playerTeamHighest = 0
        foreach( player in GetPlayerArray() )
        {
            playerTeam = player.GetTeam()
            if ( playerTeam != friendlyTeam ) {

                if ( IsRoundBased() ) playerCheckScore = GameRules_GetTeamScore2( playerTeam )
                else playerCheckScore = GameRules_GetTeamScore( playerTeam )
                if ( playerCheckScore > highestScore || highestScore == 0) {
                    highestScore = playerCheckScore
                    playerTeamHighest = playerTeam
                }
            }
        }
        enemyTeam = playerTeamHighest
        var enemies =  GetPlayerArrayOfTeam( enemyTeam )
        if( enemies.len() > 0 )
            Hud_SetText(ffa_leader_name,enemies[0].GetPlayerName())
        Hud_SetText(ffa_you_name, player.GetPlayerName())

    } else
    {
        enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
    }

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

    if ( IsFFAGame() ) 
    {
        Hud_SetVisible(ffa_you_name, true)
        Hud_SetVisible(ffa_leader_name, true)
        //disable UI for ALL PLAYERS fuck you
        for(int i = 0; i < 8; i++){
            string player_ui_target = "Team0_Player" + string(i)
            var player_ui = Hud_GetChild(gamestate, player_ui_target)
            Hud_SetVisible(player_ui, false)
        }
        for(int i = 0; i < 8; i++){
            string player_ui_target = "Team1_Player" + string(i)
            var player_ui = Hud_GetChild(gamestate, player_ui_target)
            Hud_SetVisible(player_ui, false)
        }
    }

    else 
    {
        Hud_SetVisible(ffa_you_name, false)
        Hud_SetVisible(ffa_leader_name, false)

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

            HudRevamp_D2_SetGamestateClassIcon(friendly_players[i], player_ui, true)
        }
        for(int i = 0; i < min(8,enemy_players.len()); i++){
            string player_ui_target = "Team1_Player" + string(i)
            var player_ui = Hud_GetChild(gamestate, player_ui_target)
            Hud_SetVisible(player_ui, true)

            HudRevamp_D2_SetGamestateClassIcon(enemy_players[i], player_ui, false)
        }
    }


}


float lastTimeHealthNotFull = -99
bool d2_healthbar_needs_update = false
bool d2_healthbar_updating = false
vector lastPos = <0,0,0>

void function Destiny2_FlatUpdate( var flatPanel )
{
    entity player = GetLocalViewPlayer()

    if (!IsValid(player))
        return
    
    // update gamestate stuff :)
    var gamestate = HudElement("Destiny_GameStatePanel", flatPanel)
    Hud_SetVisible( gamestate, !(IsSingleplayer() || GAMETYPE == "fd" || GAMETYPE == FORT_WAR /* playing it safe with the fort war */) )
    HudRevamp_D2_Gamestate_Update(gamestate, player)

    // HEALTHBAR CHECKS
    // side note - mem leak. can't fix because traceline creates a new instance of
    // the traceresults stack every time it's called :(
    // TARGET INFO BULLSHIT SEND HELP PLEASE
    // also this should be illegal
    vector attackDir = AnglesToForward( player.CameraAngles() )
    if (IsValid(player.GetActiveWeapon()) && player.GetActiveWeapon().GetWeaponOwner() == player)
        attackDir = player.GetActiveWeapon().GetAttackDirection()
    TraceResults results = TraceLine( player.CameraPosition(), player.CameraPosition() + attackDir * 8192, [ player ],
        TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
    
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
                    thread TitanHealthBar( flatPanel, results.hitEnt )
                }
            }
            else
            {
                if (!file.healthbarEntities.contains(results.hitEnt))
                {
                    thread HealthBar( flatPanel, results.hitEnt )
                }
            }
        }
        else if (results.hitEnt.IsPlayer())
        {
            if (results.hitEnt.IsTitan())
            {
                if (!file.titanHealthbarEntities.contains(results.hitEnt))
                {
                    thread TitanHealthBar( flatPanel, results.hitEnt )
                }
            }
            else
            {
                if (!file.healthbarEntities.contains(results.hitEnt))
                {
                    thread HealthBar( flatPanel, results.hitEnt )
                }
            }
        }
    }
}

int energy = 0
void function Destiny2_Update( var panel )
{
    entity player = GetLocalClientPlayer()

    if (file.goalId != player.GetPlayerNetInt( EARNMETER_GOALID ))
    {
        file.earnGoal = PlayerEarnMeter_GetGoal( player )
        file.earnReward = PlayerEarnMeter_GetReward( player )
        file.goalId = player.GetPlayerNetInt( EARNMETER_GOALID )
    }
    
    // healthbar stuff
    var player_healthbar = HudElement("HealthBar", panel)
    var player_healthbar_bg = HudElement("HealthBarBG", panel)

    /*if ( !IsSingleplayer() ) {
        Hud_SetPos(player_healthbar_bg, 0, -140)

    } else {
        Hud_SetPos(player_healthbar_bg, 0, 0)
    }*/

    //Hud_SetHeight(player_healthbar_bg, 24)

    Hud_SetBarProgress( player_healthbar, GetHealthFrac(player) )

    if (!IsValid(file.selectedWeapon) || file.selectedWeapon.GetWeaponOwner() != GetLocalClientPlayer())
        return

    if (player.GetSharedEnergyCount() < energy)
    {
        printt(player.GetSharedEnergyCount(), Time())
    }
    energy = player.GetSharedEnergyCount()

    var SuperBar = HudElement("SuperBar", panel)
    var SuperBorder = HudElement("SuperBorder", panel)
    var SuperBar_BG = HudElement("SuperBarBG", panel)
    var SuperIcon_BG = HudElement("SuperImageBG", panel)
    var SuperIcon = HudElement("SuperImage", panel)

    Hud_SetVisible( SuperIcon, file.goalId != 0 )
    Hud_SetVisible( SuperBorder, file.goalId != 0 )
    Hud_SetVisible( SuperBar, file.goalId != 0 )
    Hud_SetVisible( SuperBar_BG, file.goalId != 0 )
    Hud_SetVisible( SuperIcon_BG, file.goalId != 0 )
    SuperIcon.SetImage( file.earnGoal.buildingImage )
    
    float superFrac = PlayerEarnMeter_GetEarnedFrac(player)
    if (player.IsTitan() && IsValid(player.GetTitanSoul()))
        superFrac = player.GetTitanSoul().GetTitanSoulNetFloat( "coreAvailableFrac" )
    Hud_SetBarProgress( SuperBar, superFrac )

    if(superFrac >= 1)
    {
        Hud_SetColor( SuperBar, SUPER_COL_RGB, 255 )
        Hud_SetColor( SuperIcon_BG, SUPER_COL_RGB, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 255, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_full.vmt")
    }
    else
    {
        Hud_SetColor( SuperBar, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon_BG, 255, 255, 255, 255 )
        Hud_SetColor( SuperIcon, 255, 255, 255, 255 )
        SuperIcon_BG.SetImage($"ui/destiny2/super_empty.vmt")
    }
    if(player.IsTitan()){
        entity coreWeapon = player.GetOffhandWeapon(3)
        if(IsValid(coreWeapon)){
            Hud_SetVisible( SuperIcon, true )
            Hud_SetVisible( SuperBorder, true )
            Hud_SetVisible( SuperBar, true )
            Hud_SetVisible( SuperBar_BG, true )
            Hud_SetVisible( SuperIcon_BG, true )

            var originalIcon = GetWeaponInfoFileKeyFieldAsset_WithMods_Global( 
                coreWeapon.GetWeaponClassName(), coreWeapon.GetMods(), "hud_icon"
            )
            var core_str = expect string( 
                GetWeaponInfoFileKeyField_WithMods_Global(
                    coreWeapon.GetWeaponClassName(), coreWeapon.GetMods(), "hud_icon"
                ) 
            ) + "_destiny2"
            
            var customIcon = StringToAsset( 
                core_str
            )
            Hud_SetImage(SuperIcon, customIcon)
        }
        else
            Hud_SetImage(SuperIcon, $"ui/destiny2/unstoppable.vmt")
    }

    if(GetHealthFrac(player) < 1){
        lastTimeHealthNotFull = Time()
    }

    float d2_healthbar_opacity = GraphCapped(Time() - lastTimeHealthNotFull, 0, 1, 1, 0)
    if (IsSingleplayer())
        d2_healthbar_opacity = 1.0
    if (player.IsTitan())
        d2_healthbar_opacity = 0.0
    Hud_SetColor( player_healthbar, 255, 255, 255, d2_healthbar_opacity * 255 )
    Hud_SetColor( player_healthbar_bg, 255, 255, 255, d2_healthbar_opacity * 120 )
    UpdateMainWeapons( player, panel )

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
        UpdateOffhand( HudElement( "OffhandLeft", panel ), offhands[2], 1 )
        UpdateOffhand( HudElement( "OffhandCenter", panel ), offhands[1], 2 )
    }
    else if (offhands.len() > 1)
    {
        UpdateOffhand( HudElement( "OffhandCenter", panel ), offhands[1], 1 )
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

void function HealthBar( var flatPanel, entity ent )
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

    var healthbar = Hud_GetChild( flatPanel, "Healthbar" + index )
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
        if (Time() - lastLookTime > 0.5)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        healthbar.SetPanelAlpha( alpha * 255.0 )
        RuiSetFloat( rui, "basicImageAlpha", alpha )

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

void function TitanHealthBar( var flatPanel, entity ent )
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

    var healthbar = Hud_GetChild( flatPanel, "HealthbarChampion" + index )
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
    var triangle = Hud_GetChild( healthbar, "Icon" )
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
            triangle.SetImage( $"ui/destiny2/ChampionTriangle" )
            bar.SetColor( FRIENDLY_BAR_COLOR )
        }
        else
        {
            triangle.SetImage( $"ui/destiny2/ChampionTriangleEnemy" )
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
        if (Time() - lastLookTime > 0.5)
            alpha -= 8.0 * delta
        else alpha += 8.0 * delta
        alpha = clamp(alpha, 0, 0.8)
        // P.S. no rui here since we don't use basic_images
        healthbar.SetPanelAlpha( alpha * 255.0 )

        // calculate bar width with segment count
        int baseBarWidth = 278
        float healthPerSegment = 2500.0
        if (IsSingleplayer())
            healthPerSegment = 1500.0
        float segments = ent.GetMaxHealth() / healthPerSegment
        int width = int(segments) * 40
        if (ent.GetMaxHealth() % healthPerSegment == 0)
            width -= 2
        else width += int((segments % 1.0) * 38)

        Hud_SetWidth( bar, width )
        Hud_SetWidth( shieldBar, width )
        Hud_SetWidth( barBG, width )

        // calculate screen pos
        vector mins = ent.GetBoundingMins()
        vector maxs = ent.GetBoundingMaxs()
        vector worldPos = ent.GetOrigin() + <(mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 8>

        vector screenPos = WorldToScreenPos( worldPos )
        vector size = <Hud_GetWidth( healthbar ), Hud_GetHeight( healthbar ), 0>
        entity soul = ent.GetTitanSoul()

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

void function UpdateOffhand( var panel, entity weapon, int index )
{
    GetOffhandCooldownData( file.cooldownData[index], weapon )
    var BG = Hud_GetChild( panel, "BGFill" )
    var _BG = Hud_GetChild( panel, "BG" )
    var chargeBox = Hud_GetChild( panel, "SecondChargeBox" )
    var chargeBox2 = Hud_GetChild( panel, "ThirdChargeBox" )
    var chargeBox3 = Hud_GetChild( panel, "FourthChargeBox" )
    var icon = Hud_GetChild( panel, "Icon" )

    Hud_SetImage( icon, GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapon.GetWeaponClassName(), weapon.GetMods(), "hud_icon" ) )

    Hud_SetVisible( chargeBox, file.cooldownData[index].charges >= 2 )
    Hud_SetHeight( chargeBox, 8 )

    if (file.cooldownData[index].readyCharges >= 2)
    {
        Hud_SetColor(chargeBox, SUBCLASS_COLOR)
    }
    else
    {
        Hud_SetColor(chargeBox, 50, 50, 50, 150)
    }

    Hud_SetVisible( chargeBox2, file.cooldownData[index].charges >= 3 )
    Hud_SetHeight( chargeBox2, 8 )
    //Hud_SetWidth( chargeBox2, 60) //these fuck with the width on higher resolutions

    if (file.cooldownData[index].readyCharges >= 3)
    {
        Hud_SetColor(chargeBox2, SUBCLASS_COLOR)
    }
    else
    {
        Hud_SetColor(chargeBox2, 50, 50, 50, 150)
    }

    Hud_SetVisible( chargeBox3, file.cooldownData[index].charges >= 4 )
    Hud_SetHeight( chargeBox3, 8 )
    //Hud_SetWidth( chargeBox3, 60) //these fuck with the width on higher resolutions

    if (file.cooldownData[index].readyCharges >= 4)
    {
        Hud_SetColor(chargeBox3, SUBCLASS_COLOR)
    }
    else
    {
        Hud_SetColor(chargeBox3, 50, 50, 50, 150)
    }

    if(file.cooldownData[index].readyCharges >= 1) {
        Hud_SetColor(_BG, SUBCLASS_COLOR)
        Hud_SetColor(BG, 200, 200, 200, 100)
    }
    else{
        Hud_SetColor(_BG, 50, 50, 50, 150)
        Hud_SetColor(BG, 200, 200, 200, 50)
    }

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
    if (weapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size) <= 0)
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