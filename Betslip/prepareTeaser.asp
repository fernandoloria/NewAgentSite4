<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Response.CacheControl = "no-cache" %>
<!--#include file = "includes/common.asp"-->
<!--#include file = "includes/db.asp"-->
<%
idp = request.QueryString("idp")
bc = request.QueryString("bc")
os = request.QueryString("os")
idwt = request.QueryString("idwt")
ts = request.QueryString("ts")
maxOpenSpots = request.QueryString("maxOpenSpots")
if os = "" then %>
  <div class="BT-allcont"> 
      <div class="row">
          <div class="form-group">
            <% if bc < ts AND maxOpenSpots > 0 then %>
              <label for="betall" class="control-label form-label labelInput col-xs-2 col-sm-6">Open Spots</label>
              <div class="col-xs-4 col-sm-6">
                <input type="number" class="form-control input-sm BT-dkAmount" id="openspots" value="0" onkeypress="return isNumber(event)" min="0" pattern="[0-9]*" inputmode="numeric" />
              </div>
            <% elseif bc < ts AND maxOpenSpots = 0 then %>
              <div class="alert alert-danger">Error : The max number of open spots for this Teaser is 0. Add another team or select another teaser type.</div>
            <% else
              os = 0
            end if %>
            <div class="col-xs-6 col-sm-12">
              <button type="submit" class="btn btn-primary btn-sm-slip btn-block" onClick='do_teaser(<%= idwt %>)'>Add</button>
            </div>
          </div>
      </div>
  </div>
<% elseif os <> "0" then 
	bc = CInt(bc)+CInt(os) %>
	<div class="row pick_container">
    <div class="col-lg-12">
        <span class="pull-left"><strong><%= os %> OPEN SPOT(S)</strong></span>
      </div>
  </div>
  <input type="hidden" name="openspots" id="openspots" value="<%= os %>" />
<% 
end if
if idwt = "0" then %>
  <div class="row padding-t-5">
    <div class="form-group" style="margin-bottom:0px;">
      <div class="col-xs-12">
        <% 
          if CInt(bc) >= 2 then  
            getTeasersList idp,CStr(bc) 
          end if
        %>
      </div>
    </div>
  </div>
<% end if %>
<%
c.Close()
Set c = Nothing
%>