<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerLifeTime.aspx.cs" Inherits="AgentSite4.Report.PlayerLifeTime" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="row">
            <div class="page-titles">
                <h4>Player Life Time</h4>
            </div>
        </div>


        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row g-3 align-items-end">

                            <!-- Initial Date -->
                            <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                                <label for="<%= txtDateFrom.ClientID %>" class="form-label">Initial Date:</label>
                                <div class="input-group input-group-sm">
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>
                                    <button type="button"
                                        class="btn btn-outline-secondary"
                                        id="anchor1"
                                        onclick="cal.select(document.getElementById('<%= txtDateFrom.ClientID %>'),'anchor1','MM/dd/yyyy'); return false;">
                                        <i class="fa-regular fa-calendar"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- End Date -->
                            <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                                <label for="<%= txtDateTo.ClientID %>" class="form-label">End Date:</label>
                                <div class="input-group input-group-sm">
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>
                                    <button type="button"
                                        class="btn btn-outline-secondary"
                                        id="anchor2"
                                        onclick="cal.select(document.getElementById('<%= txtDateTo.ClientID %>'),'anchor2','MM/dd/yyyy'); return false;">
                                        <i class="fa-regular fa-calendar"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Life Time -->
                            <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                                <div class="form-check form-switch form-switch-primary">
                                    <asp:CheckBox ID="chkBeaters" runat="server" Checked="true" CssClass="form-check-input" />
                                    <label class="form-check-label" for="<%= chkBeaters.ClientID %>">Life Time</label>
                                </div>
                            </div>

                            <!-- Agent -->
                            <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                                <label for="<%= ddlAgent.ClientID %>" class="form-label">Agent</label>
                                <asp:DropDownList ID="ddlAgent" runat="server"
                                    DataSourceID="SqlDataSource1"
                                    CssClass="form-control form-control-sm tomlist"
                                    DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>

                            <!-- Submit -->
                            <div class="col-12 col-md-3 col-lg-2 col-xl-1">
                                <label class="form-label d-none d-md-block">&nbsp;</label>
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary w-100"
                                    OnClick="btnSubmit_Click" />
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <asp:Panel runat="server" i ID="PnGrids">
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AddOn_DDLAgent" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent"
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AddOn_GetPlayersDDL" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent"
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
