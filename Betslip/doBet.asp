<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CharSet = "UTF-8" %>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%

pwd = request.QueryString("p")
idlinetype = request.QueryString("idlt")
xml = Session("WagerConfirm")
   
if pwd <> "" and idlinetype <> "" and xml <> "" then

	strxml = xml
	strxml = Replace(strxml,"&amp;amp;frac12;","&amp;frac12;")

	pxml = postbet (strxml,pwd)

	Dim postXML
	Dim ispostValid
	Set postXML = CreateObject("Microsoft.XmlDom")
	ispostValid = postXML.loadXML(pxml)

	if ispostValid then
	
		set x = postXML.getElementsByTagName("xml")
	
		for each objEvent in x
			i=0
			betdesc = ""
			bets = ""
			playerID = objEvent.getAttribute("IdPlayer")
			errorcode = objEvent.getAttribute("ErrorCode")
			errormsgkey = objEvent.getAttribute("ErrorMsgKey")
			errormsg = objEvent.getAttribute("ErrorMsg")
			usefreeplay = objEvent.getAttribute("UseFreePlayAvailable")
			
			if errorcode = 0 then 
            	response.write "<div class='BT-header'><i class='fa fa-caret-square-o-right'></i> BET(S) ACCEPTED</div>"
			else
				response.write "<div class='alert alert-error'>"&errormsg&"</div>"
			end if	
			
			response.write "<div class='BT-allcont'>" &_
                            "<div class='row' style='margin:0px;'>"&_
                                "<div class='col-lg-12 BT-total-header' style='border:none;'>"
			
			set wagers = objEvent.getElementsByTagName("wager")
			
			for each wager in wagers
				amt = wager.getAttribute("Amount")
				risk = wager.getAttribute("Risk")
				win = wager.getAttribute("Win")
				wagerDesc = wager.getAttribute("WagerTypeDesc")
				ticket = wager.getAttribute("TicketNumber")
				wt = wager.getAttribute("WagerType")
				IDWT = wager.getAttribute("IDWT")
				
				if i = 0 then
					response.write wagerDesc&"<br>"
					betdesc = wagerDesc&"<br>"
				end if

				if ticket <> "" then
					response.write "<strong>Ticket Number : "&ticket&"</strong><br />"
				end if
				
				i = i + 1
				
				set details = wager.getElementsByTagName("detail")
				
				for each detail in details
					sport = detail.getAttribute("IdSport")
					desc = detail.getAttribute("Description")
					pitcher = detail.getAttribute("Pitcher")
					vPitcher = detail.getAttribute("VisitorPitcher")
					hPitcher = detail.getAttribute("HomePitcher")
					desc = Replace(desc,"&amp;frac12;","&frac12;")
					teamdesc = detail.getAttribute("TeamDescription")
					gameid = detail.getAttribute("IdGame")
					play = detail.getAttribute("Play")
					line = detail.getAttribute("Points")
					odds = detail.getAttribute("Odds")
					bp = detail.getAttribute("PointsPurchased")
					if sport = "MLB" then
						pitcherDesc = ""
						Select Case pitcher
							Case 0
								pitcherDesc = "Action"
							Case 1
								pitcherDesc = vPitcher&" / Action"
							Case 2
								pitcherDesc = "Action / "&hPitcher
							Case 3
								pitcherDesc = vPitcher&" / "&hPitcher
						End Select
						desc = desc &"<br>("&pitcherDesc&")"
					end if
					
					if errormsgkey = "GAMELINECHANGE" then

						Set rs = CreateObject("ADODB.Recordset")
						sqlStr = "EXECUTE [GameValues_GetForLineChange] @IdGame = "&gameid&", @IdLineType = "&idlinetype

						rs.Open sqlStr, c
					
						if not rs.EOF  then
							select case play
								case 0
									newline = rs("VisitorSpread")
									newodds = rs("VisitorSpreadOdds")
								case 1
									newline = rs("HomeSpread")
									newodds = rs("HomeSpreadOdds")
								case 2
									newline = "-"&rs("TotalOver")
									newodds = rs("OverOdds")
								case 3
									newline = rs("TotalUnder")
									newodds = rs("UnderOdds")
								case 4
									newline = "0"
									newodds = rs("VisitorOdds")
								case 5
									newline = "0"
									newodds = rs("HomeOdds")
								case else
									newline = ""
									newodds = ""
							end select
						end if
						
						rs.Close
						Set rs = Nothing
						if IsNull(newodds) then
							newodds = odds
						end if
						bet_id = gameid&"_"&play&"_"&newline&"_"&newodds&"_"&amt&"_"&bp
						bets = bets&bet_id&","
						
						old_line = line&" "&odds
						new_line = newline&" "&newodds
						
						if Trim(old_line) = Trim(new_line) then
							response.write desc&"<br>"
						else
							response.write teamdesc&" <strong> "&newline&" "&newodds&" </strong> "&"<br>"
						end if
						
					else
						response.write desc&"<br>"
						betdesc = betdesc & desc &"<br>"
					end if

				next
				
				if ticket <> "" then
					if usefreeplay = "True" then
					response.write "Risk: 0 Win: "&win&"<hr />"
					betdesc = betdesc & "Risk: 0 Win: "&win&"<hr />"
					else
					response.write "Risk: "&risk&" Win: "&win&"<hr />"
					betdesc = betdesc & "Risk: "&risk&" Win: "&win&"<hr />"
					end if
				end if
			
			next
			
			if errorcode = 0 then
				'doemail = sentEmail(playerID)
				'if doemail then
					'response.write betdesc
				'	betdesc = replace(betdesc,"+","&#43;")
				'	SendEmailBet playerID,betdesc
				'end if
				
				response.write "<button type='button' class='btn btn-sm btn-block btn-primary' id='pwd_button' onClick='remove_all()'>Start New Bet</button>"
				response.write "<script>refreshBalance()</script>"
			end if
			
			if errormsgkey = "GAMELINECHANGE" then
				response.write "<hr>"
				response.write "<span><button type='button' class='btn btn-small' onClick='remove_all()'>Cancel Bet(s)</button></span>"	
				response.write "<span class='pull-right'><button type='button' class='btn btn-small btn-inverse' id='pwd_button' onClick='dobetafterchanges("""&bets&""","""&pwd&""","""&wt&""","""&IDWT&""")'>Accept Change(s)</button></span>"
			end if

			response.write "</div></div></div>"
		next
	end if	
else
	response.write "error"
end if

Session.Contents.Remove("WagerConfirm")
c.Close()
Set c = Nothing
%>