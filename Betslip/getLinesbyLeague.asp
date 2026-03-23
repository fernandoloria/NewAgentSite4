<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%

PlayerID = request.QueryString("pid")
CallID = request.QueryString("idc")
ProfileID = request.QueryString("idp")
ProfileLimitsID = request.QueryString("idpl")
LineTypeID = request.QueryString("idlt")
NHLLine = request.QueryString("nhll")
MLBLine = request.QueryString("mlbl")
LineStyle = request.QueryString("idls")
Leagues = request.QueryString("idl")
Language = request.QueryString("idlan")
utcID = request.QueryString("utc")
AgentID = request.QueryString("aid")
BookID = request.QueryString("bid")
WagerType = request.QueryString("wt")
WagerTypeID = request.QueryString("wtid")

if BookID = "" then
BookID = 1
end if

if Leagues = "" then
	response.write "No Leagues Available"
else
	getSchedule PlayerID,CallID,ProfileID,ProfileLimitsID,LineTypeID,NHLLine,MLBLine,LineStyle,CStr(Leagues),Language,utcID,AgentID,BookID,WagerType,WagerTypeID
end if

c.Close
Set c = Nothing
%>