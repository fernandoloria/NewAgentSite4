<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ManagePlayerMessage.aspx.cs" Inherits="AgentSite4.Report.ManagePlayerMessage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <style>
            .row {
                margin-right: unset;
                margin-left: unset;
            }
        </style>
        <asp:Panel ID="pnAlert" runat="server" Visible="False">
            <div id="agentMessage" class="alert alert-light alert-rounded text-center" role="alert">
                <h1 style="background-color: #678F49;"><i class="mdi mdi-success"></i>
                    <asp:Label ID="lblMessageTitle" runat="server" Text="Label"></asp:Label></h1>
                <h6><span id="spanAgentMessage">
                    <asp:Label ID="lblMessage" runat="server" Text="Label"></asp:Label></span></h6>
                <button id="btnAgentMessage" type="button" class="btn btn-alert close" data-dismiss="alert" aria-label="Close"><i class="mdi mdi-close" aria-hidden="true"></i>Close </button>
            </div>
        </asp:Panel>

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Manage Player Messages</h3>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">

                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
                                    <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                                        DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" Text="Player"></asp:Label>

                                    <asp:DropDownList ID="ddlPlayer" CssClass="form-control form-control-sm tomlist" runat="server" DataSourceID="SqlDataSource2" DataTextField="player" DataValueField="idPlayer" OnSelectedIndexChanged="ddlPlayer_SelectedIndexChanged" OnDataBound="ddlPlayer_DataBound" AutoPostBack="True">
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
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <h3 class="box-title m-b-0">
                            <asp:Label ID="lblTitlePlayer" runat="server" Text=""></asp:Label></h3>
                        <br />
                        <div class="form-horizontal">
                            <div class="form-group row">
                                <label for="txtMaxOnLine" class="col-sm-3 text-right control-label col-form-label">Options</label>
                                <div class="col-sm-3">
                                    <asp:DropDownList ID="ddlMessageType" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="N">Normal</asp:ListItem>
                                        <asp:ListItem Value="P">Permanet</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-sm-3">
                                    <asp:CheckBox ID="chkDisplaycounter" runat="server" Text="Display Counter" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>
                                <div class="col-sm-3">
                                    <asp:TextBox ID="txtCounter" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>

                            </div>
                            <div class="form-group row">
                                <div class="col-sm-3" style="text-align: right;">
                                    <asp:CheckBox ID="chkExpirationDate" runat="server" Text="Expiration Date" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>
                                <div class="col-sm-3">
                                    <asp:TextBox ID="txtExpirationDate" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>

                                </div>
                                <div class="col-sm-6">
                                    <asp:CheckBox ID="chkPlayerCanDisable" runat="server" Text="Player can disable message" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>


                            </div>
                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <asp:TextBox ID="txtMessage" CssClass="form-control form-control-sm" placeholder="message" runat="server" Height="115px" TextMode="MultiLine"></asp:TextBox>

                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-4">
                                    <asp:Button ID="btnCreateMessage" runat="server" Text="Create Message" CssClass="btn btn-success" OnClick="btnCreateMessage_Click" />
                                </div>
                                <div class="col-sm-4"></div>
                            </div>
                            <div class="form-group row">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" ErrorMessage="Display Counter: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtCounter" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <asp:TextBox ID="txtDELETE" runat="server"></asp:TextBox>
                            <asp:Label ID="lblDeleteMessage" runat="server" Text=""></asp:Label>
                            <asp:Button ID="Button1" runat="server" Text="DELETE ALL MESSAGES" OnClick="Button1_Click" CssClass="btn btn-warning" />

                        </div>
                        <div class="row">
                            <asp:Panel runat="server" ID="PnGrids" CssClass="table-responsive col-lg-12">

                                <asp:GridView CssClass="table-dynamic table table-bordered table-striped table-sm" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="IdPlayerMessage" DataSourceID="SqlDataSource3" EnableModelValidation="True" OnRowCommand="GridView1_RowCommand">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Player" SortExpression="Player">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Player") %>'></asp:Label>
                                                <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("IdPlayerMessage") %>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="120px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Message" SortExpression="Message">
                                            <ItemTemplate>

                                                <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("Message") %>' TextMode="MultiLine"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ExpirationDate" DataFormatString="{0:dd/MM/yy}" HeaderText="ExpirationDate" SortExpression="ExpirationDate" ItemStyle-CssClass="hidden-md-down" HeaderStyle-CssClass="hidden-md-down">
                                            <ItemStyle Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="LastModification" DataFormatString="{0:dd/MM/yy hh:mmtt}" HeaderText="Created" SortExpression="LastModification" ItemStyle-CssClass="hidden-md-down" HeaderStyle-CssClass="hidden-md-down">
                                            <ItemStyle Width="100px" />
                                        </asp:BoundField>
                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnSave" runat="server" CausesValidation="false" CommandName="btnSave" CssClass="btn btn-success"><i class="fa fa-save" aria-hidden="true"></i></asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="false" CommandName="btnDelete" CssClass="btn btn-danger"><i class="fa fa-trash" aria-hidden="true"></i></asp:LinkButton>

                                            </ItemTemplate>
                                            <ItemStyle Width="100px" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <HeaderStyle CssClass="GameHeader" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="ManagePlayerMessages_Get" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="ddlAgent" Name="prmIDAgent" PropertyName="SelectedValue" Type="Int32" />
                                        <asp:ControlParameter ControlID="ddlPlayer" Name="prmIdPlayer" PropertyName="SelectedValue" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </asp:Panel>
                        </div>
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
