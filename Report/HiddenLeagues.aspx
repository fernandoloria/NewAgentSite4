<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="HiddenLeagues.aspx.cs" Inherits="AgentSite4.Report.HiddenLeagues" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script language="javascript" type="text/javascript">
        // <![CDATA[

        function ctl00_MainContent_btnSumit_onclick() {

        }

// ]]>
    </script>

    <div class="dgsContent">


        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Hide and Show Leagues</h3>
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
                                    <label class="control-label">Line Type:</label>

                                    <asp:DropDownList ID="ddlLineTypes" runat="server"
                                        DataSourceID="SqlDataSource3" DataTextField="Description"
                                        OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged"
                                        DataValueField="IdLineType" AutoPostBack="True">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">

                                    <asp:CheckBox ID="chkAppyLineType" runat="server" Text="Apply to All"
                                        AutoPostBack="True" OnCheckedChanged="chkAppyLineType_CheckedChanged" />

                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">
                                    <input type="submit" name="ctl00$MainContent$btnSumit" value="Submit" id="ctl00_MainContent_btnSumit" class="btn btn-danger" onclick="return ctl00_MainContent_btnSumit_onclick()"></td>
                                </div>
                            </div>
                        </div>

                        <div>
                            <!--1-->
                            <span>Click on the checkbox to show or hide leagues</span><br />
                            <label for="checkbox_id">
                                <input type="checkbox" checked disabled>This League is Visible</label><br />
                            <label for="checkbox_id">
                                <input type="checkbox" disabled>This League is NOT Visible</label>
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
                                    <asp:TemplateField HeaderText="active" SortExpression="active">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server"
                                                Checked='<%# Bind("active") %>' Text="<%# Visible %>"
                                                CommandArgument='<%# ((GridViewRow) Container).RowIndex %>'
                                                CommandName="chkbocCheck" AutoPostBack="true"
                                                OnCheckedChanged="CheckBox1_CheckedChanged1" CssClass="turnLeague specialCheck" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="IdLeague" HeaderText="IdLeague" SortExpression="IdLeague" />
                                </Columns>
                                <HeaderStyle CssClass="page-titles" />
                                <RowStyle CssClass="TrGameOdd " />
                            </asp:GridView>

                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                                SelectCommand="AddOn_WebGetActiveLeaguesByAgent"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlAgents" Name="idAgent"
                                        PropertyName="SelectedValue" Type="Int32" />
                                    <asp:SessionParameter Name="IdBook" SessionField="IdBook" Type="Int16" DefaultValue="1" />
                                    <asp:ControlParameter ControlID="ddlLineTypes" Name="IdLineType"
                                        PropertyName="SelectedValue" Type="Int16" />
                                    <asp:Parameter Name="WagerType" Type="Byte" DefaultValue="0" />
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
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                                SelectCommand="AddOn_GetLineTypesByAgent" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlAgents" DefaultValue="1" Name="prmIDAgent"
                                        PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </div>
                        <!--1-->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.hideAll, .showAll').click(function () {

                var checkEnabled = false,
                    idAgent = $('select[name="ctl00$MainContent$ddlAgents"] option').filter(':selected').val(),
                    idLineType = $('select[name="ctl00$MainContent$ddlLineTypes"] option').filter(':selected').val();

                if ($(this).is(':checked') == false)
                    return;

                if ($(this).hasClass('showAll'))
                    checkEnabled = true;

                $(this).parents('tr').nextAll('tr').each(function () {

                    if ($(this).find('.sportTitle').length > 0)
                        return false; // breaks. exit loop

                    var idLeague = $(this).find('td:first-child').find('input').first().val();

                    if (idLeague == undefined || idAgent == undefined || idLineType == undefined || idLeague == '')
                        return true; // check next

                    $(this).find('.turnLeague input').prop('checked', checkEnabled);

                    $.ajax({
                        url: 'markLeagueHidden.ashx',
                        type: 'post',
                        datatype: 'json',
                        data: {
                            idAgent: idAgent,
                            idLeague: idLeague,
                            idLineType: idLineType,
                            enable: checkEnabled
                        },
                        success: function () {
                            console.log('success');
                        }
                    });

                });




            });
        });
    </script>

</asp:Content>
