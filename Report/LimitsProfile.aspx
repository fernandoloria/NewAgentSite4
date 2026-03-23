<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="LimitsProfile.aspx.cs" Inherits="AgentSite4.Report.LimitsProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        
<h3 class="page-title"> Player Profile Limit  </h3>
<ul class="page-breadcrumb breadcrumb"><li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx" target="mainFrame">Home</a><i class="fa fa-angle-right"></i></li><li><a href="#"> Player Profile Limit  </a></li></ul>

<asp:Panel ID="pnDAtos" runat="server">
<table style="width:100%;" cellspacing="0" cellpadding="3" border="0" class="table">

    <tbody>
		<tr class="page-titles">

            <td colspan="8" style="padding: 10px;">Profile for Player <asp:Label runat="server" id="lblAg" /></td>
        </tr>
<tr>
	<td colspan="8" align="center">
			<asp:DropDownList ID="ddlPLayers" runat="server" AutoPostBack="True"  CssClass="form-control form-control-sm tomlist"
                onselectedindexchanged="ddlPLayers_SelectedIndexChanged1">
            
        </asp:DropDownList>
		<asp:RadioButton ID="rdnOnline" runat="server" Checked="True" Text="Online" 
            style="font-size: large" GroupName="Online" AutoPostBack="True" 
                oncheckedchanged="rdnOnline_CheckedChanged" />
        <asp:RadioButton ID="rdnLocal" runat="server" Text="Phone" 
            style="font-size: large" GroupName="Online" AutoPostBack="True" 
                oncheckedchanged="rdnLocal_CheckedChanged" />
	        &nbsp;
            </td>
	</tr>
    
        <tr>
            <td colspan="8">
                <asp:DropDownList ID="ddlGameType" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm tomlist"
                    onselectedindexchanged="DropDownList1_SelectedIndexChanged">
                    <asp:ListItem Value="1">Full Games</asp:ListItem>
                    <asp:ListItem Value="10">1st Halfs</asp:ListItem>
                    <asp:ListItem Value="2">2nd Halfs</asp:ListItem>
                    <asp:ListItem Value="11">Quartes Lines</asp:ListItem>
                    <asp:ListItem Value="13">Hockey Periods</asp:ListItem>
                    <asp:ListItem Value="15">Live Betting</asp:ListItem>
                    <asp:ListItem Value="16">Individual Team Totals</asp:ListItem>
                    <asp:ListItem Value="14">Props</asp:ListItem>
                    <asp:ListItem Value="20">Player Props</asp:ListItem>
                    <asp:ListItem Value="21">WNBA</asp:ListItem>
                    <asp:ListItem Value="23">College Baseball</asp:ListItem>
                    <asp:ListItem Value="7">Circle 2</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
    
        <tr>
            <td colspan="8">
                <asp:Label ID="lblWarning" runat="server" Font-Bold="True" Font-Size="Large" 
                    ForeColor="Red"></asp:Label>
            </td>
        </tr>
    
        <tr>
            <td colspan="8">
                <asp:Button ID="btnCreate" runat="server" Text="Create Custom Profile" CssClass="btnForm" />
            </td>
        </tr>
    
<tr class="page-titles">
    <td align="center">Sport</td>
    <td align="center">Side</td>
	<td align="center">Total</td>
    <td align="center">Money Line</td>
	<td align="center">Parlays</td>
    <td align="center">Teasers</td>
	<td align="center">If Bets</td>
	<td align="center">Reverses</td>
</tr>
<tr class="TrGameOdd">
    <td align="center">CBB</td>
    <td align="center"><asp:TextBox ID="txtSideCBB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalCBB" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineCBB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysCBB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersCBB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsCBB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesCBB" runat="server" Width="60px"></asp:TextBox></td>

</tr>

        <tr class="TrGameEven">
    <td align="center">CFB</td>
    <td align="center"><asp:TextBox ID="txtSideCFB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalCFB" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineCFB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysCFB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersCFB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsCFB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesCFB" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameOdd">
    <td align="center">ESOC</td>
    <td align="center"><asp:TextBox ID="txtSideESOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalESOC" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineESOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysESOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersESOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsESOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesESOC" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameEven">
    <td align="center">MLB</td>
    <td align="center"><asp:TextBox ID="txtSideMLB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalMLB" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineMLB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysMLB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersMLB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsMLB" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesMLB" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameOdd">
    <td align="center">MU</td>
    <td align="center"><asp:TextBox ID="txtSideMU" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalMU" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineMU" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysMU" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersMU" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsMU" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesMU" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameEven">
    <td align="center">NBA</td>
    <td align="center"><asp:TextBox ID="txtSideNBA" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalNBA" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineNBA" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysNBA" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersNBA" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsNBA" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesNBA" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameOdd">
    <td align="center">NFL</td>
    <td align="center"><asp:TextBox ID="txtSideNFL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalNFL" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineNFL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysNFL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersNFL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsNFL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesNFL" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameEven">
    <td align="center">NHL</td>
    <td align="center"><asp:TextBox ID="txtSideNHL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalNHL" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineNHL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysNHL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersNHL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsNHL" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesNHL" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameOdd">
    <td align="center">PROP</td>
    <td align="center"><asp:TextBox ID="txtSidePROP" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalPROP" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLinePROP" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysPROP" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersPROP" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsPROP" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesPROP" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameEven">
    <td align="center">SOC</td>
    <td align="center"><asp:TextBox ID="txtSideSOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalSOC" runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineSOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysSOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersSOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsSOC" runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesSOC" runat="server" Width="60px"></asp:TextBox></td>

        </tr>
        <tr class="TrGameOdd">
    <td align="center">TNT</td>
    <td align="center"><asp:TextBox ID="txtSideTNT"  runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTotalTNT"  runat="server" Width="60px"></asp:TextBox></td>
    <td align="center"><asp:TextBox ID="txtMoneyLineTNT"  runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtParlaysTNT"  runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtTeasersTNT"  runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtIfBetsTNT"  runat="server" Width="60px"></asp:TextBox></td>
	<td align="center"><asp:TextBox ID="txtReversesTNT"  runat="server" Width="60px"></asp:TextBox></td>

        </tr>

<tr>
    <td style="border-bottom-style: groove">&nbsp;</td>
    <td style="border-bottom-style: groove">&nbsp;</td>
	<td style="border-bottom-style: groove">&nbsp;</td>
    <td style="border-bottom-style: groove">&nbsp;</td>
	<td style="border-bottom-style: groove">&nbsp;</td>
    <td style="border-bottom-style: groove">&nbsp;</td>
	<td style="border-bottom-style: groove">&nbsp;</td>
	<td style="border-bottom-style: groove">&nbsp;</td>
</tr>

<tr style="vertical-align: middle" valign="middle">
    <td align="center">Amount:</td>
    <td valign="bottom"><asp:TextBox ID="txtApplyAll" runat="server" Width="60px"></asp:TextBox></td>
	<td colspan="2" style="text-align: left">
		<asp:Button ID="btnRefresh" runat="server" Text="Apply All" 
            onclick="btnRefresh_Click" CssClass="btnForm"  />
	</td>
	<td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
	<td colspan="2">
	<asp:Button ID="btnApply" runat="server" onclick="btnApply_Click" Text="Save" CssClass="btnForm" />
		<asp:Button ID="btnReset" runat="server" onclick="btnReset_Click" Text="Reset" CssClass="btnForm" />
		</td>
</tr>


</tbody></table>
</asp:Panel>
    </div>
</asp:Content>
