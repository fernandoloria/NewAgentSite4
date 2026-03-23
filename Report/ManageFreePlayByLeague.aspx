<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ManageFreePlayByLeague.aspx.cs" Inherits="AgentSite4.Report.ManageFreePlayByLeague" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">


                <div class="row page-titles">
                    <div class="col-md-12 col-12 align-self-center">
                        <h3 class="main-title m-b-0 m-t-0">Manage FreePlay By League</h3>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-2">
                                        <div class="form-group">
                                            <label class="control-label">Agent:</label>

                                            <asp:DropDownList ID="ddlAgents" runat="server" DataSourceID="SqlDataSource2" CssClass="form-control form-control-sm tomlist"
                                                DataTextField="Agent" DataValueField="IdAgent"
                                                OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged"
                                                AutoPostBack="True">
                                            </asp:DropDownList>

                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-2">
                                        <div class="form-group">
                                            <input type="submit" name="ctl00$MainContent$btnSumit" value="Submit" id="ctl00_MainContent_btnSumit" class="btn btn-danger" onclick="return ctl00_MainContent_btnSumit_onclick()">
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <span>Click on the checkbox to allow or deny FreePlay wagers in these leagues.</span><br />
                                    <label for="checkbox_id">
                                        <input type="checkbox" checked disabled>This league does allow FreePlay wagers.</label><br />
                                    <label for="checkbox_id">
                                        <input type="checkbox" disabled>This league does NOT allow FreePlay wagers.</label><br />
                                    <label for="disabled_explanation" style="color: red;">
                                        <input type="checkbox" disabled>Fields disabled are denied by your master agent.</label>
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
                                        EnableModelValidation="True" OnDataBound="GridView1_DataBound" Width="99%" class="filter table-bordered"
                                        border="0" OnRowCommand="GridView1_RowCommand">
                                        <AlternatingRowStyle CssClass="TrGameEven" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Sport" SortExpression="idSport">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Bind("IdLeague") %>' />
                                                    <div class="leagueHeader">
                                                        <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Bind("RowDescription") %>' />
                                                    </div>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("idSport") %>' Style="font-weight: 700"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="League" SortExpression="LeagueDescription">
                                                <ItemTemplate>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("LeagueDescription") %>' Style="font-weight: 700"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Allow/Deny" SortExpression="active">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="CheckBox1" runat="server"
                                                        Checked='<%# Bind("active") %>' Text="<%# Visible %>"
                                                        Enabled='<%# !Convert.ToBoolean(Eval("DisabledByParent")) %>'
                                                        CommandArgument='<%# ((GridViewRow) Container).RowIndex %>'
                                                        CommandName="chkbocCheck" AutoPostBack="true"
                                                        OnCheckedChanged="CheckBox1_CheckedChanged1" CssClass="turnLeague specialCheck" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="IdLeague" HeaderText="IdLeague" SortExpression="IdLeague" />
                                        </Columns>
                                        <HeaderStyle CssClass="GameHeader" />
                                        <RowStyle CssClass="TrGameOdd " />
                                    </asp:GridView>

                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                                        SelectCommand="ManageFreePlayByLeague_Get"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlAgents" Name="prmIdAgent"
                                                PropertyName="SelectedValue" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>

                                    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                                        SelectCommand="AddOn_GetAllSubAgents" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:SessionParameter DefaultValue="0" Name="idAgent" SessionField="SubIdAgent"
                                                Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>

                                </div>



                            </div>
                        </div>
                    </div>
                </div>


                <script type="text/javascript">
                    $(document).ready(function () {
                        $('.hideAll, .showAll').click(function () {
                            var checkEnabled = $(this).hasClass('showAll'),
                                idAgent = $('select[name="ctl00$MainContent$ddlAgents"] option:selected').val()

                            if ($(this).hasClass('hideAll') && $(this).is(':checked')) {
                                $(this).siblings('.showAll').prop('checked', false);
                            } else if ($(this).hasClass('showAll') && $(this).is(':checked')) {
                                $(this).siblings('.hideAll').prop('checked', false);
                            }

                            if (!$(this).is(':checked')) return;

                            $(this).parents('tr').nextAll('tr').each(function () {
                                if ($(this).find('.sportTitle').length > 0) return false;
                                var idLeague = $(this).find('td:first-child input').first().val();
                                if (!idLeague || !idAgent) return true;
                                $(this).find('.turnLeague input').prop('checked', checkEnabled);
                                $.ajax({
                                    url: '/Services/UpdateLeagueFreePlay.ashx',
                                    type: 'post',
                                    datatype: 'json',
                                    data: {
                                        idAgent: idAgent,
                                        idLeague: idLeague,
                                        deny: checkEnabled
                                    },
                                    success: function () {
                                        console.log('success');
                                    },
                                    error: function (jqXHR, textStatus, errorThrown) {
                                        console.error('AJAX request failed:', textStatus, errorThrown);
                                        console.error('Server response:', jqXHR.responseText);
                                    }
                                });
                            });
                        });
                    });
                </script>

    </div>
</asp:Content>
