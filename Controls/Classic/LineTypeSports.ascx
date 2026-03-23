<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LineTypeSports.ascx.cs" Inherits="AgentSite4.Controls.LineTypeSports" %>
<%@ Register TagPrefix="Crl" TagName="Schedule" Src="~/Controls/Classic/Schedule.ascx" %>
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="height:32px;">
<tr>
    <td style="width:5px;"></td>
    <td valign="middle" class="TDLineType" align="left"> 
        Line Type:   
        <asp:DropDownList ID="CmbLineType" CssClass="form-control form-control-sm tomlist" onchange="LTExplorer()" runat="server" OnSelectedIndexChanged="Select_ChangeLT">
        </asp:DropDownList>
    </td>
    <td align="right" valign="bottom">
        <%=SportList%>
    </td>
    <td style="width:2px;"></td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" id="MoveLineSchedule">
<tr>
    <td id="MoveLineScheduleTop"></td>
</tr>
<tr>
    <td id="MoveLineScheduleMiddle">
        <Crl:Schedule ID="CRLSchedule" runat="server" />
    </td>
</tr>
<tr>
    <td id="MoveLineScheduleBottom"></td>
</tr>
</table>

</ContentTemplate>
</asp:UpdatePanel>

