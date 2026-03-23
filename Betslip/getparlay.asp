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
wagerType = request.QueryString("wt")
cb = request.QueryString("cb")
openspots = request.QueryString("os")
fp = request.QueryString("fp")
parlayLimit = 0
spreadDogs = 0
errMsg = ""
teams = 0

    %>
<script>
t = '<%= tempxml %>';
$('#currentXML').val(t);
	jQuery(document).ready(function () {
		$("#cnfpwd").val($("#p").val());	
    });
</script>
<%

if openspots = "-1" and wagerType = 1 then %>
    <div class="row">
        <div class="col-xs-12">
            <div class="form-group" id="grpopen">
                <label for="openspots" class="control-label form-label labelInput col-xs-6">Open Spots</label>
                <div class="col-xs-6">
                <input class="form-control input-sm BT-dkAmount" name="openspots" id="openspots" type="number" min="0" placeholder="0" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
                </div>
            </div>
        </div>
	</div>
    <div class="row padding-t-10">
        <div class="col-xs-6">
            <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL</button>
        </div>
        <div class="col-xs-6">
            <button type="button" class="btn btn-success btn-sm-slip btn-block" id="place_parlay_button" onClick="start_parlay('<%=wagerType%>')">CONTINUE</button>
        </div>
    </div>
