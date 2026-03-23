<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ActionByPlayerEnhanced.aspx.cs" Inherits="AgentSite4.Report.ActionByPlayerEnhanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="page-titles">
            <h4>Accion by Player</h4>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="row g-3 align-items-end">

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
                                    <!-- Fallback de imagen como arriba -->
                                </button>
                            </div>
                        </div>

                        <!-- IP -->
                        <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                            <label for="<%= txtIP.ClientID %>" class="form-label">IP:</label>
                            <asp:TextBox ID="txtIP" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>

                        <!-- Submit -->
                        <div class="col-12 col-md-4 col-lg-2 col-xl-1">
                            <label class="form-label d-none d-md-block">&nbsp;</label>
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary w-100" OnClick="btnSubmit_Click" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

                    <asp:Panel runat="server" i ID="PnGrids">
                    </asp:Panel>


</asp:Content>
