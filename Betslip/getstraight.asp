<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%

idp = request.QueryString("idp")
pid = request.QueryString("pid")
idc = request.QueryString("idc")
a = request.QueryString("amt")
b = request.QueryString("b")
pwd = request.QueryString("p")
betCounter = request.QueryString("c")
fp = request.QueryString("fp")

array_count = betCounter-1
Dim bet_array()
prm = ""
bet_id = ""
i = 0
z = 0

ReDim bet_array(array_count,5)

picks = Split(b,",")

for each x in picks
	picksx = Split(x,"_")
	for each y in picksx
		bet_array(i,z) = y
		z = z + 1
	next
	i = i + 1
	z = 0
next

wager_type = 0
idwagertype = getIdWagerType (idp,wager_type,0)
open_spots = 0

for i = 0 to array_count
	prm = prm & bet_array(i,1)&","&bet_array(i,0)&","&bet_array(i,2)&","&bet_array(i,3)&"@-@"
	bet_id = bet_id & Trim(bet_array(i,0))&"_"&Trim(bet_array(i,1))&"_"&Trim(bet_array(i,2))&"_"&Trim(bet_array(i,3))&"|"
next

response.write "<input type='hidden' name='bet_id' id='bet_id' value='"&bet_id&"'>"

xml = compilebet (prm,pid,idc,wager_type,open_spots,idwagertype)

Dim ndXML
Dim isValid
Set ndXML = CreateObject("Microsoft.XmlDom")
isValid = ndXML.loadXML(xml)

