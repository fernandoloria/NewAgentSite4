<%@ Page Title="Import Hierarchy" Language="C#" MasterPageFile="~/Master/Classic/Report.Master"
    AutoEventWireup="true" CodeBehind="ImportHierarchy.aspx.cs"
    Inherits="AgentSite4.Report.ImportHierarchy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .import-summary {
            margin-top: 15px;
            margin-bottom: 15px;
        }

        .import-summary .card {
            margin-bottom: 10px;
        }

        .import-number {
            display: block;
            font-size: 22px;
            font-weight: 600;
        }

        .import-invalid {
            background-color: #f8d7da !important;
            color: #721c24;
        }

        .import-valid {
            background-color: #d4edda !important;
        }

        .import-help {
            margin-top: 8px;
            color: #6c757d;
        }

        .import-grid input {
            min-width: 90px;
        }

        .import-grid .account-field {
            min-width: 110px;
        }

        .import-grid .message-column {
            min-width: 260px;
            white-space: normal;
        }

        .import-filter-panel {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 12px;
            margin-bottom: 15px;
        }

        .import-filter-title {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .import-filter-message {
            display: block;
            margin-top: 8px;
            color: #495057;
        }

        .import-small-number {
            display: block;
            font-size: 12px;
            color: #6c757d;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-md-12">
                    <h3>Import Hierarchy</h3>
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger"></asp:Label>
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>
                </div>
            </div>

            <asp:Panel ID="pnlUpload" runat="server">
                <div class="card mt-3">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Parent Distributor</label>
                                    <asp:DropDownList ID="ddlDistributor" runat="server"
                                        CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Agent Template</label>
                                    <asp:DropDownList ID="ddlAgentClone" runat="server"
                                        CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Player Template Agent</label>
                                    <asp:DropDownList ID="ddlPlayerTemplateAgent" runat="server"
                                        CssClass="form-control form-control-sm"
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="ddlPlayerTemplateAgent_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Player Template</label>
                                    <asp:DropDownList ID="ddlPlayerClone" runat="server"
                                        CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Options</label>
                                    <div>
                                        <asp:CheckBox ID="chkCloneAgentRights" runat="server"
                                            Text=" Clone agent rights" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Excel or CSV File</label>
                                    <asp:FileUpload ID="fuHierarchy" runat="server"
                                        CssClass="form-control-file" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <asp:Button ID="btnUpload" runat="server"
                                    Text="Upload and Validate"
                                    CssClass="btn btn-primary"
                                    OnClick="btnUpload_Click" />

                                <asp:Button ID="btnDownloadExample" runat="server"
                                    Text="Download Example File"
                                    CssClass="btn btn-outline-secondary ml-2"
                                    CausesValidation="false"
                                    OnClick="btnDownloadExample_Click" />

                                <p class="import-help">
                                    Required columns:
                                    Agent, Agent_Password, IdPlayer, Player, Player_Password,
                                    CreditLimit, MinWager, MaxWager, OnlineMinWager and OnlineMaxWager.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlResults" runat="server" Visible="false">
                <div class="row import-summary">
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Status</span>
                                <asp:Label ID="lblStatus" runat="server" CssClass="import-number"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Total Agents</span>
                                <asp:Label ID="lblTotalAgents" runat="server" CssClass="import-number"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Invalid Agents</span>
                                <asp:Label ID="lblInvalidAgents" runat="server" CssClass="import-number text-danger"></asp:Label>
                                <span class="import-small-number">Duplicates:</span>
                                <asp:Label ID="lblDuplicateAgents" runat="server" CssClass="import-small-number text-danger"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Total Players</span>
                                <asp:Label ID="lblTotalPlayers" runat="server" CssClass="import-number"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Invalid Players</span>
                                <asp:Label ID="lblInvalidPlayers" runat="server" CssClass="import-number text-danger"></asp:Label>
                                <span class="import-small-number">Duplicates:</span>
                                <asp:Label ID="lblDuplicatePlayers" runat="server" CssClass="import-small-number text-danger"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card">
                            <div class="card-body">
                                <span>Batch</span>
                                <asp:Label ID="lblBatchId" runat="server" CssClass="small"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-12">
                        <asp:Button ID="btnRevalidate" runat="server"
                            Text="Revalidate Batch"
                            CssClass="btn btn-primary"
                            OnClick="btnRevalidate_Click" />

                        <asp:Button ID="btnNewImport" runat="server"
                            Text="Start New Import"
                            CssClass="btn btn-outline-secondary ml-2"
                            CausesValidation="false"
                            OnClick="btnNewImport_Click" />
                    </div>
                </div>

                <div class="import-filter-panel">
                    <span class="import-filter-title">Rows to display</span>

                    <asp:Button ID="btnShowDuplicates" runat="server"
                        Text="Duplicates Only"
                        CssClass="btn btn-sm btn-outline-danger"
                        CausesValidation="false"
                        OnClick="btnShowDuplicates_Click" />

                    <asp:Button ID="btnShowRowsToFix" runat="server"
                        Text="All Rows To Fix"
                        CssClass="btn btn-sm btn-outline-warning ml-2"
                        CausesValidation="false"
                        OnClick="btnShowRowsToFix_Click" />

                    <asp:Button ID="btnShowAllRows" runat="server"
                        Text="All Uploaded Rows"
                        CssClass="btn btn-sm btn-outline-secondary ml-2"
                        CausesValidation="false"
                        OnClick="btnShowAllRows_Click" />

                    <asp:Label ID="lblCurrentFilter" runat="server"
                        CssClass="import-filter-message"></asp:Label>
                </div>

                <div class="card mb-3">
                    <div class="card-header">
                        <strong>Agents</strong>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvAgents" runat="server"
                                CssClass="table table-sm table-bordered table-striped import-grid"
                                AutoGenerateColumns="false"
                                DataKeyNames="IdImportAgent"
                                AllowPaging="true"
                                PageSize="25"
                                OnPageIndexChanging="gvAgents_PageIndexChanging"
                                OnRowEditing="gvAgents_RowEditing"
                                OnRowCancelingEdit="gvAgents_RowCancelingEdit"
                                OnRowUpdating="gvAgents_RowUpdating"
                                OnRowDataBound="gvAgents_RowDataBound"
                                EmptyDataText="No agents were loaded.">
                                <Columns>
                                    <asp:BoundField DataField="SourceRowNumber" HeaderText="Row" ReadOnly="true" />
                                    <asp:TemplateField HeaderText="Agent">
                                        <ItemTemplate>
                                            <%# Eval("AgentAccount") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtAgentAccount" runat="server"
                                                CssClass="form-control form-control-sm account-field"
                                                MaxLength="100"
                                                Text='<%# Bind("AgentAccount") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Password">
                                        <ItemTemplate>
                                            <%# Eval("AgentPassword") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtAgentPassword" runat="server"
                                                CssClass="form-control form-control-sm"
                                                MaxLength="100"
                                                Text='<%# Bind("AgentPassword") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ExistingIdAgent" HeaderText="Existing ID" ReadOnly="true" />
                                    <asp:CheckBoxField DataField="IsValid" HeaderText="Valid" ReadOnly="true" />
                                    <asp:BoundField DataField="ValidationMessage" HeaderText="Validation Message"
                                        ReadOnly="true" ItemStyle-CssClass="message-column" />
                                    <asp:CommandField ShowEditButton="true" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <strong>Players</strong>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvPlayers" runat="server"
                                CssClass="table table-sm table-bordered table-striped import-grid"
                                AutoGenerateColumns="false"
                                DataKeyNames="IdImportPlayer"
                                AllowPaging="true"
                                PageSize="50"
                                OnPageIndexChanging="gvPlayers_PageIndexChanging"
                                OnRowEditing="gvPlayers_RowEditing"
                                OnRowCancelingEdit="gvPlayers_RowCancelingEdit"
                                OnRowUpdating="gvPlayers_RowUpdating"
                                OnRowDataBound="gvPlayers_RowDataBound"
                                EmptyDataText="No players were loaded.">
                                <Columns>
                                    <asp:BoundField DataField="SourceRowNumber" HeaderText="Row" ReadOnly="true" />
                                    <asp:TemplateField HeaderText="Agent">
                                        <ItemTemplate>
                                            <%# Eval("AgentAccount") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPlayerAgentAccount" runat="server"
                                                CssClass="form-control form-control-sm account-field"
                                                MaxLength="100"
                                                Text='<%# Bind("AgentAccount") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Player">
                                        <ItemTemplate>
                                            <%# Eval("PlayerAccount") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPlayerAccount" runat="server"
                                                CssClass="form-control form-control-sm account-field"
                                                MaxLength="10"
                                                Text='<%# Bind("PlayerAccount") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Password">
                                        <ItemTemplate>
                                            <%# Eval("PlayerPassword") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPlayerPassword" runat="server"
                                                CssClass="form-control form-control-sm"
                                                MaxLength="100"
                                                Text='<%# Bind("PlayerPassword") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Credit">
                                        <ItemTemplate><%# Eval("CreditLimit", "{0:0.##}") %></ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtCreditLimit" runat="server"
                                                CssClass="form-control form-control-sm"
                                                Text='<%# Bind("CreditLimit", "{0:0.##}") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Min">
                                        <ItemTemplate><%# Eval("MinWager", "{0:0.##}") %></ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMinWager" runat="server"
                                                CssClass="form-control form-control-sm"
                                                Text='<%# Bind("MinWager", "{0:0.##}") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max">
                                        <ItemTemplate><%# Eval("MaxWager", "{0:0.##}") %></ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMaxWager" runat="server"
                                                CssClass="form-control form-control-sm"
                                                Text='<%# Bind("MaxWager", "{0:0.##}") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Online Min">
                                        <ItemTemplate><%# Eval("OnlineMinWager", "{0:0.##}") %></ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOnlineMinWager" runat="server"
                                                CssClass="form-control form-control-sm"
                                                Text='<%# Bind("OnlineMinWager", "{0:0.##}") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Online Max">
                                        <ItemTemplate><%# Eval("OnlineMaxWager", "{0:0.##}") %></ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOnlineMaxWager" runat="server"
                                                CssClass="form-control form-control-sm"
                                                Text='<%# Bind("OnlineMaxWager", "{0:0.##}") %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ExistingIdPlayer" HeaderText="Existing ID" ReadOnly="true" />
                                    <asp:CheckBoxField DataField="IsValid" HeaderText="Valid" ReadOnly="true" />
                                    <asp:BoundField DataField="ValidationMessage" HeaderText="Validation Message"
                                        ReadOnly="true" ItemStyle-CssClass="message-column" />
                                    <asp:CommandField ShowEditButton="true" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
