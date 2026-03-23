<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerHistoryNew.aspx.cs" Inherits="AgentSite4.Report.PlayerHistoryNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="dgsContent">
    <script type="text/javascript">
        function fnExcelReport() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var tab = document.getElementById('ctl00_MainContent_gvMaster');
            for (var j = 0; j < tab.rows.length; j++) {
                tab_text += tab.rows[j].innerHTML + "</tr>";
            }
            tab_text += "</table>";
            tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");
            tab_text = tab_text.replace(/<img[^>]*>/gi, "");
            tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, "");
            var sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));
            return sa;
        }
        function openCal(inputId, anchorId) {
            if (typeof cal !== "undefined" && cal.select) {
                cal.select(document.getElementById(inputId), anchorId, 'MM/dd/yyyy');
            }
        }
    </script>

    <div class="row">
      <div class="page-titles">
        <h4>Player History</h4>
      </div>
    </div>

    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-body">
            <div class="row g-3 align-items-end">

              <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                <label for="<%= txtInitialDate.ClientID %>" class="form-label">Initial Date:</label>
                <div class="input-group input-group-sm">
                  <asp:TextBox ID="txtInitialDate" runat="server" CssClass="form-control form-control-sm datepicker" name="Date1"></asp:TextBox>
                  <button type="button" class="btn btn-outline-secondary" id="anchor1"
                          onclick="openCal('<%= txtInitialDate.ClientID %>','anchor1'); return false;">
                    <i class="fa-regular fa-calendar"></i>
                  </button>
                </div>
              </div>

              <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                <label for="<%= txtFinalDate.ClientID %>" class="form-label">Final Date:</label>
                <div class="input-group input-group-sm">
                  <asp:TextBox ID="txtFinalDate" runat="server" CssClass="form-control form-control-sm datepicker" name="Date2"></asp:TextBox>
                  <button type="button" class="btn btn-outline-secondary" id="anchor2"
                          onclick="openCal('<%= txtFinalDate.ClientID %>','anchor2'); return false;">
                    <i class="fa-regular fa-calendar"></i>
                  </button>
                </div>
              </div>

              <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                <label for="<%= ddlPlayer.ClientID %>" class="form-label">History for Player:</label>
                <asp:DropDownList ID="ddlPlayer" runat="server" CssClass="form-control form-control-sm tomlist"></asp:DropDownList>
              </div>

              <div class="col-12 col-md-4 col-lg-3 col-xl-2">
                <label for="<%= ddlTranType.ClientID %>" class="form-label">Transaction Type:</label>
                <asp:DropDownList ID="ddlTranType" runat="server" CssClass="form-control form-control-sm tomlist">
                  <asp:ListItem Value="9">ALL</asp:ListItem>
                  <asp:ListItem Value="1">Wagers</asp:ListItem>
                  <asp:ListItem Value="3">Live wagers only</asp:ListItem>
                  <asp:ListItem Value="4">Casino only</asp:ListItem>
                  <asp:ListItem Value="6">Live Casino</asp:ListItem>
                  <asp:ListItem Value="8">Adjustments</asp:ListItem>
                  <asp:ListItem Value="2">Payments</asp:ListItem>
                  <asp:ListItem Value="7">Free Play</asp:ListItem>
                </asp:DropDownList>
              </div>

              <div class="col-12 col-md-4 col-lg-2 col-xl-1">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <asp:Button ID="btnSumit" runat="server" Text="Submit" CssClass="btn btn-primary w-100" OnClick="btnSumit_Click" />
              </div>

              <div class="col-12 col-md-4 col-lg-2 col-xl-1">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <button type="button" class="btn btn-outline-secondary w-100" onclick="fnExcelReport()">Export</button>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-body">
            <asp:Label ID="lblRowCount" runat="server"></asp:Label>
            <div class="table-responsive">
              <asp:GridView ID="gvMaster" runat="server" OnRowDataBound="gvMaster_RowDataBound"
                CssClass="table table-bordered table-striped table-sm align-items-center dt-table-hover dataTable no-footer">
              </asp:GridView>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</asp:Content>