if isValid and a = 0 then

	set x = ndXML.getElementsByTagName("xml")

	for each objEvent in x
		errorcode = objEvent.getAttribute("ErrorCode")
		errormsg = objEvent.getAttribute("ErrorMsg")
		freeplay = objEvent.getAttribute("FreePlayAvailable")
		
		if errorcode = 0 then
			
			set wager = objEvent.getElementsByTagName("wager")
			
			%>
            <div class="BT-header"> <i class="fa fa-caret-square-o-right"></i> Straight Bet </div>
            <div class="BT-allcont"> 
                <div class='row'>
                    <div class="form-group">
                        <label for="betall" class="control-label form-label labelInput col-xs-2 col-sm-6">Bet</label>
                        <div class="col-xs-4 col-sm-6">
                            <input type="text" class="form-control input-sm BT-dkAmount" id="betall" placeholder="0.00" onkeypress="return isNumber(event)" onblur="betall_apply(event)" pattern="[0-9]*" inputmode="numeric" />
                        </div>
                        <div class="col-xs-6 col-sm-12">
                            <button type="submit" class="btn btn-primary btn-sm-slip btn-block" id="bet_all_apply" onClick="apply_riskAmt()">Set All</button>
                        </div>
                    </div>
                </div>
            </div>
            <%
			i = 0
			for each wagers in wager

				set detail = wagers.getElementsByTagName("detail")
				
				for each details in detail
					sport = details.getAttribute("IdSport")
					choosePitcher = details.getAttribute("CanChoosePitcher")
					vPitcher = details.getAttribute("VisitorPitcher")
					hPitcher = details.getAttribute("HomePitcher")
					isML = details.getAttribute("IsMLine")
					gameid = details.getAttribute("IdGame")
					play = details.getAttribute("Play")
					points = details.getAttribute("OriginalPoints")
					period = details.getAttribute("Period")
					odds = details.getAttribute("OriginalOdds")
					desc = details.getAttribute("Description")
					team = details.getAttribute("TeamDescription")
					line = details.getAttribute("LineDescription")
					desc = Server.HTMLEncode(desc)
					desc = Replace(desc,"&amp;frac12;","&frac12; ")
					desc = Replace(desc,"&frac14;",".25 ")
					desc = Replace(desc,"&frac34;",".75 ")
					bet_id = play&"_"&gameid&"_"&points&"_"&odds
					
					if a = 0 then %>
                    <div class='BT-allcont'>
                        <div class='row'>
                            <div class="col-xs-12 BT-total-header">
                               
								<!--<div class="col-xs-12 colPadding text-left"><strong><%=team&" "&line &" |"&points&odds%></strong></div>
								-->

								<div class="col-xs-12 colPadding text-left">
								  <strong>
									<%= team %> 
								  <% If CInt(play) <= 3 Then %>
									<input type="text"
										   id="points_<%=play%>_<%=gameid%>"
										   value="<%=points%>"
										   style="width:60px;text-align:center;margin-left:6px;"
										   onkeyup="updateBetAndLine('<%=play%>','<%=gameid%>')" />
								  <% End If %>

								  <input type="text"
										 id="odds_<%=play%>_<%=gameid%>"
										 value="<%=odds%>"
										 style="width:70px;text-align:center;margin-left:4px;"
										 onkeyup="updateBetAndLine('<%=play%>','<%=gameid%>')" />
									  </strong>
								</div>



                                <!--<div class="col-xs-2 colPadding text-right"><i class='fa fa-times removeBet'></i></div>-->
                            </div>

                            <div class="col-lg-12">
                                <div class="form-horizontal">
                                    <div class="form-group padding-b-5" style="margin-bottom:0px;">
                                      <label class="col-xs-2 control-label form-label labelInput">Risk:</label>
                                      <div class="col-xs-4">
                                        <input name="risk_<%=bet_id%>" type="text" class="form-control input-sm BT-dkAmount risk" id="risk_<%=bet_id%>" onKeyUp="r_amt(this.id,'<%=odds%>','win_<%=bet_id%>')" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
                                      </div>
                                      <label class="col-xs-2 control-label form-label labelInput">Win:</label>
                                      <div class="col-xs-4">
                                        <input name="win_<%= bet_id%>" type="text" class="form-control input-sm BT-dkAmount win" id="win_<%=bet_id%>" onKeyUp="w_amt(this.id,'<%=odds%>','risk_<%=bet_id%>')" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
                                      </div>
                                    </div>
                                    <%
                                    set buypoints = details.getElementsByTagName("buypoints")
                                    if buypoints.length > 0 then
                                        response.write "<div class='form-group' style='margin-bottom:0px;'><div class='col-xs-12'>"
										response.write "<select name='bp_"&bet_id&"' id='bp_"&bet_id&"' class='selectpicker form-control'>"&vbcr
                                        response.write "<option value='0' selected='selected'>Buy 0 Points</option>"&vbcr
                                        for each bp in buypoints
                                            response.write "<option value='"&bp.getAttribute("BuyPoints")&"'>Buy "&bp.getAttribute("BuyPointsDesc")&" Points</option>"&vbcr
                                        next
                                        response.write "</select>"&vbcr
										response.write "</div></div>"
                                    end if
                                    if sport = "MLB" and choosePitcher then
                                        response.write "<div class='form-group' style='margin-bottom:0px;'><div class='col-xs-12'>"
										response.write "<select name='bp_"&bet_id&"' id='bp_"&bet_id&"' class='selectpicker form-control'>"&vbcr
                                        response.write "<option value='0' selected='selected'>Action</option>"&vbcr
                                        response.write "<option value='3'>"&vPitcher&" / "&hPitcher&"</option>"&vbcr
                                        response.write "<option value='1'>"&vPitcher&" / Action</option>"&vbcr
                                        response.write "<option value='2'>Action / "&hPitcher&"</option>"&vbcr
                                        response.write "</select>"&vbcr
										response.write "</div></div>"
                                    end if				
                                    %>
                                </div>
                            </div>  
                        </div>
                    </div>
					<% 
					end if
					i = i + 1
				next
			next
			%>
			<% if freeplay > 0 then %>
			<div class="BT-allcont">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="checkbox float-l">
                            <input id="freeplay" type="checkbox" name="freeplay">
                            <label for="freeplay">
                                Use Free play (<%= freeplay %>)
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <% end if %>
			<div class="BT-Total">
                <div class="BT-total-header clearfix">Ticket Summary</div>
                <div class="BT-totalSum"><span>Total Active Bets:</span><span class="pull-right"><%= i %></span></div>
                <div class="BT-totalSum"><span>Total Risk:</span><span class="pull-right" id="risk-total">0.00</span></div>
                <div class="BT-totalSum"><span>Total Potential Win:</span><span class="pull-right" id="win-total">0.00</span></div>
            </div>
			<div class="row padding-t-5 margin-y-10">
                <div class="col-xs-6">
                    <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL</button>
                </div>
                <div class="col-xs-6">
                    <button type="button" class="btn btn-success btn-sm-slip btn-block" id="place_straight_button" onClick="place_straight()">OK</button>
                </div>
            </div>
            <%
		else
			response.write "<div class='alert alert-danger'>Error : "&errormsg&"</div>"
			response.write "<a href='javascript: void(0)' onClick='changePicks()' class='btn btn-inverse'>Go Back</a>"
		end if
	next

end if	

if isValid and a = 1 then
	
	prmdetails = ""
	
	if fp = 1 then
		ndXML.selectNodes("//xml")(0).attributes(14).value = "True"
	end if
	
	set w = ndXML.selectNodes("//wager")

	x = 0

	for each ww in w
		ww.attributes(8).value = Int(bet_array(x,4))
		x = x+1
	next

	Dim bet_sport()	
	ReDim bet_sport(array_count)
	x = 0
	set details = ndXML.selectNodes("//detail")
	for each detail in details
		bet_sport(x) = detail.getattribute("IdSport")
		x = x+1
	next	
	
	for x = 0 to array_count
		options = 0
		if bet_sport(x) = "MLB" then
			options = 1
		end if

		if bet_array(x,5) > 0 then
			prmdetails = prmdetails & bet_array(x,1)&","&bet_array(x,0)&","&options&","&bet_array(x,5)&"@-@"
		end if
	next

	set Node = ndXML.selectSingleNode("//xml")
	strxml = Node.xml
	
	confirm = confirmbet (strxml,prmdetails)
	
	Dim cnXML
	Dim iscnValid
	Set cnXML = CreateObject("Microsoft.XmlDom")
	iscnValid = cnXML.loadXML(confirm)

	set tempNode = cnXML.selectSingleNode("//xml")
	tempxml = tempNode.xml
	Session("WagerConfirm") = tempxml
	
