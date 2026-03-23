<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="WeeklyBalancesEnhanced.aspx.cs" Inherits="AgentSite4.Report.WeeklyBalancesEnhanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
       <div class="row">
  <div class="col-12">
    <div class="card no-space">
      <div class="card-body no-space">
        <div class="row g-3 align-items-end">

          <div class="col-12 col-md-2 col-lg-2">
            <div class="mb-2">
              <label for="<%= txtDate.ClientID %>" class="form-label">Date</label>
              <asp:TextBox ID="txtDate" runat="server"
                CssClass="form-control form-control-sm datepicker" />
            </div>
          </div>

          <div class="col-12 col-md-2 col-lg-2">
            <div class="mb-2">
              <label for="<%= ddlTransactionType.ClientID %>" class="form-label">Transaction Type</label>
              <asp:DropDownList ID="ddlTransactionType" runat="server"
                CssClass="form-control form-control-sm tomlist" AutoPostBack="True">
                <asp:ListItem Value="-1">ALL TRANSACTION</asp:ListItem>
                <asp:ListItem Value="0">SPORT</asp:ListItem>
                <asp:ListItem Value="1">CASINO</asp:ListItem>
                <asp:ListItem Value="2">RACING</asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>

          <div class="col-12 col-md-2 col-lg-2">
            <div class="mb-2">
              <label for="<%= ddlDisplayOptions.ClientID %>" class="form-label">Display Options</label>
              <asp:DropDownList ID="ddlDisplayOptions" runat="server"
                CssClass="form-control form-control-sm tomlist" AutoPostBack="True">
                <asp:ListItem Value="0">ALL PLAYERS</asp:ListItem>
                <asp:ListItem Value="1">PLAYER WITH PENDING</asp:ListItem>
                <asp:ListItem Value="7" Selected="selected">PLAYERS WITH BALANCE</asp:ListItem>
                <asp:ListItem Value="3">ACTIVE PLAYERS</asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>

          <div class="col-12 col-md-2 col-lg-2">
            <div class="mb-2 d-grid">
              <asp:Button ID="Button1" runat="server" Text="Submit"
                CssClass="btn btn-primary" OnClick="Submit_Click" />
            </div>
          </div>

          <div class="col-12 col-md-4 col-lg-4">
            <div class="mb-2">
              <label for="<%= ddlWeeks.ClientID %>" class="form-label">Week Of</label>
              <asp:DropDownList ID="ddlWeeks" runat="server"
                CssClass="form-control form-control-sm tomlist"
                AutoPostBack="True" OnSelectedIndexChanged="ddlWeeks_Change">
                <asp:ListItem Value="">Week Of</asp:ListItem>
                <asp:ListItem Value="0">This week</asp:ListItem>
                <asp:ListItem Value="1">Last week</asp:ListItem>
                <asp:ListItem Value="2">2 weeks ago</asp:ListItem>
                <asp:ListItem Value="3">3 weeks ago</asp:ListItem>
                <asp:ListItem Value="4">4 weeks ago</asp:ListItem>
                <asp:ListItem Value="5">5 weeks ago</asp:ListItem>
                <asp:ListItem Value="6">6 weeks ago</asp:ListItem>
                <asp:ListItem Value="7">7 weeks ago</asp:ListItem>
                <asp:ListItem Value="8">8 weeks ago</asp:ListItem>
                <asp:ListItem Value="9">9 weeks ago</asp:ListItem>
                <asp:ListItem Value="10">10 weeks ago</asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</div>



        <center>
            <h4>- Weekly Balance of <%=GetWeekHeader() %> - </h4>
        </center>
        <asp:PlaceHolder ID="ReportHolder" runat="server" />

    </div>


</asp:Content>
<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="scripts">
    <style>
      @media (max-width: 767px) {
          /* --- Layout base --- */
        .playerName {
              width: auto !important;
              max-width: none !important;
        }

        .weekDay {
            width: 7%;
        }

        .bow {
            width: 9%;
        }

            td, th {
              font-size: 11px !important;
              padding: 4px !important;
            }

          /* --- Ajustes móviles --- */
          @media (max-width: 767px) {
            .wb_passowrd {
                  font-size: 0.6rem;
            }

            .container-fluid {
                  padding: 0 4px 25px 4px !important;
        }
        }

          /* --- Tablas expandibles --- */
          .tblWeeklyBalance,
          .table-dynamic {
              width: auto !important;
              display: block;
              overflow-x: auto !important;
              white-space: nowrap;
        }

              /* --- Scroll suave --- */
              .table-dynamic::-webkit-scrollbar {
                  height: 8px;
        }

              .table-dynamic::-webkit-scrollbar-thumb {
                  background: #126e51;
                  border-radius: 4px;
        }

              .table-dynamic::-webkit-scrollbar-track {
                  background: rgba(255,255,255,0.05);
        }
        }
</style>


</asp:Content>
