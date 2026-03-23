<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="MenuConfiguration.aspx.cs" Inherits="AgentSite4.Report.MenuConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <asp:Button ID="btnSaveAll" runat="server" Text="Save All" CssClass="btn btn-success" OnClick="btnSaveAll_Click" />


        <asp:GridView ID="GridView1" CssClass="table color-table success-table table-bordered table-striped table-sm" runat="server" AutoGenerateColumns="False" DataKeyNames="idReport" DataSourceID="SqlDataSource1" EnableModelValidation="True" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="Right" SortExpression="idRight">
                    <ItemTemplate>
                        <asp:HiddenField ID="hdIdReport" runat="server" Value='<%# Eval("idReport") %>' />
                        <asp:DropDownList ID="ddlIdRight" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource2" DataTextField="Description" DataValueField="IdRight" SelectedValue='<%# Bind("idRight") %>'>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" SelectCommand="AgentRights_GetList" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        <br />
                        <asp:TextBox ID="txtNewRight" runat="server" CssClass="form-control form-control-sm mt-1" Placeholder="New Right" />
                        <asp:Button ID="btnCreateAndAssignRight" runat="server" Text="Create & Assign" CssClass="btn btn-primary btn-sm mt-1" CommandName="CreateAndAssignRight" CommandArgument='<%# Container.DataItemIndex %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Category" SortExpression="idCategory">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource3" DataTextField="category" DataValueField="idCategory" SelectedValue='<%# Bind("idCategory") %>'>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AgentMenuCategories_GetAll" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name" SortExpression="reportName">
                    <ItemTemplate>
                        <asp:TextBox ID="txtReportName" runat="server" Text='<%# Bind("reportName") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="reportURL" HeaderText="URL" SortExpression="reportURL" />
                <asp:TemplateField HeaderText="Order" SortExpression="reportOrder">
                    <ItemTemplate>
                        <asp:TextBox ID="txtOrder" runat="server" Text='<%# Eval("reportOrder") != DBNull.Value ? Eval("reportOrder").ToString() : "0" %>' CssClass="form-control form-control-sm"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:ButtonField Text="Save" ButtonType="Button" CommandName="Save">
                    <ControlStyle CssClass="btn btn-primary" />
                </asp:ButtonField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AgentMenu_GetAll" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    </div>
</asp:Content>