'	response.write "["&tempxml&"]"

%>
<script>
t = '<%= tempxml %>';
$('#currentXML').val(t);
	jQuery(document).ready(function () {
		$("#cnfpwd").val($("#p").val());	
    });
</script>
<%

	if iscnValid then
	
		set x = cnXML.getElementsByTagName("xml")
		
		riskamt = 0
		winamt = 0
		
		for each objEvent in x
			errorcode = objEvent.getAttribute("ErrorCode")
			errormsg = objEvent.getAttribute("ErrorMsg")
			if errorcode = 0 then %>
            <div class="BT-header"> <i class="fa fa-caret-square-o-right"></i> <%= betCounter %> Straight Bet(s)
            <% if fp = 1 then
					response.write " (FREE PLAY)"
				end if
			%>
            </div>
            <%		
				set wager = objEvent.getElementsByTagName("wager")

				for each wagers in wager
					set detail = wagers.getElementsByTagName("detail")
					risk = wagers.getAttribute("Risk")
					win = wagers.getAttribute("Win")
					
					for each details in detail
						riskamt = riskamt + risk
						winamt = winamt + win
						sport = details.getAttribute("IdSport")
						desc = details.getAttribute("Description")
						desc = Server.HTMLEncode(desc)
						pitcher = details.getAttribute("Pitcher")
						vPitcher = details.getAttribute("VisitorPitcher")
						hPitcher = details.getAttribute("HomePitcher")
						desc = Replace(desc,"&amp;frac12;","&frac12; ")
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
						bet_id = play&"_"&gameid&"_"&points&"_"&odds
						%>
						<div class="BT-allcont">
                            <div class="row" style="margin:0px;">
                                <div class="col-xs-12 BT-total-header" style="border:none;">
                                    <p class="text-left" style="margin:0;"><strong><%= desc %></strong><br/>
                                    Risk: <%= Risk %> / Win: <%= win %></p>
                                </div>
                            </div>
                        </div>
						<%
					next
					
				next

				if fp = 1 then
					riskamt = 0
				end if
				
				%>
                <div class="BT-Total">
                    <div class="BT-total-header clearfix">Ticket Summary</div>
                    <div class="BT-totalSum"><span>Total Active Bets:</span><span class="pull-right"><%= betCounter %></span></div>
                    <div class="BT-totalSum"><span>Total Risk:</span><span class="pull-right" id="risk-total"><%= riskamt %></span></div>
                    <div class="BT-totalSum"><span>Total Potential Win:</span><span class="pull-right" id="win-total"><%= winamt %></span></div>
                </div>
				<input type="hidden" name="cnfpwd" id="cnfpwd" class="form-control input-sm" onkeyup="submit_bet(event)" />
                            

				<% if pwd = "" then %>
                <!--<div class="row padding-t-20 padding-b-10">
                    <div class="col-xs-12">
                        <div class="form-group" id="grppwd">
                            <label for="p_risk" class=" control-label form-label labelInput col-xs-6">Password</label>
                            <div class="col-xs-6">
                            <input type="hidden" name="cnfpwd" id="cnfpwd" class="form-control input-sm" onkeyup="submit_bet(event)" />
                            </div>
                        </div>
                        <p id="p_pwd" class="text-danger text-center hide"></p>
                    </div>
                </div>-->
                
                </div>
				<div class="row padding-t-10">
                    <div class="col-xs-2"></div>
                    <div class="col-xs-8">
                    	<a href="javascript:;" class="btn btn-warning btn-sm-slip btn-block" onClick="changeAmount('betall')">MODIFY BETS</a>
                    </div>
				</div>
                <div class="row padding-t-10">
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL</button>
                    </div>
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-success btn-sm-slip btn-block" id="place_straight_button" onClick="dobet()">CONFIRM</button>
                    </div>
                </div>
                <%

				end if
				
			else
				response.write "<div class='alert alert-danger'>Error : "&errormsg&"</div>"
				response.write "<button type='button' id='gobackButton' class='btn btn-warning' onClick='goback(0)'>Go Back</button>"
			end if
		next
	end if	

end if

c.Close
Set c = Nothing
%>