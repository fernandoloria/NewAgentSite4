<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="LinesSchedule.aspx.cs" Inherits="AgentSite4.Report.LinesSchedule" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
  <h3 class="page-title">
        Lines Schedule
    </h3>
    <ul class="page-breadcrumb breadcrumb">
        <li>
            <i class="fa fa-home"></i>
            <a ID="lnkReport" runat="server" NavigateUrl="~/Report/Welcome.aspx" Key="Home" ></a>
            <i class="fa fa-angle-right"></i>
        </li>
        <li>
            Lines Schedule
        </li>
    </ul>

    <div class="form-inline">
        <div class="form-group">
            <label>
                Agent:</label>
            <asp:DropDownList ID="ddlAgents" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource2" DataTextField="Agent" DataValueField="IdAgent" OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>
        </div>
   </div>
     <div class="form-inline">
        
        <div class="form-group">
            <label>
                Sport:</label>
            <asp:DropDownList ID="ddlWebRows" CssClass="form-control form-control-sm tomlist" runat="server" DataSourceID="sqldsddlWebRows" DataTextField="Description" OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged" DataValueField="IdWebRow" AutoPostBack="True">
            </asp:DropDownList>
        </div>
         <div class="form-group">
             <label>
                Schedule:
             </label>
            <asp:DropDownList ID="ddlTimeBefore" runat="server" CssClass="form-control form-control-sm tomlist">
                <asp:ListItem Value="0">Open with Office</asp:ListItem>
                <asp:ListItem Value="-5">5 Minutes Before</asp:ListItem>
                <asp:ListItem Value="-10">10 Minutes Before</asp:ListItem>
                <asp:ListItem Value="-15">15 Minutes Before</asp:ListItem>
                <asp:ListItem Value="-30">30 Minutes Before</asp:ListItem>
                <asp:ListItem Value="-45">45 Minutes Before</asp:ListItem>
                <asp:ListItem Value="1">1 Hour Before</asp:ListItem>
                <asp:ListItem Value="2">2 Hours Before</asp:ListItem>
                <asp:ListItem Value="3">3 Hours Before</asp:ListItem>
                <asp:ListItem Value="4">4 Hours Before</asp:ListItem>
                <asp:ListItem Value="5">5 Hours Before</asp:ListItem>
                <asp:ListItem Value="6">6 Hours Before</asp:ListItem>
                <asp:ListItem Value="7">7 Hours Before</asp:ListItem>
                <asp:ListItem Value="8">8 Hours Before</asp:ListItem>
                <asp:ListItem Value="9">9 Hours Before</asp:ListItem>
                <asp:ListItem Value="10">10 Hours Before</asp:ListItem>
                <asp:ListItem Value="11">11 Hours Before</asp:ListItem>
                <asp:ListItem Value="12">12 Hours Before</asp:ListItem>
                <asp:ListItem Value="24">1 Day Before</asp:ListItem>
                <asp:ListItem Value="48">2 Days Before</asp:ListItem>
                <asp:ListItem Value="72">3 Days Before</asp:ListItem>
                <asp:ListItem Value="96">4 Days Before</asp:ListItem>
                <asp:ListItem Value="120">5 Days Before</asp:ListItem>
                <asp:ListItem Value="144">6 Days Before</asp:ListItem>
                <asp:ListItem Value="168">7 Days Before</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="form-group">
             <label>
                <Localized:LocalizedLabel runat="server" Key="Schedule" Colon="True" />
             </label>
            <asp:DropDownList ID="ddlTime" runat="server" CssClass="form-control form-control-sm tomlist">
                        <asp:ListItem>1:00 am</asp:ListItem>
                        <asp:ListItem>1:30 am</asp:ListItem>
                        <asp:ListItem>2:00 am</asp:ListItem>
                        <asp:ListItem>2:30 am</asp:ListItem>
                        <asp:ListItem>3:00 am</asp:ListItem>
                        <asp:ListItem>3:30 am</asp:ListItem>
                        <asp:ListItem>4:00 am</asp:ListItem>
                        <asp:ListItem>4:30 am</asp:ListItem>
                        <asp:ListItem>5:00 am</asp:ListItem>
                        <asp:ListItem>5:30 am</asp:ListItem>
                        <asp:ListItem>6:00 am</asp:ListItem>
                        <asp:ListItem>6:30 am</asp:ListItem>
                        <asp:ListItem>7:00 am</asp:ListItem>
                        <asp:ListItem>7:30 am</asp:ListItem>
                        <asp:ListItem>8:00 am</asp:ListItem>
                        <asp:ListItem>8:30 am</asp:ListItem>
                        <asp:ListItem>9:00 am</asp:ListItem>
                        <asp:ListItem>9:30 am</asp:ListItem>
                        <asp:ListItem>10:00 am</asp:ListItem>
                        <asp:ListItem>10:30 am</asp:ListItem>
                        <asp:ListItem>11:00 am</asp:ListItem>
                        <asp:ListItem>11:30 am</asp:ListItem>
                        <asp:ListItem>12:00 pm</asp:ListItem>
                        <asp:ListItem>12:30 pm</asp:ListItem>
                        <asp:ListItem>1:00 pm</asp:ListItem>
                        <asp:ListItem>1:30 pm</asp:ListItem>
                        <asp:ListItem>2:00 pm</asp:ListItem>
                        <asp:ListItem>2:30 pm</asp:ListItem>
                        <asp:ListItem>3:00 pm</asp:ListItem>
                        <asp:ListItem>3:30 pm</asp:ListItem>
                        <asp:ListItem>4:00 pm</asp:ListItem>
                        <asp:ListItem>4:30 pm</asp:ListItem>
                        <asp:ListItem>5:00 pm</asp:ListItem>
                        <asp:ListItem>5:30 pm</asp:ListItem>
                        <asp:ListItem>6:00 pm</asp:ListItem>
                        <asp:ListItem>6:30 pm</asp:ListItem>
                         <asp:ListItem>7:00 pm</asp:ListItem>
                        <asp:ListItem>7:30 pm</asp:ListItem>
                         <asp:ListItem>8:00 pm</asp:ListItem>
                        <asp:ListItem>8:30 pm</asp:ListItem>
                         <asp:ListItem>9:00 pm</asp:ListItem>
                        <asp:ListItem>9:30 pm</asp:ListItem>
                         <asp:ListItem>10:00 pm</asp:ListItem>
                        <asp:ListItem>10:30 pm</asp:ListItem>
                        <asp:ListItem>11:00 pm</asp:ListItem>
                        <asp:ListItem>11:30 pm</asp:ListItem>
                    </asp:DropDownList>
        </div>
        <div class="form-group">
            <asp:CheckBox ID="chkAppyAllLeagues" runat="server" Text="Apply to all Leagues " />
        </div>
        <div class="form-group">
            <asp:Button ID="btnSve" CssClass="btn btnForm" runat="server" Text="Save" OnCommand="btnSve_Command" OnClick="btnSve_Click" />
        </div>
    </div>



    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" Width="99%" class="filter table-bordered" border="0">
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
            <asp:TemplateField HeaderText="OpenBefore" SortExpression="timeBefore">
                <ItemTemplate>
                    <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("idLeague") %>' />
                    <asp:DropDownList ID="ddlTimeBefore" runat="server" CssClass="form-control form-control-sm tomlist" SelectedValue='<%# Bind("timeBefore") %>' AutoPostBack="True" OnSelectedIndexChanged="ddlTimeBefore_SelectedIndexChanged">
                        <asp:ListItem Value="0">Open with Office</asp:ListItem>
                        <asp:ListItem Value="0">Open with Office</asp:ListItem>
                        <asp:ListItem Value="-5">5 Minutes Before</asp:ListItem>
                        <asp:ListItem Value="-10">10 Minutes Before</asp:ListItem>
                        <asp:ListItem Value="-15">15 Minutes Before</asp:ListItem>
                        <asp:ListItem Value="-30">30 Minutes Before</asp:ListItem>
                        <asp:ListItem Value="-45">45 Minutes Before</asp:ListItem>
                        <asp:ListItem Value="1">1 Hour Before</asp:ListItem>
                        <asp:ListItem Value="2">2 Hours Before</asp:ListItem>
                        <asp:ListItem Value="3">3 Hours Before</asp:ListItem>
                        <asp:ListItem Value="4">4 Hours Before</asp:ListItem>
                        <asp:ListItem Value="5">5 Hours Before</asp:ListItem>
                        <asp:ListItem Value="6">6 Hours Before</asp:ListItem>
                        <asp:ListItem Value="7">7 Hours Before</asp:ListItem>
                        <asp:ListItem Value="8">8 Hours Before</asp:ListItem>
                        <asp:ListItem Value="9">9 Hours Before</asp:ListItem>
                        <asp:ListItem Value="10">10 Hours Before</asp:ListItem>
                        <asp:ListItem Value="11">11 Hours Before</asp:ListItem>
                        <asp:ListItem Value="12">12 Hours Before</asp:ListItem>
                        <asp:ListItem Value="24">1 Day Before</asp:ListItem>
                        <asp:ListItem Value="48">2 Days Before</asp:ListItem>
                        <asp:ListItem Value="72">3 Days Before</asp:ListItem>
                        <asp:ListItem Value="96">4 Days Before</asp:ListItem>
                        <asp:ListItem Value="120">5 Days Before</asp:ListItem>
                        <asp:ListItem Value="144">6 Days Before</asp:ListItem>
                        <asp:ListItem Value="168">7 Days Before</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>

             <asp:TemplateField HeaderText="Time">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlTIme" runat="server" CssClass="form-control form-control-sm tomlist">
                        <asp:ListItem>1:00 am</asp:ListItem>
                        <asp:ListItem>1:30 am</asp:ListItem>
                        <asp:ListItem>2:00 am</asp:ListItem>
                        <asp:ListItem>2:30 am</asp:ListItem>
                        <asp:ListItem>3:00 am</asp:ListItem>
                        <asp:ListItem>3:30 am</asp:ListItem>
                        <asp:ListItem>4:00 am</asp:ListItem>
                        <asp:ListItem>4:30 am</asp:ListItem>
                        <asp:ListItem>5:00 am</asp:ListItem>
                        <asp:ListItem>5:30 am</asp:ListItem>
                        <asp:ListItem>6:00 am</asp:ListItem>
                        <asp:ListItem>6:30 am</asp:ListItem>
                        <asp:ListItem>7:00 am</asp:ListItem>
                        <asp:ListItem>7:30 am</asp:ListItem>
                        <asp:ListItem>8:00 am</asp:ListItem>
                        <asp:ListItem>8:30 am</asp:ListItem>
                        <asp:ListItem>9:00 am</asp:ListItem>
                        <asp:ListItem>9:30 am</asp:ListItem>
                        <asp:ListItem>10:00 am</asp:ListItem>
                        <asp:ListItem>10:30 am</asp:ListItem>
                        <asp:ListItem>11:00 am</asp:ListItem>
                        <asp:ListItem>11:30 am</asp:ListItem>
                        <asp:ListItem>12:00 pm</asp:ListItem>
                        <asp:ListItem>12:30 pm</asp:ListItem>
                        <asp:ListItem>1:00 pm</asp:ListItem>
                        <asp:ListItem>1:30 pm</asp:ListItem>
                        <asp:ListItem>2:00 pm</asp:ListItem>
                        <asp:ListItem>2:30 pm</asp:ListItem>
                        <asp:ListItem>3:00 pm</asp:ListItem>
                        <asp:ListItem>3:30 pm</asp:ListItem>
                        <asp:ListItem>4:00 pm</asp:ListItem>
                        <asp:ListItem>4:30 pm</asp:ListItem>
                        <asp:ListItem>5:00 pm</asp:ListItem>
                        <asp:ListItem>5:30 pm</asp:ListItem>
                        <asp:ListItem>6:00 pm</asp:ListItem>
                        <asp:ListItem>6:30 pm</asp:ListItem>
                         <asp:ListItem>7:00 pm</asp:ListItem>
                        <asp:ListItem>7:30 pm</asp:ListItem>
                         <asp:ListItem>8:00 pm</asp:ListItem>
                        <asp:ListItem>8:30 pm</asp:ListItem>
                         <asp:ListItem>9:00 pm</asp:ListItem>
                        <asp:ListItem>9:30 pm</asp:ListItem>
                         <asp:ListItem>10:00 pm</asp:ListItem>
                        <asp:ListItem>10:30 pm</asp:ListItem>
                        <asp:ListItem>11:00 pm</asp:ListItem>
                        <asp:ListItem>11:30 pm</asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>


        </Columns>
        <HeaderStyle CssClass="page-titles" />
        <RowStyle CssClass="TrGameOdd " />
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="LinesSchedule_GetLeagues" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlWebRows" Name="prmIdWebRow" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddlAgents" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_DDLAgent" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="prmIDAgent" SessionField="SubIdAgent" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqldsddlWebRows" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="HiddenLeagues_GetWEBROW" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_GetLineTypesByAgent" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlAgents" DefaultValue="1" Name="prmIDAgent" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>
