<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%
pid = request.Form("pid")
gid = request.Form("gid")
gametypeid = request.Form("gtid")

Set rs = CreateObject("ADODB.Recordset")
sqlStr = "EXECUTE GetFamilyGames @prmIdGame = "&gid&", @prmIdPlayer = "&pid
rs.Open sqlStr, c

WHILE NOT rs.EOF 
	if Int(rs("IdGameType")) = Int(gametypeid) then

		gameid = rs("IdGame")
		sportid = rs("IdSport")
		leagueid = rs("IdLeague")
		visitorNum = rs("VisitorNumber")
		visitorName = rs("VisitorTeam")
		visitorPitcher = rs("VisitorPitcher")
		homeNum = rs("HomeNumber")
		homeName = rs("HomeTeam")
		homePitcher = rs("HomePitcher")
		
		visitorML = rs("VisitorOdds")
		visitorSpread = rs("VisitorSpread")
		visitorSpreadOdds = rs("VisitorSpreadOdds")
		visitorSpecialSpread = rs("VisitorSpecial")
		visitorSpecialSpreadOdds = rs("VisitorSpecialOdds")
		overTotal = rs("TotalOver")
		overTotalOdds = rs("OverOdds")
		
		homeML = rs("HomeOdds")
		homeSpread = rs("HomeSpread")
		homeSpreadOdds = rs("HomeSpreadOdds")
		homeSpecialSpread = rs("HomeSpecial")
		homeSpecialSpreadOdds = rs("HomeSpecialOdds")
		underTotal = rs("TotalUnder")
		underTotalOdds = rs("UnderOdds")

		pitcherChange = 0
		NHLLine = "C"
		showVisitorSpread = visitorSpread
		showVisitorSpecialSpread = visitorSpreadOdds
		showHomeSpread = homeSpread
		showHomeSpecialSpread = homeSpreadOdds
		showVisitorML = visitorML
		showHomeML = homeML
		showTotalOver = overTotal
		showTotalUnder = underTotal

		response.write "<div class='betting-lines-line betting-lines-line-bottom odd'>"&vbcr
		response.write "<div class='betting-lines-line-rot'>"&visitorNum&"</div>"&vbcr
		response.write "<div class='betting-lines-line-name'><span class='visitor'>"&visitorName&"</span> <span class='classpitcher"
		if pitcherChange = 1 or pitcherChange = 3 then							
			response.write " pitcherchange"
		end if
		response.write "'>"&visitorPitcher&"</span></div>"&vbcr
		response.write "<div class='betting-lines-line-line' id='"&gameid&"_0_S'"
		if Trim(sportid) = "NHL" and NHLLine = "C" then
			if visitorSpecialSpread <> "" then
				response.write " onclick=""addbet('0','"&gameid&"','S','"&visitorName&"','"&visitorSpecialSpread&"','"&visitorSpecialSpreadOdds&"','"&sportid&"','"&leagueid&"','"&visitorNum&"');"">"
				response.write "<a href='javascript:void(0)' class='"&linkspreadclass&"'>"&showVisitorSpecialSpread&"</a>"&vbcr
			else 
				response.write ">&nbsp;"
			end if
		else
			if visitorSpread <> "" then
				response.write " onclick=""addbet('0','"&gameid&"','S','"&visitorName&"','"&visitorSpread&"','"&visitorSpreadOdds&"','"&sportid&"','"&leagueid&"','"&visitorNum&"');"">"
				response.write "<a href='javascript:void(0)' class='"&linkspreadclass&"'>"&showVisitorSpread&"</a>"&vbcr
			else 
				response.write ">&nbsp;"
			end if
		end if				
		response.write "</div>"&vbcr

		response.write "<div class='betting-lines-line-line' id='"&gameid&"_2_Ov'"
		if overTotal <> "" then
			response.write " onclick=""addbet('2','"&gameid&"','Ov','"&visitorName&"','"&overTotal&"','"&overTotalOdds&"','"&sportid&"','"&leagueid&"','"&visitorNum&"');"">"
			response.write "<a href='javascript:void(0)' class='"&linktotalclass&"'>Ov "&showTotalOver&"</a>"&vbcr
		else 
			response.write ">&nbsp;"
		end if				
		response.write "</div>"&vbcr

		response.write "<div class='betting-lines-line-line-ml' id='"&gameid&"_4_ML'"
		if visitorML <> "" then
			response.write " onclick=""addbet('4','"&gameid&"','ML','"&visitorName&"','0','"&visitorML&"','"&sportid&"','"&leagueid&"','"&homeNum&"');"">"
			response.write "<a href='javascript:void(0)' class='"&linkmlclass&"'>"&symbol&Trim(showVisitorML)&"</a>"&vbcr
		else 
			response.write ">&nbsp;"
		end if
		response.write "</div>"&vbcr
		
		response.write "</div>"&vbcr
		
		response.write "<div class='betting-lines-line evn'>"&vbcr
		response.write "<div class='betting-lines-line-rot'>"&homeNum&"</div>"&vbcr
		response.write "<div class='betting-lines-line-name'>"&homeName&" <span class='classpitcher"
		if pitcherChange = 2 or pitcherChange = 3 then
			response.write " pitcherchange"
		end if
		response.write "'>"&homePitcher&"</span></div>"&vbcr
		
		response.write "<div class='betting-lines-line-line' id='"&gameid&"_1_S'"
		if Trim(sportid) = "NHL" and NHLLine = "C" then
			if homeSpecialSpread <> "" then
				response.write " onclick=""addbet('1','"&gameid&"','S','"&homeName&"','"&homeSpecialSpread&"','"&homeSpecialSpreadOdds&"','"&sportid&"','"&leagueid&"','"&homeNum&"');"">"
				response.write "<a href='javascript:void(0)' class='"&linkspreadclass&"'>"&showHomeSpecialSpread&"</a>"&vbcr
			else 
				response.write ">&nbsp;"
			end if
		else
			if homeSpread <> "" then
				response.write "  onclick=""addbet('1','"&gameid&"','S','"&homeName&"','"&homeSpread&"','"&homeSpreadOdds&"','"&sportid&"','"&leagueid&"','"&homeNum&"');"">"
				response.write "<a href='javascript:void(0)' class='"&linkspreadclass&"'>"&showHomeSpread&"</a>"&vbcr
			else 
				response.write ">&nbsp;"
			end if
		end if
		response.write "</div>"&vbcr

		response.write "<div class='betting-lines-line-line' id='"&gameid&"_3_Un'"
		if underTotal <> "" then
			response.write " onclick=""addbet('3','"&gameid&"','Un','"&homeName&"','"&underTotal&"','"&underTotalOdds&"','"&sportid&"','"&leagueid&"','"&homeNum&"');"">"
			response.write "<a href='javascript:void(0)' class='"&linktotalclass&"'>Un "&showTotalUnder&"</a>"&vbcr
		else 
			response.write ">&nbsp;"
		end if
		response.write "</div>"&vbcr

		response.write "<div class='betting-lines-line-line-ml' id='"&gameid&"_5_ML'"
		if homeML <> "" then
			response.write " onclick=""addbet('5','"&gameid&"','ML','"&homeName&"','0','"&homeML&"','"&sportid&"','"&leagueid&"','"&homeNum&"');"">"
			response.write "<a href='javascript:void(0)' class='"&linkmlclass&"'>"&symbol&Trim(showHomeML)&"</a>"&vbcr
		else 
			response.write ">&nbsp;"
		end if				
		response.write "</div>"&vbcr

		response.write "</div>"&vbcr

	end if
	rs.MoveNext
WEND

rs.Close
set rs = Nothing

c.Close
Set c = Nothing
%>