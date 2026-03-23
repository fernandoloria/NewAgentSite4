<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="BetTicker.aspx.cs" Inherits="AgentSite4.Report.BetTicker" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
	<h3 class="page-title">
        <asp:Label runat="server" key="BetTicker" Colon="False" />  
	</h3>
    
   

    <table id="colors" width="940px" border="0">
        <tbody>
            <tr>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #FFFFFF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$0&nbsp; - $499</b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #93ce82">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$1500 - $2999</b></font>&nbsp;</td>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #faba58">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$4000 - $4999</b></font>&nbsp;</td>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #8042ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$10000 +</b></font>&nbsp;</td>
            </tr>
            <tr>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #8ebdd5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$500 - $1499</b></font>&nbsp;</td>

                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #fcf661">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$3000 - $3999</b></font>&nbsp;</td>
                <td width="200px"><font face="Arial, Helvetica, sans-serif" size="2" style="background-color: #fa3a3a">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$5000 - $9999</b></font>&nbsp;</td>
                <td width="200px">
                    <asp:TextBox ID="txtMinAmount" runat="server" PlaceHolder="Min Amount"></asp:TextBox>
                    <asp:Button ID="btnFilter" runat="server" OnClick="btnFilter_Click" Text="Set" />
                </td>
            </tr>
			<tr>
			<td colspan="4">
			Ticker History:
			<asp:DropDownList ID="ddlPlaced" runat="server" CssClass="form-control" AutoPostBack="True">
                <asp:ListItem Value="5">5 minutes</asp:ListItem>
                <asp:ListItem Value="10">10 Minutes</asp:ListItem>
                <asp:ListItem Value="15">15 minutes</asp:ListItem>
                <asp:ListItem Value="30">30 Minutes</asp:ListItem>
                <asp:ListItem Value="60">1 Hour</asp:ListItem>
                <asp:ListItem Value="120"  Selected="True">2 hours</asp:ListItem>
                <asp:ListItem Value="180">3 hours</asp:ListItem>
				<asp:ListItem Value="240">4 Hour</asp:ListItem>
                <asp:ListItem Value="300">5 hours</asp:ListItem>
                <asp:ListItem Value="360">6 hours</asp:ListItem>
				<asp:ListItem Value="420">7 hours</asp:ListItem>
                <asp:ListItem Value="480">8 hours</asp:ListItem>
				<asp:ListItem Value="540">9 hours</asp:ListItem>
				<asp:ListItem Value="600">10 hours</asp:ListItem>
				<asp:ListItem Value="660">11 hours</asp:ListItem>
				<asp:ListItem Value="720">12 hours</asp:ListItem>
				<asp:ListItem Value="1440">24 hours</asp:ListItem>
            </asp:DropDownList></td>
			</tr>
        </tbody>
    </table>
    <br />
    <table id="ticker" width="100%" cellpadding="0"  border="1">
        <thead>
            <tr style="background-color:#333333;font-weight:bold; color: #FFFFFF; background-color: #252525; font-size: 13px; font-weight: bolder;">
                <td>Ticket #</td>
                <td>Bet Date</td>
                <td>Player</td>
                <td>Wager Type</td>
                <td>Sport</td>
                <td>Description</td>
                <td>Points</td>
                <td>Odds</td>
                <td>Risk/Win</td>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>
    <input type="hidden" id="tick" value="0" />
    <script type="text/javascript" src="/assets/BetTicker/js/MainBetTicker.js?v=abc1.20190"></script>
</asp:Content>
