<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="WagerAlert.aspx.cs" Inherits="AgentSite4.Report.WagerAlert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
          <script type="text/javascript">
        function copyToClipboard(text) {
            var textField = document.createElement('textarea');
            textField.innerText = text;
            document.body.appendChild(textField);
            textField.select();
            document.execCommand('copy');
            textField.remove();
            alert('Copied to clipboard: ' + text);
        }
          </script>
    <div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Telegram Ticket Alert</h3>          
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <asp:Button ID="btnGeneratePasskey" runat="server" Text="Generate Passkey" OnClick="btnGeneratePasskey_Click" CssClass="btn btn-primary"/>
            <asp:HyperLink ID="hlOpenTelegram" runat="server" Text="Open in Telegram" NavigateUrl="" Target="_blank" Visible="false" CssClass="btn btn-secondary ml-2"/>
            <asp:Label ID="lblPasskey" runat="server" CssClass="ml-2"/>
        </div>
    </div>
       <center class="filter">
    <div class="row mt-3">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="ddlAgents">Agent:</label>
                                <asp:DropDownList ID="ddlAgents" runat="server" DataSourceID="SqlDataSource2" DataTextField="Agent" DataValueField="IdAgent" CssClass="form-control form-control-sm tomlist">
                                    <asp:ListItem Value="0" Selected="True">All</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="ddlPlayer">Player:</label>
                                <asp:DropDownList ID="ddlPlayer" runat="server" DataSourceID="SqlDataSource3" DataTextField="Player" DataValueField="IdPlayer" CssClass="form-control form-control-sm tomlist">
                                    <asp:ListItem Value="0" Selected="True">All</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="txtRiskAmount">Risk Amount:</label>
                                <asp:TextBox ID="txtRiskAmount" runat="server" Cssclass="form-control form-control-sm"/>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="form-group">
                                <label for="txtWinAmount">Win Amount:</label>
                                <asp:TextBox ID="txtWinAmount" runat="server" Cssclass="form-control form-control-sm"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12 text-right">
                            <asp:Button ID="btnSumit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSumit_Click" />
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
 
       
    </center>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
        EnableModelValidation="True" OnDataBound="GridView1_DataBound" Width="99%" class="table-dynamic table table-bordered table-striped table-sm table-responsive"
        border="0" onrowcommand="GridView1_RowCommand">
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
            <asp:TemplateField HeaderText="Player" SortExpression="Player">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Player") %>'></asp:Label>
                    <asp:HiddenField ID="HiddenField1" runat="server" 
                        Value='<%# Eval("idPlayer") %>' />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Player") %>' Cssclass="form-control form-control-sm"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Risk Amount" SortExpression="RiskAmount">
                <ItemTemplate>
                    <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("RiskAmount") %>' Cssclass="form-control form-control-sm"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ControlToValidate="TextBox6" ErrorMessage="*" 
                        ValidationExpression="^\d+(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("RiskAmount") %>' Cssclass="form-control form-control-sm"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Win Amount" SortExpression="WinAmount">
                <ItemTemplate>
                    <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("WinAmount") %>' Cssclass="form-control form-control-sm"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator32" 
                        runat="server" ControlToValidate="TextBox7" ErrorMessage="*" 
                        ValidationExpression="^\d+(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("WinAmount") %>' Cssclass="form-control form-control-sm"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active" SortExpression="Active">
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Active") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:ButtonField ButtonType="Button" CommandName="btnSave" Text="Save">
            <ControlStyle CssClass="btn btn-primary" />
            </asp:ButtonField>
            <asp:ButtonField ButtonType="Button" CommandName="btnDelete" Text="Delete">
            <ControlStyle CssClass="btn btn-danger" />
            </asp:ButtonField>
        </Columns>
        <HeaderStyle CssClass="page-titles" />
        <RowStyle CssClass="TrGameOdd " />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="BotAlert_Select" 
        SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="idAgent" SessionField="IdAgent" Type="Int32" />
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
                SelectCommand="GetPlayersByIdAgent" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlAgents" DefaultValue="0" Name="idAgent" 
                        PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
    <h1>
        <asp:Label ID="lblError" runat="server"></asp:Label></h1>
    </div>
</asp:Content>
