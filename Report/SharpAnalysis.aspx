<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="SharpAnalysis.aspx.cs" Inherits="AgentSite4.Report.SharpAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <contenttemplate>
            <div class="row">
                <div class="page-titles">
                    <h4>Line Advantage</h4>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">

                            <!-- Filtros -->
                            <div class="row g-3">
                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2">
                                        <label for="<%= txtDateFrom.ClientID %>" class="form-label">Initial Date:</label>
                                        <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control form-control-sm datepicker" />
                                    </div>
                                </div>

                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2">
                                        <label for="<%= txtDateTo.ClientID %>" class="form-label">End Date:</label>
                                        <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control form-control-sm datepicker" />
                                    </div>
                                </div>

                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2">
                                        <asp:Label ID="Label1" runat="server" CssClass="form-label d-block" Text="Agent" />
                                        <asp:DropDownList ID="ddlAgent" runat="server"
                                            DataSourceID="SqlDataSource1"
                                            CssClass="form-control form-control-sm tomlist"
                                            DataTextField="Agent" DataValueField="IdAgent"
                                            AutoPostBack="True" OnDataBound="ddlAgent_DataBound" />
                                    </div>
                                </div>

                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2">
                                        <asp:Label ID="Label2" runat="server" CssClass="form-label d-block" Text="Player" />
                                        <asp:DropDownList ID="ddlPlayer" runat="server"
                                            CssClass="form-control form-control-sm tomlist"
                                            DataSourceID="SqlDataSource2" DataTextField="player" DataValueField="idPlayer"
                                            OnDataBound="ddlPlayer_DataBound" />
                                    </div>
                                </div>

                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2">
                                        <asp:Label ID="Label3" runat="server" CssClass="form-label d-block" Text="Play" />
                                        <asp:DropDownList ID="ddlPlay" runat="server" CssClass="form-control form-control-sm tomlist">
                                            <asp:ListItem Value="0">All Plays</asp:ListItem>
                                            <asp:ListItem Value="1">Spread</asp:ListItem>
                                            <asp:ListItem Value="2">Total</asp:ListItem>
                                            <asp:ListItem Value="3">Money Line</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-12 col-md-4 col-lg-2">
                                    <div class="mb-2 pt-1">
                                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary w-100" OnClick="btnSubmit_Click" />
                                    </div>
                                </div>
                            </div>
                            <!-- /Filtros -->

                        </div>
                    </div>
                </div>
            </div>

            <!-- Grid -->


                            <asp:Panel runat="server" ID="PnGrids" CssClass="table-responsive col-12">
                                <asp:GridView ID="grid" runat="server" OnSorting="GridView_Sorting"
                    CssClass="table table-bordered align-items-center dt-table-hover dataTable no-footer table-striped" />
                            </asp:Panel>


            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                SelectCommand="AddOn_DDLAgent" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                SelectCommand="AddOn_GetPlayersDDL" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

        </contenttemplate>
    </div>

</asp:Content>
