<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="DashboardSettings.aspx.cs" Inherits="AgentSite4.Report.DashboardSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <style>
 .color-select option[value="bg-primary"]   { background-color: var(--bs-primary);   color:#fff; }
.color-select option[value="bg-secondary"] { background-color: var(--bs-secondary); color:#fff; }
.color-select option[value="bg-success"]   { background-color: var(--bs-success);   color:#fff; }
.color-select option[value="bg-danger"]    { background-color: var(--bs-danger);    color:#fff; }
.color-select option[value="bg-warning"]   { background-color: var(--bs-warning);   color:#000; }
.color-select option[value="bg-info"]      { background-color: var(--bs-info);      color:#000; }
.color-select option[value="bg-dark"]      { background-color: var(--bs-dark);      color:#fff; }
.color-select option[value="bg-light"]     { background-color: var(--bs-light);     color:#000; }


   </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">

        <div class="card mb-3">
            <div class="card-body">
                <div class="row g-2 align-items-end">
                    <div class="col-lg-4">
                        <label class="form-label">Report</label>
                        <asp:DropDownList ID="ddlAddReport" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-lg-2">
                        <label class="form-label">Color</label>
                        <asp:DropDownList ID="ddlAddCss" runat="server" CssClass="form-select color-select">
                            <asp:ListItem Value="bg-primary"  Text="Primary" />
                            <asp:ListItem Value="bg-secondary" Text="Secondary" />
                            <asp:ListItem Value="bg-success"   Text="Success" />
                            <asp:ListItem Value="bg-danger"    Text="Danger" />
                            <asp:ListItem Value="bg-warning"   Text="Warning" />
                            <asp:ListItem Value="bg-info"      Text="Info" />
                            <asp:ListItem Value="bg-dark"      Text="Dark" />
                            <asp:ListItem Value="bg-light"     Text="Light" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-lg-4">
                        <label class="form-label">
                            <a href="https://fontawesome.com/v6/search?ip=duotone&o=r"
                               target="_blank" rel="noopener"
                               class="d-inline-flex align-items-center gap-1 text-decoration-none">
                              <i class="fa-duotone fa-magnifying-glass fa-sm"></i>
                              Icon
                            </a>
                        </label>
                        <div class="input-group">
                            <asp:DropDownList ID="ddlAddIcon" runat="server" CssClass="form-select"></asp:DropDownList>
                            <span class="input-group-text">
                                <i id="icoAddPreview" runat="server" ClientIDMode="Static" class="fa-solid fa-file"></i>
                            </span>
                        </div>
                    </div>

                    <div class="col-lg-1">
                        <label class="form-label">Order</label>
                        <asp:TextBox ID="txtAddOrder" runat="server" CssClass="form-control" MaxLength="4"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revAddOrder" runat="server"
                            ControlToValidate="txtAddOrder" CssClass="text-danger"
                            ValidationExpression="^\d{1,4}$" ErrorMessage="Only numbers" Display="Dynamic" />
                    </div>

                    <div class="col-lg-1">
                        <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary w-100" Text="Add" OnClick="btnAdd_Click" />
                    </div>
                   
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvButtons" runat="server"
                CssClass="table-dynamic table table-bordered table-striped"
                AutoGenerateColumns="False"
                DataKeyNames="idReport"
                OnRowDataBound="gvButtons_RowDataBound"
                OnRowEditing="gvButtons_RowEditing"
                OnRowCancelingEdit="gvButtons_RowCancelingEdit"
                OnRowUpdating="gvButtons_RowUpdating"
                OnRowDeleting="gvButtons_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="reportName" HeaderText="Name" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Color">
                        <ItemTemplate>
                            <span class="badge <%# Eval("css") %> text-light"><%# Eval("css") %></span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlCssEdit" runat="server" CssClass="form-select color-select">
                                <asp:ListItem Value="bg-primary"  Text="Primary" />
                                <asp:ListItem Value="bg-secondary" Text="Secondary" />
                                <asp:ListItem Value="bg-success"   Text="Success" />
                                <asp:ListItem Value="bg-danger"    Text="Danger" />
                                <asp:ListItem Value="bg-warning"   Text="Warning" />
                                <asp:ListItem Value="bg-info"      Text="Info" />
                                <asp:ListItem Value="bg-dark"      Text="Dark" />
                                <asp:ListItem Value="bg-light"     Text="Light" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemStyle Width="160px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Icon">
                        <ItemTemplate>
                            <i class='<%# Eval("icon") %> fa-2xl'></i>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="input-group">
                                <asp:DropDownList ID="ddlIconEdit" runat="server" CssClass="form-select"></asp:DropDownList>
                                <span class="input-group-text">
                                    <i id="icoEditPreview" runat="server"></i>
                                </span>
                            </div>
                        </EditItemTemplate>
                        <ItemStyle Width="320px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Order">
                        <ItemTemplate>
                            <span class="badge bg-light text-dark"><%# Eval("reportOrder") %></span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtOrderEdit" runat="server" CssClass="form-control" MaxLength="4"
                                         Text='<%# Bind("reportOrder") %>'></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revOrderEdit" runat="server"
                                ControlToValidate="txtOrderEdit" CssClass="text-danger"
                                ValidationExpression="^\d{1,4}$" ErrorMessage="Sólo números" />
                        </EditItemTemplate>
                        <ItemStyle Width="100px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="" ItemStyle-Width="140">
                        <ItemTemplate>
                            <div class="text-center">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary me-1"><i class="fa-duotone fa-solid fa-pencil"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('¿Eliminar este botón?');"><i class="fa-duotone fa-solid fa-trash"></i></asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="text-center">
                                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-primary me-1"><i class="fa-duotone fa-solid fa-floppy-disk"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-light"><i class="fa-duotone fa-solid fa-ban"></i></asp:LinkButton>
                            </div>
                        </EditItemTemplate>

                    <ItemStyle Width="140px"></ItemStyle>
                    </asp:TemplateField>

                </Columns>
                <HeaderStyle CssClass="trAgent" />
            </asp:GridView>
        </div>

        <script type="text/javascript">
            (function () {
                function normalizeFa(cls) {
                    if (!cls) return "";
                    return cls.indexOf("fa-duotone") >= 0 ? cls.replace("fa-duotone", "fa-solid") : cls;
                }
                document.addEventListener("change", function (e) {
                    if (e.target && (e.target.id.indexOf("ddlAddIcon") !== -1 || e.target.id.indexOf("ddlIconEdit") !== -1)) {
                        var val = normalizeFa(e.target.value);
                        var p = document.getElementById("icoAddPreview");
                        if (p) p.className = val + " fa-2xl";
                        var span = e.target.parentNode && e.target.parentNode.querySelector("span.input-group-text i");
                        if (span) span.className = val + " fa-lg";
                    }
                });
            })();

            (function () {
                var bgClasses = ["bg-primary", "bg-secondary", "bg-success", "bg-danger", "bg-warning", "bg-info", "bg-dark", "bg-light"];

                function syncSelectBg(sel) {
                    for (var i = 0; i < bgClasses.length; i++) { sel.classList.remove(bgClasses[i]); }
                    sel.classList.remove("text-white", "text-dark");

                    var v = sel.value;
                    if (bgClasses.indexOf(v) >= 0) {
                        sel.classList.add(v);
                        if (v === "bg-warning" || v === "bg-info" || v === "bg-light") {
                            sel.classList.add("text-dark");
                        } else {
                            sel.classList.add("text-white");
                        }
                    }
                }

                var selects = document.querySelectorAll("select.color-select");
                for (var i = 0; i < selects.length; i++) { syncSelectBg(selects[i]); }

                document.addEventListener("change", function (e) {
                    if (e.target && e.target.matches("select.color-select")) {
                        syncSelectBg(e.target);
                    }
                });
            })();
        </script>


    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Footer" runat="server"></asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server"></asp:Content>
