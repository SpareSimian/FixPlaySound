#!/usr/bin/perl

# WoW 7.3 changed the PlaySound API to require a constant, not a
# string, as an argument. This script searches LUA and XML files
# beneath the current directory for such calls and fixes the argument.
# This is typically called from ...\WorldOfWarcraft\Interface\Addons.

use strict;
use Scalar::Util qw(looks_like_number);
use File::Find::Rule;

my %soundKitConstants;

sub addSoundKitConstant {
        my ($symbol, $value) = @_;
        $soundKitConstants{$value} = $symbol;
}

sub addSoundKitConstants {
        addSoundKitConstant("LOOT_WINDOW_COIN_SOUND", 120);
        addSoundKitConstant("INTERFACE_SOUND_LOST_TARGET_UNIT", 684);
        addSoundKitConstant("GS_TITLE_OPTIONS", 778);
        addSoundKitConstant("GS_TITLE_CREDITS", 790);
        addSoundKitConstant("GS_TITLE_OPTION_OK", 798);
        addSoundKitConstant("GS_TITLE_OPTION_EXIT", 799);
        addSoundKitConstant("GS_LOGIN", 800);
        addSoundKitConstant("GS_LOGIN_NEW_ACCOUNT", 801);
        addSoundKitConstant("GS_LOGIN_CHANGE_REALM_OK", 805);
        addSoundKitConstant("GS_LOGIN_CHANGE_REALM_CANCEL", 807);
        addSoundKitConstant("GS_CHARACTER_SELECTION_ENTER_WORLD", 809);
        addSoundKitConstant("GS_CHARACTER_SELECTION_DEL_CHARACTER", 810);
        addSoundKitConstant("GS_CHARACTER_SELECTION_ACCT_OPTIONS", 811);
        addSoundKitConstant("GS_CHARACTER_SELECTION_EXIT", 812);
        addSoundKitConstant("GS_CHARACTER_SELECTION_CREATE_NEW", 813);
        addSoundKitConstant("GS_CHARACTER_CREATION_CLASS", 814);
        addSoundKitConstant("GS_CHARACTER_CREATION_LOOK", 817);
        addSoundKitConstant("GS_CHARACTER_CREATION_CREATE_CHAR", 818);
        addSoundKitConstant("GS_CHARACTER_CREATION_CANCEL", 819);
        addSoundKitConstant("IG_MINIMAP_OPEN", 821);
        addSoundKitConstant("IG_MINIMAP_CLOSE", 822);
        addSoundKitConstant("IG_MINIMAP_ZOOM_IN", 823);
        addSoundKitConstant("IG_MINIMAP_ZOOM_OUT", 824);
        addSoundKitConstant("IG_CHAT_EMOTE_BUTTON", 825);
        addSoundKitConstant("IG_CHAT_SCROLL_UP", 826);
        addSoundKitConstant("IG_CHAT_SCROLL_DOWN", 827);
        addSoundKitConstant("IG_CHAT_BOTTOM", 828);
        addSoundKitConstant("IG_SPELLBOOK_OPEN", 829);
        addSoundKitConstant("IG_SPELLBOOK_CLOSE", 830);
        addSoundKitConstant("IG_ABILITY_OPEN", 834);
        addSoundKitConstant("IG_ABILITY_CLOSE", 835);
        addSoundKitConstant("IG_ABILITY_PAGE_TURN", 836);
        addSoundKitConstant("IG_ABILITY_ICON_DROP", 838);
        addSoundKitConstant("IG_CHARACTER_INFO_OPEN", 839);
        addSoundKitConstant("IG_CHARACTER_INFO_CLOSE", 840);
        addSoundKitConstant("IG_CHARACTER_INFO_TAB", 841);
        addSoundKitConstant("IG_QUEST_LOG_OPEN", 844);
        addSoundKitConstant("IG_QUEST_LOG_CLOSE", 845);
        addSoundKitConstant("IG_QUEST_LOG_ABANDON_QUEST", 846);
        addSoundKitConstant("IG_MAINMENU_OPEN", 850);
        addSoundKitConstant("IG_MAINMENU_CLOSE", 851);
        addSoundKitConstant("IG_MAINMENU_OPTION", 852);
        addSoundKitConstant("IG_MAINMENU_LOGOUT", 853);
        addSoundKitConstant("IG_MAINMENU_QUIT", 854);
        addSoundKitConstant("IG_MAINMENU_CONTINUE", 855);
        addSoundKitConstant("IG_MAINMENU_OPTION_CHECKBOX_ON", 856);
        addSoundKitConstant("IG_MAINMENU_OPTION_CHECKBOX_OFF", 857);
        addSoundKitConstant("IG_MAINMENU_OPTION_FAER_TAB", 858);
        addSoundKitConstant("IG_INVENTORY_ROTATE_CHARACTER", 861);
        addSoundKitConstant("IG_BACKPACK_OPEN", 862);
        addSoundKitConstant("IG_BACKPACK_CLOSE", 863);
        addSoundKitConstant("IG_BACKPACK_COIN_SELECT", 864);
        addSoundKitConstant("IG_BACKPACK_COIN_OK", 865);
        addSoundKitConstant("IG_BACKPACK_COIN_CANCEL", 866);
        addSoundKitConstant("IG_CHARACTER_NPC_SELECT", 867);
        addSoundKitConstant("IG_CREATURE_NEUTRAL_SELECT", 871);
        addSoundKitConstant("IG_CREATURE_AGGRO_SELECT", 873);
        addSoundKitConstant("IG_QUEST_LIST_OPEN", 875);
        addSoundKitConstant("IG_QUEST_LIST_CLOSE", 876);
        addSoundKitConstant("IG_QUEST_LIST_SELECT", 877);
        addSoundKitConstant("IG_QUEST_LIST_COMPLETE", 878);
        addSoundKitConstant("IG_QUEST_CANCEL", 879);
        addSoundKitConstant("IG_PLAYER_INVITE", 880);
        addSoundKitConstant("MONEY_FRAME_OPEN", 891);
        addSoundKitConstant("MONEY_FRAME_CLOSE", 892);
        addSoundKitConstant("U_CHAT_SCROLL_BUTTON", 1115);
        addSoundKitConstant("PUT_DOWN_SMALL_CHAIN", 1212);
        addSoundKitConstant("LOOT_WINDOW_OPEN_EMPTY", 1264);
        addSoundKitConstant("TELL_MESSAGE", 3081);
        addSoundKitConstant("MAP_PING", 3175);
        addSoundKitConstant("FISHING_REEL_IN", 3407);
        addSoundKitConstant("IG_PVP_UPDATE", 4574);
        addSoundKitConstant("AUCTION_WINDOW_OPEN", 5274);
        addSoundKitConstant("AUCTION_WINDOW_CLOSE", 5275);
        addSoundKitConstant("TUTORIAL_POPUP", 7355);
        addSoundKitConstant("ITEM_REPAIR", 7994);
        addSoundKitConstant("PVP_ENTER_QUEUE", 8458);
        addSoundKitConstant("PVP_THROUGH_QUEUE", 8459);
        addSoundKitConstant("KEY_RING_OPEN", 8938);
        addSoundKitConstant("KEY_RING_CLOSE", 8939);
        addSoundKitConstant("RAID_WARNING", 8959);
        addSoundKitConstant("READY_CHECK", 8960);
        addSoundKitConstant("GLUESCREEN_INTRO", 9902);
        addSoundKitConstant("AMB_GLUESCREEN_HUMAN", 9903);
        addSoundKitConstant("AMB_GLUESCREEN_ORC", 9905);
        addSoundKitConstant("AMB_GLUESCREEN_TAUREN", 9906);
        addSoundKitConstant("AMB_GLUESCREEN_DWARF", 9907);
        addSoundKitConstant("AMB_GLUESCREEN_NIGHTELF", 9908);
        addSoundKitConstant("AMB_GLUESCREEN_UNDEAD", 9909);
        addSoundKitConstant("AMB_GLUESCREEN_BLOODELF", 9910);
        addSoundKitConstant("AMB_GLUESCREEN_DRAENEI", 9911);
        addSoundKitConstant("JEWEL_CRAFTING_FINALIZE", 10590);
        addSoundKitConstant("MENU_CREDITS01", 10763);
        addSoundKitConstant("MENU_CREDITS02", 10804);
        addSoundKitConstant("GUILD_VAULT_OPEN", 12188);
        addSoundKitConstant("GUILD_VAULT_CLOSE", 12189);
        addSoundKitConstant("RAID_BOSS_EMOTE_WARNING", 12197);
        addSoundKitConstant("GUILD_BANK_OPEN_BAG", 12206);
        addSoundKitConstant("GS_LICH_KING", 12765);
        addSoundKitConstant("ALARM_CLOCK_WARNING_2", 12867);
        addSoundKitConstant("ALARM_CLOCK_WARNING_3", 12889);
        addSoundKitConstant("MENU_CREDITS03", 13822);
        addSoundKitConstant("ACHIEVEMENT_MENU_OPEN", 13832);
        addSoundKitConstant("ACHIEVEMENT_MENU_CLOSE", 13833);
        addSoundKitConstant("BARBERSHOP_HAIRCUT", 13873);
        addSoundKitConstant("BARBERSHOP_SIT", 14148);
        addSoundKitConstant("GM_CHAT_WARNING", 15273);
        addSoundKitConstant("LFG_REWARDS", 17316);
        addSoundKitConstant("LFG_ROLE_CHECK", 17317);
        addSoundKitConstant("LFG_DENIED", 17341);
        addSoundKitConstant("UI_BNET_TOAST", 18019);
        addSoundKitConstant("ALARM_CLOCK_WARNING_1", 18871);
        addSoundKitConstant("AMB_GLUESCREEN_WORGEN", 20169);
        addSoundKitConstant("AMB_GLUESCREEN_GOBLIN", 20170);
        addSoundKitConstant("AMB_GLUESCREEN_TROLL", 21136);
        addSoundKitConstant("AMB_GLUESCREEN_GNOME", 21137);
        addSoundKitConstant("UI_POWER_AURA_GENERIC", 23287);
        addSoundKitConstant("UI_REFORGING_REFORGE", 23291);
        addSoundKitConstant("UI_AUTO_QUEST_COMPLETE", 23404);
        addSoundKitConstant("GS_CATACLYSM", 23640);
        addSoundKitConstant("MENU_CREDITS04", 23812);
        addSoundKitConstant("UI_BATTLEGROUND_COUNTDOWN_TIMER", 25477);
        addSoundKitConstant("UI_BATTLEGROUND_COUNTDOWN_FINISHED", 25478);
        addSoundKitConstant("UI_VOID_STORAGE_UNLOCK", 25711);
        addSoundKitConstant("UI_VOID_STORAGE_DEPOSIT", 25712);
        addSoundKitConstant("UI_VOID_STORAGE_WITHDRAW", 25713);
        addSoundKitConstant("UI_TRANSMOGRIFY_UNDO", 25715);
        addSoundKitConstant("UI_ETHEREAL_WINDOW_OPEN", 25716);
        addSoundKitConstant("UI_ETHEREAL_WINDOW_CLOSE", 25717);
        addSoundKitConstant("UI_TRANSMOGRIFY_REDO", 25738);
        addSoundKitConstant("UI_VOID_STORAGE_BOTH", 25744);
        addSoundKitConstant("AMB_GLUESCREEN_PANDAREN", 25848);
        addSoundKitConstant("MUS_50_HEART_OF_PANDARIA_MAINTITLE", 28509);
        addSoundKitConstant("UI_PET_BATTLES_TRAP_READY", 28814);
        addSoundKitConstant("UI_EPICLOOT_TOAST", 31578);
        addSoundKitConstant("UI_BONUS_LOOT_ROLL_START", 31579);
        addSoundKitConstant("UI_BONUS_LOOT_ROLL_LOOP", 31580);
        addSoundKitConstant("UI_BONUS_LOOT_ROLL_END", 31581);
        addSoundKitConstant("UI_PET_BATTLE_START", 31584);
        addSoundKitConstant("UI_SCENARIO_ENDING", 31754);
        addSoundKitConstant("UI_SCENARIO_STAGE_END", 31757);
        addSoundKitConstant("MENU_CREDITS05", 32015);
        addSoundKitConstant("UI_PET_BATTLE_CAMERA_MOVE_IN", 32047);
        addSoundKitConstant("UI_PET_BATTLE_CAMERA_MOVE_OUT", 32052);
        addSoundKitConstant("AMB_50_GLUESCREEN_ALLIANCE", 32412);
        addSoundKitConstant("AMB_50_GLUESCREEN_HORDE", 32413);
        addSoundKitConstant("AMB_50_GLUESCREEN_PANDAREN_NEUTRAL", 32414);
        addSoundKitConstant("UI_CHALLENGES_NEW_RECORD", 33338);
        addSoundKitConstant("MENU_CREDITS06", 34020);
        addSoundKitConstant("UI_LOSS_OF_CONTROL_START", 34468);
        addSoundKitConstant("UI_PET_BATTLES_PVP_THROUGH_QUEUE", 36609);
        addSoundKitConstant("AMB_GLUESCREEN_DEATHKNIGHT", 37056);
        addSoundKitConstant("UI_RAID_BOSS_WHISPER_WARNING", 37666);
        addSoundKitConstant("UI_DIG_SITE_COMPLETION_TOAST", 38326);
        addSoundKitConstant("UI_IG_STORE_PAGE_NAV_BUTTON", 39511);
        addSoundKitConstant("UI_IG_STORE_WINDOW_OPEN_BUTTON", 39512);
        addSoundKitConstant("UI_IG_STORE_WINDOW_CLOSE_BUTTON", 39513);
        addSoundKitConstant("UI_IG_STORE_CANCEL_BUTTON", 39514);
        addSoundKitConstant("UI_IG_STORE_BUY_BUTTON", 39515);
        addSoundKitConstant("UI_IG_STORE_CONFIRM_PURCHASE_BUTTON", 39516);
        addSoundKitConstant("UI_IG_STORE_PURCHASE_DELIVERED_TOAST_01", 39517);
        addSoundKitConstant("MUS_60_MAIN_TITLE", 40169);
        addSoundKitConstant("UI_GARRISON_MISSION_COMPLETE_ENCOUNTER_FAIL", 43501);
        addSoundKitConstant("UI_GARRISON_MISSION_COMPLETE_MISSION_SUCCESS", 43502);
        addSoundKitConstant("UI_GARRISON_MISSION_COMPLETE_MISSION_FAIL_STINGER", 43503);
        addSoundKitConstant("UI_GARRISON_MISSION_THREAT_COUNTERED", 43505);
        addSoundKitConstant("UI_GARRISON_MISSION_100_PERCENT_CHANCE_REACHED_NOT_USED", 43507);
        addSoundKitConstant("UI_QUEST_ROLLING_FORWARD_01", 43936);
        addSoundKitConstant("UI_BAG_SORTING_01", 43937);
        addSoundKitConstant("UI_TOYBOX_TABS", 43938);
        addSoundKitConstant("UI_GARRISON_TOAST_INVASION_ALERT", 44292);
        addSoundKitConstant("UI_GARRISON_TOAST_MISSION_COMPLETE", 44294);
        addSoundKitConstant("UI_GARRISON_TOAST_BUILDING_COMPLETE", 44295);
        addSoundKitConstant("UI_GARRISON_TOAST_FOLLOWER_GAINED", 44296);
        addSoundKitConstant("UI_GARRISON_NAV_TABS", 44297);
        addSoundKitConstant("UI_GARRISON_GARRISON_REPORT_OPEN", 44298);
        addSoundKitConstant("UI_GARRISON_GARRISON_REPORT_CLOSE", 44299);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_OPEN", 44300);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_CLOSE", 44301);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_UPGRADE", 44302);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_UPGRADE_CANCEL", 44304);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_UPGRADE_START", 44305);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_PLOT_SELECT", 44306);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_BUILDING_SELECT", 44307);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_BUILDING_PLACEMENT", 44308);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_OPEN", 44311);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_CLOSE", 44312);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_MISSION_CLOSE", 44313);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_NAV_NEXT", 44314);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_SELECT_MISSION", 44315);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_SELECT_FOLLOWER", 44316);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_FOLLOWER_ABILITY_OPEN", 44317);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_FOLLOWER_ABILITY_CLOSE", 44318);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_ASSIGN_FOLLOWER", 44319);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER", 44320);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_SLOT_CHAMPION", 72546);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_SLOT_TROOP", 72547);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_REDUCED_SUCCESS_CHANCE", 44321);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_100_SUCCESS", 44322);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_MISSION_START", 44323);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_VIEW_MISSION_REPORT", 44324);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_MISSION_SUCCESS_STINGER", 44330);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK", 44331);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK_GOLD_SUCCESS", 44332);
        addSoundKitConstant("UI_GARRISON_MONUMENTS_OPEN", 44344);
        addSoundKitConstant("UI_BONUS_EVENT_SYSTEM_VIGNETTES", 45142);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_FOLLOWER_LEVEL_UP", 46893);
        addSoundKitConstant("UI_GARRISON_ARCHITECT_TABLE_BUILDING_PLACEMENT_ERROR", 47355);
        addSoundKitConstant("UI_GARRISON_MONUMENTS_CLOSE", 47373);
        addSoundKitConstant("AMB_GLUESCREEN_WARLORDS_OF_DRAENOR", 47544);
        addSoundKitConstant("MUS_1_0_MAINTITLE_ORIGINAL", 47598);
        addSoundKitConstant("UI_GROUP_FINDER_RECEIVE_APPLICATION", 47615);
        addSoundKitConstant("UI_GARRISON_MISSION_ENCOUNTER_ANIMATION_GENERIC", 47704);
        addSoundKitConstant("UI_GARRISON_START_WORK_ORDER", 47972);
        addSoundKitConstant("UI_GARRISON_SHIPMENTS_WINDOW_OPEN", 48191);
        addSoundKitConstant("UI_GARRISON_SHIPMENTS_WINDOW_CLOSE", 48192);
        addSoundKitConstant("UI_GARRISON_MONUMENTS_NAV", 48942);
        addSoundKitConstant("UI_RAID_BOSS_DEFEATED", 50111);
        addSoundKitConstant("UI_PERSONAL_LOOT_BANNER", 50893);
        addSoundKitConstant("UI_GARRISON_FOLLOWER_LEARN_TRAIT", 51324);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_PLACE_CARRIER", 51385);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_PLACE_GALLEON", 51387);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_PLACE_DREADNOUGHT", 51388);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_PLACE_SUBMARINE", 51389);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_PLACE_LANDING_CRAFT", 51390);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_START_MISSION", 51401);
        addSoundKitConstant("UI_RAID_LOOT_TOAST_LESSER_ITEM_WON", 51402);
        addSoundKitConstant("UI_WARFORGED_ITEM_LOOT_TOAST", 51561);
        addSoundKitConstant("UI_GARRISON_COMMAND_TABLE_INCREASED_SUCCESS_CHANCE", 51570);
        addSoundKitConstant("UI_GARRISON_SHIPYARD_DECOMISSION_SHIP", 51871);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_TRAIT_FIRST_TRAIT", 54126);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_RELIC_PLACE", 54128);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_APPEARANCE_COLOR_SELECT", 54130);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_APPEARANCE_LOCKED", 54131);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE", 54132);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_TOAST_TRAIT_AVAILABLE", 54133);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_UNLOCK", 54139);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_TRAIT_GOLD_TRAIT", 54125);
        addSoundKitConstant("UI_72_ARTIFACT_FORGE_FINAL_TRAIT_UNLOCKED", 83682);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_TRAIT_FINALRANK", 54127);
        addSoundKitConstant("UI_70_ARTIFACT_FORGE_TRAIT_RANKUP", 54129);
        addSoundKitConstant("AMB_GLUESCREEN_DEMONHUNTER", 56352);
        addSoundKitConstant("MUS_70_MAIN_TITLE", 56353);
        addSoundKitConstant("MENU_CREDITS07", 56354);
        addSoundKitConstant("UI_TRANSMOG_ITEM_CLICK", 62538);
        addSoundKitConstant("UI_TRANSMOG_PAGE_TURN", 62539);
        addSoundKitConstant("UI_TRANSMOG_GEAR_SLOT_CLICK", 62540);
        addSoundKitConstant("UI_TRANSMOG_REVERTING_GEAR_SLOT", 62541);
        addSoundKitConstant("UI_TRANSMOG_APPLY", 62542);
        addSoundKitConstant("UI_TRANSMOG_CLOSE_WINDOW", 62543);
        addSoundKitConstant("UI_TRANSMOG_OPEN_WINDOW", 62544);
        addSoundKitConstant("UI_LEGENDARY_LOOT_TOAST", 63971);
        addSoundKitConstant("UI_STORE_UNWRAP", 64329);
        addSoundKitConstant("AMB_GLUESCREEN_LEGION", 71535);
        addSoundKitConstant("UI_MISSION_200_PERCENT", 72548);
        addSoundKitConstant("UI_MISSION_MAP_ZOOM", 72549);
        addSoundKitConstant("UI_70_BOOST_THANKSFORPLAYING_SMALLER", 72978);
        addSoundKitConstant("UI_70_BOOST_THANKSFORPLAYING", 72977);
        addSoundKitConstant("UI_WORLDQUEST_START", 73275);
        addSoundKitConstant("UI_WORLDQUEST_MAP_SELECT", 73276);
        addSoundKitConstant("UI_WORLDQUEST_COMPLETE", 73277);
        addSoundKitConstant("UI_ORDERHALL_TALENT_SELECT", 73279);
        addSoundKitConstant("UI_ORDERHALL_TALENT_READY_TOAST", 73280);
        addSoundKitConstant("UI_ORDERHALL_TALENT_READY_CHECK", 73281);
        addSoundKitConstant("UI_ORDERHALL_TALENT_NUKE_FROM_ORBIT", 73282);
        addSoundKitConstant("UI_ORDERHALL_TALENT_WINDOW_OPEN", 73914);
        addSoundKitConstant("UI_ORDERHALL_TALENT_WINDOW_CLOSE", 73915);
        addSoundKitConstant("UI_PROFESSIONS_WINDOW_OPEN", 73917);
        addSoundKitConstant("UI_PROFESSIONS_WINDOW_CLOSE", 73918);
        addSoundKitConstant("UI_PROFESSIONS_NEW_RECIPE_LEARNED_TOAST", 73919);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_SOCKET_PAGE_OPEN", 74421);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_SOCKET_PAGE_CLOSE", 74423);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_SOCKET_PAGE_SOCKET", 74431);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_SOCKET_PAGE_ACTIVATE_BUTTON", 74432);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_KEYSTONE_UPGRADE", 74437);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_NEW_RECORD", 74438);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_SOCKET_PAGE_REMOVE_KEYSTONE", 74525);
        addSoundKitConstant("UI_70_CHALLENGE_MODE_COMPLETE_NO_UPGRADE", 74526);
        addSoundKitConstant("UI_MISSION_SUCCESS_CHEERS", 74702);
        addSoundKitConstant("UI_PVP_HONOR_PRESTIGE_OPEN_WINDOW", 76995);
        addSoundKitConstant("UI_PVP_HONOR_PRESTIGE_WINDOW_CLOSE", 77002);
        addSoundKitConstant("UI_PVP_HONOR_PRESTIGE_RANK_UP", 77003);
        addSoundKitConstant("UI_71_SOCIAL_QUEUEING_TOAST", 79739);
        addSoundKitConstant("UI_72_ARTIFACT_FORGE_ACTIVATE_FINAL_TIER", 83681);
        addSoundKitConstant("UI_72_BUILDINGS_CONTRIBUTE_POWER_MENU_CLICK", 84240);
        addSoundKitConstant("UI_72_BUILDING_CONTRIBUTION_TABLE_OPEN", 84368);
        addSoundKitConstant("UI_72_BUILDINGS_CONTRIBUTION_TABLE_CLOSE", 84369);
        addSoundKitConstant("UI_72_BUILDINGS_CONTRIBUTE_RESOURCES", 84378);
        addSoundKitConstant("UI_72_ARTIFACT_FORGE_FINAL_TRAIT_REFUND_START", 83684);
        addSoundKitConstant("UI_72_ARTIFACT_FORGE_FINAL_TRAIT_REFUND_LOOP", 83685);
        addSoundKitConstant("UI_73_ARTIFACT_RELICS_TRAIT_SELECT_AND_REVEAL", 89685);
        addSoundKitConstant("UI_73_ARTIFACT_RELICS_TRAIT_SELECT_ONLY", 89686);
        addSoundKitConstant("UI_73_ARTIFACT_RELICS_TRAIT_REVEAL_ONLY", 90080);
        addSoundKitConstant("PUT_DOWN_GEMS", 1204);
        addSoundKitConstant("PICK_UP_GEMS", 1221);
}