<%
else 

	array_count = betCounter-1
	Dim bet_array()
	prm = ""
	bet_id = ""
	i = 0
	z = 0
	o = ""
	
	ReDim bet_array(array_count,5)
	
	picks = Split(b,",")
	
	'response.write UBound(picks)
	
	for each x in picks
		picksx = Split(x,"_")
		for each y in picksx
			bet_array(i,z) = y
	'		response.write i&"-"&z&"-"&y&"<br>"
			z = z + 1
		next
		i = i + 1
		z = 0
	next
	
	idwagertype = getIdWagerType (idp,wagerType,betCounter)
	
	for i = 0 to array_count
		prm = prm & bet_array(i,1)&","&bet_array(i,0)&","&bet_array(i,2)&","&bet_array(i,3)&"@-@"
		bet_id = bet_id & Trim(bet_array(i,0))&"_"&Trim(bet_array(i,1))&"_"&Trim(bet_array(i,2))&"_"&Trim(bet_array(i,3))&"|"
		if bet_array(i,0) = 0 or bet_array(i,0) = 1 then
			if bet_array(i,2) > 0 then
			end if
		end if
	'	response.write "play:"&bet_array(i,0)&" odds;"&bet_array(i,2)&"<br/>"
	next
	
	'response.write b&"<br/>"&idp&" "&idwagertype&" "&openspots&" "&betCounter&" "&parlayLimit
	response.write "<input type='hidden' name='bet_id' id='bet_id' value='"&bet_id&"' />"
	
	xml = compilebet (prm,pid,idc,wagerType,openspots,idwagertype)
	
	'response.write "<br>"
	'response.write xml
	Dim ndXML
	Dim isValid
	Set ndXML = CreateObject("Microsoft.XmlDom")
	isValid = ndXML.loadXML(xml)
	
	'if isValid and a = 0 and errMsg = "" then
	if isValid and a = 0 then
	
		set x = ndXML.getElementsByTagName("xml")
	
		for each objEvent in x
			errorcode = objEvent.getAttribute("ErrorCode")
			errormsg = objEvent.getAttribute("ErrorMsg")
			freeplay = objEvent.getAttribute("FreePlayAvailable")
			icounter = 0
			if errorcode = 0 then
	
				set wager = objEvent.getElementsByTagName("wager")
					for each wagers in wager
					if icounter = 0 then 
						response.write "<div class='BT-header'> <i class='fa fa-caret-square-o-right'></i> "&wagers.getAttribute("WagerTypeDesc")&" </div>"
						
						if wagerType = 5 then
							response.write "<div class='row padding-t-10'><div class='col-xs-12'>"
							response.write "<div class='form-group' style='margin-bottom:0px;'>"
							getRRCombo(betCounter)
							response.write "</div></div></div>"
						end if	
						response.write "</div>"
					end if
					icounter = 1
	'				response.write wagers.getAttribute("WagerTypeDesc")&"<br>"
					set detail = wagers.getElementsByTagName("detail")
	
					for each details in detail
						sport = details.getAttribute("IdSport")
						choosePitcher = details.getAttribute("CanChoosePitcher")
						vPitcher = details.getAttribute("VisitorPitcher")
						hPitcher = details.getAttribute("HomePitcher")
						isML = details.getAttribute("IsMLine")
						gameid = details.getAttribute("IdGame")
						play = details.getAttribute("Play")
						points = details.getAttribute("Points")
						odds = details.getAttribute("Odds")
						desc = details.getAttribute("Description")
						team = details.getAttribute("TeamDescription")
						line = details.getAttribute("LineDescription")
						desc = Server.HTMLEncode(desc)
						desc = Replace(desc,"&amp;frac12;","&frac12; ")
						line = Replace(line,"o","Ov ")
						line = Replace(line,"u","Un ")
						bet_id = play&"_"&gameid
	
						o = o&CStr(odds)&","
						'response.write desc&"<br>"
						%>
                        <div class="BT-allcont">
                            <div class="row">
                                <div class="col-xs-12 BT-total-header">
                                    <!--<div class="col-xs-10 colPadding text-left"><%=team&" <strong>"&line&"</strong>"%></div>-->

									<div class="col-xs-12 colPadding text-left">
										<strong><%= team %> <br />
										<% If CInt(play) <= 3 Then %>
											<input type="text" id="points_<%=play%>_<%=gameid%>" value="<%=points%>" style="width:60px;text-align:center;margin-left:6px;" onkeyup="updateBetAndLine('<%=play%>','<%=gameid%>')" />
										<% End If %>

										<input type="text" id="odds_<%=play%>_<%=gameid%>" value="<%=odds%>" style="width:70px;text-align:center;margin-left:4px;" onkeyup="updateBetAndLine('<%=play%>','<%=gameid%>')" />
										</strong>
									</div>

                                    <div class="col-xs-2 colPadding text-right"><i class='fa fa-times removeBet'></i></div>
                                </div>
    
						<%
	
						if sport = "MLB" and choosePitcher then
							response.write "<div class='form-group' style='margin-bottom:0px;'><div class='col-xs-12'>"
							response.write "<select name='bp_"&bet_id&"' id='bp_"&bet_id&"' class='form-control selectpicker'>"&vbcr
							response.write "<option value='0' selected='selected'>Action</option>"&vbcr
							response.write "<option value='3'>"&vPitcher&" / "&hPitcher&"</option>"&vbcr
							response.write "<option value='1'>"&vPitcher&" / Action</option>"&vbcr
							response.write "<option value='2'>Action / "&hPitcher&"</option>"&vbcr
							response.write "</select></div></div>"&vbcr
						end if
						
						set buypoints = details.getElementsByTagName("buypoints")
						if buypoints.length > 0 then
							response.write "<div class='form-group' style='margin-bottom:0px;'><div class='col-xs-12'>"
							response.write "<select name='bp_"&bet_id&"' id='bp_"&bet_id&"' class='form-control selectpicker'>"&vbcr
							response.write "<option value='0' selected='selected'>Buy 0 Points</option>"&vbcr
							for each bp in buypoints
								response.write "<option value='"&bp.getAttribute("BuyPoints")&"'>Buy "&bp.getAttribute("BuyPointsDesc")&" Points</option>"&vbcr
							next
							response.write "</select>"&vbcr
							response.write "</div></div>"&vbcr
						end if	
	
						%>

                            </div>
                        </div>
					<% next
				next
	
				if openspots = 0 and wagerType = 1 then %>
				<div class="BT-allcont">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="form-group">
                                <label for="openspots" class="control-label form-label labelInput col-xs-6">Open Spots</label>
                                <div class="col-xs-6">
                                <input class="form-control input-sm BT-dkAmount" name="openspots" id="openspots" type="number" min="0" value="0" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
                                </div>
                            </div>
                        </div>
				<% else
					response.write "<input name='openspots' type='hidden' id='openspots' value='"&openspots&"' />"
				end if %>
                	</div>
                    <div class="row padding-t-10">
                        <div class="col-xs-12">
                            <div class="form-group" id="grpamt">
                                <label for="p_risk" class="control-label form-label labelInput col-xs-6">Amount</label>
                                <div class="col-xs-6">
                                	<input class="form-control input-sm BT-dkAmount" name="p_risk" id="p_risk" type="number" onKeyUp="p_cnt(event)" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
				<div class="row padding-t-10">
                    <div class="col-lg-4 col-xs-2">
                        &nbsp;
                    </div>
                    <div class="col-lg-8 col-xs-8">
                        <button type="submit" class="btn btn-warning btn-sm-slip btn-block" onClick="goStart()">CHANGE PICKS</button>
                    </div>
                </div>
                <div class="row padding-t-10">
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL</button>
                    </div>
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-success btn-sm-slip btn-block" id="place_parlay_button" onClick="place_parlay('<%=wagerType%>',true)">CONTINUE</button>
                    </div>
                </div>
			<% else %>
                <div class="row">
                	<div class="col-xs-12">
                    	<div class="kode-alert alert6"><%=errormsg%></div>
                    </div>
                </div>
                <div class="row padding-t-5 padding-b-5">
                    <!--div class="col-xs-6">
                        <button type="submit" class="btn btn-warning btn-sm btn-block btn-block" onClick="changePicks()">CHANGE PICKS</button>
                    </div-->
                    <div class="col-xs-12">
                        <button type="button" class="btn btn-danger btn-sm btn-danger btn-block" onClick="remove_all()">CANCEL</button>
                    </div>
                </div>
			<% end if
		next
	'else
	'	response.write "<div class='alert alert-danger'>Error : "&errMsg&"</div>"
	'	response.write "<button type='button' class='btn btn-warning' onClick='changePicks()'>Go Back</button>"
	end if
	
	if isValid and a = 1 then
	
		if openspots > 0 then
			array_count = array_count + openspots
		end if
	
		if fp = 1 then
			ndXML.selectNodes("//xml")(0).attributes(14).value = "True"
		end if
	
		set w = ndXML.selectNodes("//wager")
	
		x = 0
	
		for each ww in w
			ww.attributes(8).value = Int(bet_array(x,4))
	'		ww.setAttribute "Amount",bet_array(0,4)
			x = x+1
		next
		
		if wagerType = 5 then
	
			set w = ndXML.selectNodes("//wager")
		
			for each ww in w
				ww.attributes(13).value = cb
			next	
	
		end if
	
		Dim bet_sport()	
		ReDim bet_sport(array_count)
		x = 0
		set details = ndXML.selectNodes("//detail")
		for each detail in details
			bet_sport(x) = detail.getattribute("IdSport")
	//		response.write x&" "&detail.getattribute("IdSport")&"<br>"
			x = x+1
		next
	
		prmdetails = ""
	
		for x = 0 to array_count
			options = 0
	
			if bet_sport(x) = "MLB" then
				options = 1
			end if
			
			if bet_sport(x) <> "OPENPLAY" then
				if bet_array(x,5) > 0 then
					prmdetails = prmdetails & bet_array(x,1)&","&bet_array(x,0)&","&options&","&bet_array(x,5)&"@-@"
				end if
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
	
		if iscnValid then
		
			set x = cnXML.getElementsByTagName("xml")
				
			for each objEvent in x
				errorcode = objEvent.getAttribute("ErrorCode")
				errormsg = objEvent.getAttribute("ErrorMsg")
				if errorcode = 0 then
					set wager = objEvent.getElementsByTagName("wager")
					for each wagers in wager
						betDesc = ""
						betHead = wagers.getAttribute("WagerTypeDesc")
						if fp = 1 then
							betHead = betHead & " (FREE PLAY)"
						end if
						set detail = wagers.getElementsByTagName("detail")
						risk = wagers.getAttribute("Risk")
						win = wagers.getAttribute("Win")
						for each details in detail
							sport = details.getAttribute("IdSport")
							desc = details.getAttribute("Description")
							pitcher = details.getAttribute("Pitcher")
							vPitcher = details.getAttribute("VisitorPitcher")
							hPitcher = details.getAttribute("HomePitcher")
							
							desc = Replace(desc,"&amp;frac12;","&frac12; ")
							bet_id = play&"_"&gameid&"_"&points&"_"&odds
							
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
								desc = desc &"<br/>("&pitcherDesc&")"
							end if
							
							betDesc = betDesc & desc & "<br>"
						next
						if fp = 1 then
							risk = 0
						end if
					next

					%>
                    <div class="BT-header"> <i class="fa fa-caret-square-o-right"></i> <%=betHead%></div>
                    <div class="BT-allcont">
                        <div class="row" style="margin:0px;">
                            <div class="col-xs-12 BT-total-header" style="border:none;">
                                <p class="text-left" style="margin:0;"><%=betDesc%></p>
                            </div>
                        </div>
                    </div>
                    <div class="BT-Total">
                        <div class="BT-total-header clearfix">Ticket Summary</div>
                        <div class="BT-totalSum"><span>Total Risk:</span><span class="pull-right" id="risk-total"><%= risk %></span></div>
                        <div class="BT-totalSum"><span>Total Potential Win:</span><span class="pull-right" id="win-total"><%= win %></span></div>
                    </div>          
                    <input type="hidden" name="cnfpwd" id="cnfpwd" class="form-control input-sm" onkeyup="submit_bet(event)" />       
					<% if pwd = "" then %>
                    <!--<div class="row padding-t-20 padding-b-10">
                        <div class="col-xs-12">
                            <div class="form-group" id="grppwd">
                                <label for="p_risk" class=" control-label form-label labelInput col-xs-6">Password</label>
                                <div class="col-xs-6">
                                <input type="password" name="cnfpwd" id="cnfpwd" class="form-control input-sm" onkeyup="submit_bet(event)" />
                                </div>
                            </div>
                            <p id="p_pwd" class="text-danger text-center hide"></p>
                        </div>
                    </div>-->
                    <div class="row padding-t-10">
                        <div class="col-lg-4 col-xs-6"></div>
                        <div class="col-lg-8 col-xs-6">
                            <a href="javascript:;" class="btn btn-warning btn-sm-slip btn-block" onClick="changeAmount('p_risk')">Modify Amount</a>
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
					response.write "<button type='button' class='btn btn-warning' onClick='goback(0)'>Go Back</button>"
				end if
			next
		end if	
	
	end if

end if 
c.Close()
Set c = Nothing
%>