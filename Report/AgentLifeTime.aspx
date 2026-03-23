<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentLifeTime.aspx.cs" Inherits="AgentSite4.Report.AgentLifeTime" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">


                <div class="row page-titles">
                    <div class="col-md-12 col-12 align-self-center">
                        <h3 class="main-title m-b-0 m-t-0">Agent Life Time</h3>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <label for="txtDateFrom">Initial Date:</label>
                                            <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <label for="txtDateFrom">End Date:</label>
                                            <asp:TextBox ID="txtDateTo" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                        <div class="form-group">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
                                            <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                                                DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" OnDataBound="ddlAgent_DataBound" OnSelectedIndexChanged="ddlAgent_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <br />
                                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                                    <asp:Panel runat="server" ID="PnGrids" CssClass="table-responsive col-lg-12">
                                    </asp:Panel>

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
