<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%
pid = Request.QueryString("pid")

getTeasersMenu pid

c.Close()
Set c = Nothing
%>