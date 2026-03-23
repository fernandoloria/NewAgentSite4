using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AgentSite4.cASEnums
{
    public class ReportPosition
    {
        public static ulong ACTIONBYPLAYER = 1;
        public static ulong AFFILIATEMANAGE = 2;
        public static ulong AFFILIATEMARKETING = 4;
        public static ulong AGENTADJUSTMENT = 8;
        public static ulong AGENTBALANCEHISTORY = 16;
        public static ulong AGENTCOMMISSION = 32;
        public static ulong AGENTDISTRIBUTION = 64;
        public static ulong AGENTEXPOSURE = 128;
        public static ulong AGENTGROSSWEEK = 256;
        public static ulong AGENTPOSITION = 512;
        public static ulong AGENTWAGERLISTING = 1024;
        public static ulong AGENTWEEKLYPAYMENTS = 2048;
        public static ulong CASHFLOW = 4096;
        public static ulong CHANGEPLAYERPASS = 8192;
        public static ulong CHANGETEMPCREDIT = 16384;
        public static ulong CHANGEDWAGER = 32768;
        public static ulong CREATEACCRUALADJ = 65536;
        public static ulong CREATEADJUSTMENT = 131072;
        public static ulong CREATEDISBURSEMENT = 262144;
        public static ulong CREATEHORSEADJ = 524288;
        public static ulong CREATERECEIPT = 1048576;
        public static ulong DECREASECREDITLIMIT = 2097152;
        public static ulong DECREASEWAGERLIMITLOCAL = 4194304;
        public static ulong DECREASEWAGERLIMITONLINE = 8388608;
        public static ulong EDITCREDITLIMIT = 16777216;
        public static ulong ENABLEORDISABLEPLAYER = 33554432;
        public static ulong HOLDPERCENT = 67108864;
        public static ulong INCREASECREDITLIMIT = 134217728;
        public static ulong INCWAGERLIMITLOCAL = 268435456;
        public static ulong INCWAGERLIMITONLINE = 536870912;
        public static ulong OPENBETS = 1073741824;
        public static ulong PLAYERHISTORY = 2147483648;
        public static ulong PLAYERMANAGEMENT = 4294967296;
        public static ulong PLAYERONLINEMESSAGE = 8589934592;
        public static ulong PLAYERSTANDING = 17179869184;
        public static ulong PLAYERTOTALS = 34359738368;
        public static ulong SHOWAGENTHISTORY = 68719476736;
        public static ulong WEBVRSPHONE = 137438953472;
        public static ulong WEEKLYBALANCE = 274877906944;
        public static ulong MOVELINES = 549755813888;
        public static ulong PLAYERMARKETINGINFO = 1099511627776;
        public static ulong PLAYERACCESS = 2199023255552;
        public static ulong PLAYERCOUNT = 4398046511104;
        public static ulong SETTLEDFIGURE = 8796093022208;
        public static ulong AGENTTRANSACTION = 17592186044416;
        public static ulong AGENTTOPPLAYER = 35184372088832;
        public static ulong CREATEAGENT = 70368744177664;
        public static ulong CREATEPLAYER = 140737488355328;



        public static string POKERMANAGEMENT = "POKER MANAGEMENT";
        public static string POKERACCESS = "POKER ACCESS";
        public static string ADDPLAYER = "CREATE PLAYER";
        //public static string ADDAGENT = "CREATE AGENT";
        public static string ADDAGENT = ".ADD AGENT"; //Right en Heritage
        public static string CANCELBETS = "CANCEL BETS";
        public static string INSERTWAGER = "INSERT WAGER";
        public static string MANAGEPROFILELIMITS = "MANAGE PROFILE LIMITS";
        public static string MANAGEPROFILE = "MANAGE PROFILE";
        public static string MANAGESUBAGENT = "MANAGE SUB AGENT";
        public static string MANAGEMONEYLINES = "MANAGE MONEY LINES";
        public static string WAGEREMAILNOTIFICATION = "WAGER EMAIL NOTIFICATION";
        public static string WAGERSMSNOTIFICATION = "WAGER SMS NOTIFICATION";
        public static string AGENTCHANGEPASSWORD = "AGENT CHANGE PASSWORD";
        public static string PLAYERMESSAGES = "PLAYER MESSAGES";
        public static string HIDDENLEAGUES = "HIDDEN LEAGUES";
        public static string BETTICKER = "BET TICKER";
        public static string PLAYERBULKPAYMENT = "PLAYER BULK PAYMENT";
        public static string TRACKPLAYERACTIVITY = "TRACK PLAYER ACTIVITY";
        public static string BEATTHELINE = "BEAT THE LINE";
        public static string HORSEMASTER = "HORSE MASTER";
        public static string ALLSPORTS = "ALL SPORTS";
        public static string PLAYEROVERVIEW = "PLAYER OVERVIEW";
        public static string PLAYERLIFETIME = "PLAYER LIFETIME";
        public static string PLAYERZEROBALANCE = "PLAYER ZERO BALANCE";
        public static string ROLLOVERREPORT = "ROLLOVER REPORT";
        public static string HANDLEREPORT = "HANDLE REPORT";
        public static string TOPWINNERSANDLOOSER = "TOP WINNERS AND LOOSER";
        public static string WISEGUYMONITOR = "WISE GUY MONITOR";
        public static string AGENTACCESSLOG = "AGENT ACCESS LOG";
        public static string CREATEFREEPLAY = "CREATE FREEPLAY";
        public static string EditPlayer = "EDIT PLAYER";
        public static string PLAYERPAYMENT = "PLAYER PAYMENT";
        public static string AGENTPPH = "AGENT PPH";
        public static string AGENTPPHTRANSACTION = "AGENT PPH TRANSACTION";
        public static string AGENTPPHACTIVEPLAYERS = "AGENT PPH ACTIVE PLAYERS";
        public static string LINESSCHEDULE = "LINES SCHEDULE";
        public static string DETAILEDSALESREPORT = "DETAILED SALES REPORT";

        public static string PLAYERMANAGEMENTENHANCED = "PLAYER MANAGEMENT ENHANCED";
        public static string MANAGEFREEPLAYBYLEAGUE = "MANAGE FREE PLAY BY LEAGUE";
        public static string AGENTCREDITLIMIT = "AGENT CREDIT LIMIT";
        public static string MANAGELINES = "MANAGE LINES";
        

        public static string TELEGRAMALERT = "TELEGRAM ALERT";


        public static string INCREASEWAGERLIMITLOCAL = "INCREASE WAGER LIMIT LOCAL";
        public static string INCREASEWAGERLIMITONLINE = "INCREASE WAGER LIMIT ONLINE";
        public static string CHANGEPLAYERPASSWORDS = "CHANGE PLAYER PASSWORDS";
        public static string CHANGEPROFILELIMIT = "CHANGE PROFILE LIMIT";
    }
}
