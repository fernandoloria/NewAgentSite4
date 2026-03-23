<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="WeeklyBalanceWeekHistory.aspx.cs" Inherits="AgentSite4.Popup.WeeklyBalanceWeekHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
     <div class="dgsContent">
       
    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" 
        EnableModelValidation="True" AutoGenerateColumns="False" >
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
                <asp:BoundField DataField="LoginName" HeaderText="User/Phone" 
                    SortExpression="LoginName"></asp:BoundField>
                <asp:TemplateField  HeaderText="Date">
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("TicketNumber") %>'></asp:Label>
                        <br />
                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SettledDate") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="IdSport" HeaderText="Sport" 
                    SortExpression="IdSport"></asp:BoundField>
                <asp:BoundField DataField="TicketNumber" HeaderText="TicketNumber" 
                    SortExpression="TicketNumber"></asp:BoundField>
                 <asp:TemplateField  HeaderText="Description">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("CompleteDesc") %>'></asp:Label>
                        <br />
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("DetailDesc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField  HeaderText="Risk/Win">
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" 
                            Text='<%# Eval("RiskAmount", "{0:0.00}") %>'></asp:Label>
                        <span>/</span>
                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("WinAmount", "{0:0.00}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Amount" HeaderText="Amount" 
                    SortExpression="Amount"  DataFormatString="{0:0.00}"></asp:BoundField>
                <asp:TemplateField HeaderText="Result" >
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%#(Convert.ToInt32(DataBinder.Eval(Container, "DataItem.Amount"))) > 0 ? "Win":"Lose" %>'></asp:Label>
                    </ItemTemplate>  
                </asp:TemplateField>
                <asp:BoundField DataField="PlacedDate" HeaderText="Date" 
                    SortExpression="PlacedDate"></asp:BoundField>
            </Columns>
        <HeaderStyle CssClass="page-titles" />
        <RowStyle CssClass="TrGameOdd" />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" 
        SelectCommand="AddOn_Web_Report_Agent_History_BYPage" 
        SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="188602" Name="prmIdPlayer" 
                QueryStringField="id" Type="Int32" />
            <asp:QueryStringParameter DefaultValue="2015-03-03" Name="prmDate" 
                QueryStringField="date" Type="DateTime" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>
