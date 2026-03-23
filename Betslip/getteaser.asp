<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CharSet = "UTF-8" %>
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
bet_count = request.QueryString("c")
idwt = request.QueryString("idwt")
idlt = request.QueryString("idlt")
openspots = request.QueryString("os")
fp = request.QueryString("fp")

array_count = bet_count-1
Dim bet_array()
prm = ""
bet_id = ""
i = 0
z = 0

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

wager_type = 2
idwagertype = idwt
teaser = getTeaserInfo (pid,idwt)

'if a = 0 then
'	for i = 0 to array_count
'		sID = getsportID(bet_array(i,1))
'		sID = Trim(sID)
'		if sID = "NFL" then
			'newline = bet_array(i,2)+Int(Session("NFLSide"))
'			newline = bet_array(i,2)+Int(teaser(0))
'		elseif sID = "CFB" then
			'newline = bet_array(i,2)+Int(Session("CFBSide"))
'			newline = bet_array(i,2)+Int(teaser(4))
'		elseif sID = "NBA" then
			'newline = bet_array(i,2)+Int(Session("NBASide"))
'			newline = bet_array(i,2)+Int(teaser(2))
'		elseif sID = "CBB" then
			'newline = bet_array(i,2)+Int(Session("CBBSide"))
'			newline = bet_array(i,2)+Int(teaser(6))
'		end if

'		bet_array(i,2) = newline
'	next
'end if

for i = 0 to array_count
	prm = prm & bet_array(i,1)&","&bet_array(i,0)&","&bet_array(i,2)&","&bet_array(i,3)&"@-@"
	bet_id = bet_id & Trim(bet_array(i,0))&"_"&Trim(bet_array(i,1))&"_"&Trim(bet_array(i,2))&"_"&Trim(bet_array(i,3))&"|"
next

response.write "<input type='hidden' name='bet_id' id='bet_id' value='"&bet_id&"'>"

xml = compilebet (prm,pid,idc,wager_type,openspots,idwagertype)

'response.write xml

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
			for each wagers in wager
				allowTeaserBuyPoints = wagers.getAttribute("TeaserCanBuyHalf")

				response.write "<div class='BT-header'> <i class='fa fa-caret-square-o-right'></i> "&wagers.getAttribute("WagerTypeDesc")&" </div>"
				betDesc = ""
				set detail = wagers.getElementsByTagName("detail")

				for each details in detail
					gameid = details.getAttribute("IdGame")
					play = details.getAttribute("Play")
					points = details.getAttribute("OriginalPoints")
					odds = details.getAttribute("OriginalOdds")
					desc = details.getAttribute("Description")
					desc = Server.HTMLEncode(desc)
					desc = Replace(desc,"&amp;frac12;","&frac12; ")
                    desc = Replace(desc,"&nbsp;","")
                    desc = Replace(desc,"<SUP>","")
                    desc = Replace(desc,"</SUP>","")
					bet_id = play&"_"&gameid&"_"&points&"_"&odds
					betDesc = betDesc&desc&"<br />"
				next
			next
			%>
			<div class="BT-allcont">
				<div class="row" style="margin:0px;">
					<div class="col-xs-12 BT-total-header" style="border:none;">
						<p class="text-left" style="margin:0;"><%=betDesc%></p>
					</div>
					<%
                    if allowTeaserBuyPoints = 0 then
                        response.write "<input type='hidden' name='TeaserBuyPoints' id='TeaserBuyPoints' value='0' />"
                    else
                        response.write "<div class='form-group' style='margin-bottom:0px;'><div class='col-xs-12'>"
						response.write "<select name='TeaserBuyPoints' id='TeaserBuyPoints' class='form-control selectpicker'>"
                        response.write "<option value='0' selected='selected'>Buy 0 points</option>"
                        response.write "<option value='0.5'>Buy &frac12; point</option><option value='1'>Buy 1 point</option></select>"	
						response.write "</div></div>"		
                    end if
                    %>
				</div>
			</div>
            <div class="BT-allcont">
                <div class="row padding-t-10">
                    <div class="col-xs-12">
                        <div class="form-group" id="grpamt">
                            <label for="p_risk" class="control-label form-label labelInput col-xs-6">Amount</label>
                            <div class="col-xs-6">
                                <input class="form-control input-sm BT-dkAmount" name="t_risk" id="t_risk" type="number" onKeyUp="t_amt(event)" onkeypress="return isNumber(event)" pattern="[0-9]*" inputmode="numeric" />
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
                <div class="col-xs-6">
                    <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL BET</button>
                </div>
                <div class="col-xs-6">
                    <button type="button" class="btn btn-success btn-sm-slip btn-block" id="placeTeaserButton" onClick="place_teaser('<%=idwt%>',<%= openspots %>)">PLACE BET</button>
                </div>
            </div>

		<% else
			response.write "<div class='alert alert-danger'>Error : "&errormsg&"</div>"
			response.write "<button type='button' class='btn btn-warning' onClick='goback(1)'>Go Back</button>"
		end if
	next
end if	

if isValid and a = 1 then
	
%>
<script>
t = '<%= tempxml %>';
$('#currentXML').val(t);
	jQuery(document).ready(function () {
		$("#cnfpwd").val($("#p").val());	
    });
</script>
<%
	
'	if openspots > 0 then
'		array_count = array_count + openspots
'	end if

	if fp = 1 then
		ndXML.selectNodes("//xml")(0).attributes(14).value = "True"
	end if

	set w = ndXML.selectNodes("//wager")

	x = 0

	for each ww in w

		ww.attributes(6).value = bet_array(x,5)
		ww.attributes(8).value = Int(bet_array(x,4))
'		ww.setAttribute "Amount",bet_array(0,4)
		x = x+1
	next

	for x = 0 to array_count
		if bet_array(x,5) > 0 then
			prmdetails = prmdetails & bet_array(x,1)&","&bet_array(x,0)&",0,"&bet_array(x,5)&"@-@"
		end if
	next

	set Node = ndXML.selectSingleNode("//xml")
	strxml = Node.xml
	
	confirm = confirmbet (strxml,"")
	
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
						betHead = betHead&" (FREE PLAY)"
					end if
					set detail = wagers.getElementsByTagName("detail")
					risk = wagers.getAttribute("Risk")
					win = wagers.getAttribute("Win")
					for each details in detail
						desc = details.getAttribute("Description")
						desc = Replace(desc,"&amp;frac12;",".5 ")
						bet_id = play&"_"&gameid&"_"&points&"_"&odds
						betDesc = betDesc & desc & "<br />"
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
				<% if pwd = "" then %>
				<input type="hidden" name="cnfpwd" id="cnfpwd" class="form-control input-sm" onkeyup="submit_bet(event)" />
                
                <div class="row padding-t-10">
                    <div class="col-xs-2"></div>
                    <div class="col-xs-8">
                        <a href="javascript:;" class="btn btn-warning btn-sm-slip btn-block" onClick="changeAmount('t_risk')">Modify Amount</a>
                    </div>
                </div>
                <div class="row padding-t-10">
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-danger btn-sm-slip btn-block" onClick="remove_all()">CANCEL BET</button>
                    </div>
                    <div class="col-xs-6">
                        <button type="button" class="btn btn-success btn-sm-slip btn-block" id="place_straight_button" onClick="dobet()">CONFIRM BET</button>
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

c.Close()
Set c = Nothing
%>