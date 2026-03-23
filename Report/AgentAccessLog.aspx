<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentAccessLog.aspx.cs" Inherits="AgentSite4.Report.AgentAccessLog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="page-title"> Agent Access Log</h3>
    <ul class="page-breadcrumb breadcrumb">
      <li><i class="fa fa-home"></i> <a href="../Report/Welcome.aspx">Home</a> <i class="fa fa-angle-right"></i></li>
      <li><a href="#"> Agent Access Log </a></li>
    </ul>

            <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" class="filter">
              <TR>
                <TD>Initial Date:</TD>
                <TD>
                  <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control datepicker" />

                </TD>
                <TD>End Date:</TD>
                <TD>
                  <asp:TextBox ID="txtTo" runat="server" CssClass="form-control datepicker" />
                </TD>
                <TD>Agent:</TD>
                <TD>
                    <asp:DropDownList ID="ddlAgent" runat="server">
                    </asp:DropDownList>
                </TD>
                <TD>
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btnForm" 
                        onclick="btnSubmit_Click" />
                  </TD>
              </TR>
            </TABLE>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" 
             Width="100%" CssClass="table-bordered">
            <AlternatingRowStyle CssClass="TrGameEven" />
            <Columns>
                <asp:BoundField DataField="Agent" HeaderText="Agent" 
                    SortExpression="Agent" >
                </asp:BoundField>
                <asp:BoundField DataField="IdAgentLogons" HeaderText="Session" 
                    SortExpression="IdAgentLogons" InsertVisible="False" >
                </asp:BoundField>
                <asp:BoundField DataField="PlacedDate" HeaderText="Date" 
                    SortExpression="PlacedDate">
                </asp:BoundField>
                <asp:BoundField DataField="ip" 
                    HeaderText="IP" SortExpression="ip">
                </asp:BoundField>
            </Columns>
            <EditRowStyle Font-Size="XX-Small" />
            <HeaderStyle CssClass="GameHeader" />
            <RowStyle CssClass="TrGameOdd"  />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" 
            SelectCommand="AddOn_AgentLogAccess" 
            SelectCommandType="StoredProcedure" ProviderName="<%$ ConnectionStrings:DGS_AddOnsConnectionString.ProviderName %>">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="idDistributor" SessionField="SubidAgent" 
                    Type="Int32" />
                <asp:ControlParameter ControlID="txtFrom" DefaultValue="" Name="dateFrom" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="txtTo" DefaultValue="" Name="dateTo" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="ddlAgent" DefaultValue="-1" Name="idAgent" 
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
      
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Footer" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