addSoundKitConstants();

sub camelCaseToUpperCase {
        my ($symbol) = @_;
        # if it's a number, see if it's a constant we know about
        if (looks_like_number($symbol)) {
                my $real_symbol = $soundKitConstants{$symbol};
                if ($real_symbol) {
                        return $real_symbol;
                } else {
                        warn "No soundkit symbol found for constant $symbol"; 
                        return $symbol; # just use the raw number
                }
        }
        
        # put an underscore in front of any capital
        $symbol =~ s/([A-Z])/_$1/g;
        # trim leading underscore
        $symbol =~ s/^_//;
        # capitalize the result
        $symbol = uc($symbol);
        # some special cases
        $symbol =~ s/MAIN_MENU/MAINMENU/g;
        $symbol =~ s/SPELL_BOOK/SPELLBOOK/g;
        $symbol =~ s/CHECK_BOX/CHECKBOX/g;
        return $symbol;
}

# process one file
sub process {
        my $filename = $_;
        my ( $shortname, $path, $fullname ) = @_;
        print "\nProcessing ", $fullname, "\n";

        # set up ARGV for local use of diamond operator and in-place search and replace
        local @ARGV;
        @ARGV = ( $filename );
        $^I = ".bak";
        while (<>)
        {
                if (/(^.*PlaySound\()"(\w+)"(.*)/) {
                # grab 3 pieces, before, symbol, and after
                        my $before = $1;
                        my $symbol = $2;
                        my $after = $3;
                        print $before, 'SOUNDKIT.', camelCaseToUpperCase($symbol), $after, "\n";
                } else {
                        print $_;
                }
        }

        1;
}

# filter for LUA and XML
sub wanted {
        /.*\.(xml|lua)$/ && process($_);
}

# Walk the tree from current directory, invoking process on each XML or
# LUA file matching the grep expression (PlaySound with a quoted
# argument).

my $rule = File::Find::Rule
           ->file
           ->name( '*.xml', '*.lua' )
           ->grep( qr/PlaySound\("/ )
           ->exec( \&process );

           # run the rule
$rule->in( "." );

1;
