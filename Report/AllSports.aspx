<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AllSports.aspx.cs" Inherits="AgentSite4.Report.AllSports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        
<h3 class="page-title"> All Sports  </h3>
<ul class="page-breadcrumb breadcrumb"><li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx" target="_self">Home</a><i class="fa fa-angle-right"></i></li><li><a href="#"> All Sports  </a></li></ul>
     
        
         <%
        
        DateTime from = fromOrTo(true);
    %>
     <table cellspacing="1" cellpadding="1" border="0" class="filter">
        <tbody>
            <tr>
                <td colspan="3" align="middle">
                </td>
            </tr>
            <tr>
                <td>
                    Day Week Date:
                    <asp:TextBox ID="txtDate" name="txtDate" runat="server" Cssclass="form-control form-control-sm datepicker" 
                        ontextchanged="txtDate_TextChanged" AutoPostBack="True"></asp:TextBox>

                </td>
                <td align="right">
				
				<asp:LinkButton ID="lnk2Weeks" runat="server" onclick="lnk2Weeks_Click">Two Weeks Ago</asp:LinkButton>
				&nbsp;<asp:LinkButton ID="lnkLastWeek" runat="server" onclick="lnkLastWeek_Click">Last Week</asp:LinkButton>
				&nbsp;<asp:LinkButton ID="lnkThisWeek" runat="server" onclick="lnkThisWeek_Click">This Week</asp:LinkButton>
                   <!-- Transaction Type:
                    <asp:DropDownList ID="ddlSports" runat="server" AutoPostBack="True" 
                        onselectedindexchanged="ddlSports_SelectedIndexChanged">
                        <asp:ListItem Value="-1">ALL</asp:ListItem>
                        <asp:ListItem Value="0">SPORT</asp:ListItem>
                        <asp:ListItem Value="1">CASINO</asp:ListItem>
                        <asp:ListItem Value="2">RACING</asp:ListItem>
                    </asp:DropDownList> -->
                </td>
                
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
				
            </tr>
           <!--  <tr>
                <td>
                    &nbsp;</td>
                <td align="right">
                    &nbsp;
                </td>
                <td align="right">
                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
            </tr> -->
        </tbody>
    </table>
       

<asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        ondatabound="GridView1_DataBound"    DataSourceID="SqlDataSource1" EnableModelValidation="True" Width="99%" 
        class="filter table-bordered" border="0">
            <AlternatingRowStyle CssClass="TrGameEven" />
            <Columns>
                <asp:BoundField DataField="idPlayer" HeaderText="idPlayer" 
                    SortExpression="idPlayer" >
                </asp:BoundField>
                
                <asp:BoundField DataField="Player" HeaderText="Player" 
                    SortExpression="Player" DataFormatString="{0:N2}" >
                </asp:BoundField>
                <asp:BoundField DataField="Password" HeaderText="Password" 
                    SortExpression="Password" DataFormatString="{0:N2}" >
                </asp:BoundField>
                <asp:BoundField DataField="CreditLimit" HeaderText="CreditLimit" 
                    SortExpression="CreditLimit" DataFormatString="{0:N2}">
                </asp:BoundField>
                <asp:BoundField DataField="CurrentBalance" HeaderText="CurrentBalance" 
                    SortExpression="CurrentBalance" DataFormatString="{0:N2}" >
                </asp:BoundField>
                <asp:BoundField DataField="SortCasino" HeaderText="SortCasino" 
                    SortExpression="SortCasino" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="Horses" DataFormatString="{0:N2}" 
                    HeaderText="Horses" SortExpression="Horses" />
                <asp:BoundField DataField="Total" DataFormatString="{0:N2}" HeaderText="Total" 
                    SortExpression="Total" />
            </Columns>
           
            <HeaderStyle CssClass="GameHeader" />
            <RowStyle CssClass="TrGameOdd " />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" 
            SelectCommand="AddOn_AllSportsByPlayer" 
            SelectCommandType="StoredProcedure" 
            UpdateCommand="AddOn_PlayerManagmentWithHeader_UpdatePlayer" 
            UpdateCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtDate" Name="prmDateWeek" 
                    PropertyName="Text" Type="String" />
                <asp:SessionParameter DefaultValue="" Name="idAgent" SessionField="SubIdAgent" 
                    Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
				<asp:Parameter Name="IdAgent" Type="Int32" />
                <asp:Parameter Name="Agent" Type="String" />
                <asp:Parameter Name="Player" Type="String" />
                <asp:Parameter Name="Password" Type="String" />
                <asp:Parameter Name="OnlinePassword" Type="String" />
                <asp:Parameter Name="CreditLimit" Type="Decimal" />
                <asp:Parameter Name="MaxWager" Type="Decimal" />
                <asp:Parameter Name="MinWager" Type="Decimal" />
                <asp:Parameter Name="OnlineMaxWager" Type="Decimal" />
                <asp:Parameter Name="OnlineMinWager" Type="Decimal" />
                <asp:Parameter Name="Status" Type="Boolean" />
                <asp:Parameter Name="OnlineAccess" Type="Boolean" />
                <asp:Parameter Name="EnableSports" Type="Boolean" />
                <asp:Parameter Name="EnableHorses" Type="Boolean" />
                <asp:Parameter Name="EnableCasino" Type="Boolean" />
                <asp:Parameter Name="lastWager" Type="DateTime" />
                <asp:Parameter Name="idPlayer" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <h1><asp:Label ID="lblError" runat="server"></asp:Label></h1>
    </div>
</asp:Content>
