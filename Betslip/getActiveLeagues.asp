<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%
pid = request.Form("pid")
idp = request.Form("idp")
idlt = request.Form("idlt")
idlan = request.Form("idlan")
idbook = request.Form("bid")
wagerType = request.Form("wt")

if idbook = "" then
idbook = 1
end if

GetActiveLeagues idp,idlt,idlan,pid,idbook,wagerType

c.Close
Set c = Nothing
%>