<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="BeatTheLine.aspx.cs" Inherits="AgentSite4.Report.BeatTheLine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 


    <script language="JavaScript">




        $(document).ready(function () {
            $('#ctl00_MainContent_txtDateFrom').datepicker({
                startDate: '-3m',
                endDate: '-1d'
            });

            $('#ctl00_MainContent_txtDateTo').datepicker({
                startDate: '-3m',
                endDate: '0d'
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
         <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
                            <div class="form-group">
                                <label for="txtDateFrom">Initial Date:</label>
                                <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
                            <div class="form-group">
                                <label for="txtDateFrom">End Date:</label>
                                <asp:TextBox ID="txtDateTo" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
                            <div class="form-group">
                                <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
                                <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                                    DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" OnDataBound="ddlAgent_DataBound">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
                            <div class="form-group">
                                <asp:Label ID="Label2" runat="server" Text="Player"></asp:Label>

                                <asp:DropDownList ID="ddlPlayer" CssClass="form-control form-control-sm tomlist" runat="server" DataSourceID="SqlDataSource2" DataTextField="player" DataValueField="idPlayer" OnDataBound="ddlPlayer_DataBound">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
                            <div class="form-group">
                                <asp:Label ID="Label3" runat="server" Text="Play"></asp:Label>

                                <asp:DropDownList ID="ddlPlay" CssClass="form-control form-control-sm tomlist" runat="server">
                                    <asp:ListItem Value="0">All Plays</asp:ListItem>
                                    <asp:ListItem Value="1">Spread</asp:ListItem>
                                    <asp:ListItem Value="2">Total</asp:ListItem>
                                    <asp:ListItem Value="3">Money Line</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-2">
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
    <br />
    <asp:Panel runat="server" ID="PnGrids" CssClass="">
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
