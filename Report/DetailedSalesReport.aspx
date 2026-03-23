<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="DetailedSalesReport.aspx.cs" Inherits="AgentSite4.Report.DetailedSalesReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <h3 class="page-title">Detailed Sales Report
        </h3>


        <div class="row">
            <div class="col-md-12">
                <div class="form-inline filter">
                    <div class="form-group">
                        <label>
                            From</label>
                        <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>

                    </div>
                    <div class="form-group">
                        <label>
                            To</label>
                        <asp:TextBox ID="txtDateTo" runat="server" Date2 class="form-control form-control-sm datepicker"></asp:TextBox>
                        
                    </div>
                    <div class="form-group">
                        <asp:Button ID="Button1" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                    </div>
                </div>
            </div>
        </div>

        <br />

        <asp:Panel runat="server" i ID="PnGrids">
        </asp:Panel>
    </div>
</asp:Content>
