<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%

b = Request.QueryString("bets")
pwd = Request.QueryString("p")
pid = Request.QueryString("pid")
idc = Request.QueryString("idc")
wt = Request.QueryString("wt")
idwt = Request.QueryString("idwt")
idlinetype = request.QueryString("idlt")
open_spots = 0
prmdetails = ""

if b <> "" then

	Dim bet_array()

	b = Left(b,Len(b)-1) 

	picks = Split(b,",")
	
	array_count = UBound(picks)

	ReDim bet_array(array_count,5)
	
	for i = 0 to array_count
		p = Split(picks(i),"_")
		gameid = p(0)
		play = p(1)
		points = p(2)
		odds = p(3)
		bet_array(i,0) = p(0)
		bet_array(i,1) = p(1)
		bet_array(i,2) = p(2)
		bet_array(i,3) = p(3)
		bet_array(i,4) = p(4)
		bet_array(i,5) = p(5)
		prmdetails = prmdetails&gameid&","&play&","&points&","&odds&"@-@"
	next

	xml = compilebet (prmdetails,pid,idc,wt,open_spots,idwt)

	Dim ndXML
	Dim isValid
	Set ndXML = CreateObject("Microsoft.XmlDom")
	isValid = ndXML.loadXML(xml)

	prmdetails = ""
	
	set wagers = ndXML.selectNodes("//wager")

	x = 0

	for each wager in wagers
		wager.attributes(8).value = Int(bet_array(x,4))
'		ww.setAttribute "Amount",bet_array(0,4)
		x = x+1
	next

	for x = 0 to array_count
		if bet_array(x,5) > 0 then
			prmdetails = prmdetails & bet_array(x,1)&","&bet_array(x,0)&",0,"&bet_array(x,5)&"@-@"
		end if
	next

'	response.write prmdetails
'	response.write ndXML.xml
'	ndResponse = Replace(ndResponse,"&lt;","<")
'	ndResponse = Replace(ndResponse,"&gt;",">")
	set Node = ndXML.selectSingleNode("//xml")
	strxml = Node.xml

	'response.write strxml
	'strxml = Replace(strxml,"&amp;amp;frac12;","&amp;frac12;")
	'strxml = Replace(strxml,"<","&lt;") 
	'strxml = Replace(strxml,">","&gt;") 
	'strxml = CStr(strxml)
	
	'response.write strxml&vbcr
	
	confirm = confirmbet (strxml,prmdetails)
	
	Dim cnXML
	Dim iscnValid
	Set cnXML = CreateObject("Microsoft.XmlDom")
	iscnValid = cnXML.loadXML(confirm)

	set tempNode = cnXML.selectSingleNode("//xml")
	strxml = tempNode.xml

'	response.write strxml
	strxml = Replace(strxml,"&amp;amp;frac12;","&amp;frac12;")
'	strxml = Replace(strxml,"<","&lt;") 
'	strxml = Replace(strxml,">","&gt;") 
'	strxml = CStr(strxml)
	
'	response.write strxml&vbcr

	pxml = postbet (strxml,pwd)

	Dim postXML
	Dim ispostValid
	Set postXML = CreateObject("Microsoft.XmlDom")
	ispostValid = postXML.loadXML(pxml)

	if ispostValid then
	
		set x = postXML.getElementsByTagName("xml")
	
		for each objEvent in x
			i=0
			bets = ""
			errorcode = objEvent.getAttribute("ErrorCode")
			errormsgkey = objEvent.getAttribute("ErrorMsgKey")
			errormsg = objEvent.getAttribute("ErrorMsg")
			
			if errorcode = 0 then
				response.write "<div class='row row-margin'><div class='col-lg-12'><h3>BET(s) ACCEPTED</h3></div></div>"
			else
				response.write "<div class='alert alert-error'>"&errormsg&"</div>"
			end if	
			
			response.write "<div class='row row-margin'><div class='col-lg-12'>"
			
			set wagers = objEvent.getElementsByTagName("wager")
			
			for each wager in wagers
				amt = wager.getAttribute("Amount")
				risk = wager.getAttribute("Risk")
				win = wager.getAttribute("Win")
				wagerDesc = wager.getAttribute("WagerTypeDesc")
				ticket = wager.getAttribute("TicketNumber")
				wt = wager.getAttribute("WagerType")
				IDWT = wager.getAttribute("IDWT")
				
				if ticket <> "" then
					response.write "<strong>Ticket Number : "&ticket&"</strong>"
				end if
				
				if i = 0 then
					response.write wagerDesc&"<br>"
				end if
				
				i = i + 1
				
				set details = wager.getElementsByTagName("detail")
				
				for each detail in details
					
					desc = detail.getAttribute("Description")
					desc = Replace(desc,"&amp;frac12;","&frac12;")
					teamdesc = detail.getAttribute("TeamDescription")
					gameid = detail.getAttribute("IdGame")
					play = detail.getAttribute("Play")
					line = detail.getAttribute("Points")
					odds = detail.getAttribute("Odds")
					bp = detail.getAttribute("PointsPurchased")
					bet_id = gameid&"_"&play&"_"&line&"_"&odds&"_"&amt&"_"&bp
					bets = bets&bet_id&","
					
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
									newline = rs("TotalOver")
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
						
						if play = 2 then
							line = replace(line,"-","")
						end if
						
						old_line = line&" "&odds
						new_line = newline&" "&newodds
						'response.write old_line&" | "&new_line&"<br>"
						if Trim(old_line) = Trim(new_line) then
							response.write desc&"<br>"
						else
							response.write teamdesc&" <strong> "&newline&" "&newodds&" </strong> "&"<br>"
						end if
						
						
					else
						response.write desc&"<br>"
					end if
					'response.write risk&" / "&win&"<br>"
				next
				
				if ticket <> "" then
					response.write "Risk: "&risk&" Win: "&win&"<hr />"
				end if
			
			next
			
			if errorcode = 0 then
				response.write "<button type='button' class='btn btn-small btn-inverse' id='pwd_button' onClick='remove_all()'>Start New Bet</button>"
				'response.write "<script>refreshBalance()</script>"
			end if
			
			if errormsgkey = "GAMELINECHANGE" then
				response.write "<hr>" & Request.ServerVariables("LOCAL_ADDR")
				response.write "<span><button type='button' class='btn btn-small btn-danger' onClick='remove_all()'>Cancel Bet(s)</button></span>"	
				response.write "<span class='pull-right'><button type='button' class='btn btn-small btn-inverse' id='pwd_button' onClick='dobetafterchanges("""&bets&""","""&pwd&""","""&wt&""","""&IDWT&""")'>Accept Change(s)</button></span>"
			end if
			'else
			'	response.write "<div class='alert alert-error'>Error : "&errormsg&"</div>"
			'	response.write "<button type='button' class='btn btn-warning' id='pwd_button' onClick='goback(1)'>Go Back</button>"
			'end if
			response.write "</div></div>"
		next
	end if


end if
c.Close
Set c = Nothing
%>
