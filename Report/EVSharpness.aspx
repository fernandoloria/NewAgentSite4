<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="EVSharpness.aspx.cs" Inherits="AgentSite4.Report.EVSharpness" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script language="JavaScript" src="../App_Themes/Classic/CalendarPopup.js"></script>
    <script language="JavaScript">
        var cal = new CalendarPopup();

        $(document).ready(function () {
            setInterval(function () {
                $("#ctl00_MainContent_txtDateFrom").datepicker();
                $("#ctl00_MainContent_txtDateTo").datepicker();
            }, 400);
        });

        function exportEVSharpnessToExcel() {
            var table = document.getElementById('tblEVSharpness');

            if (table == null) {
                alert('No table to export.');
                return false;
            }

            var html = '<html xmlns:o="urn:schemas-microsoft-com:office:office" '
                + 'xmlns:x="urn:schemas-microsoft-com:office:excel" '
                + 'xmlns="http://www.w3.org/TR/REC-html40">'
                + '<head><meta charset="UTF-8"></head><body>'
                + table.outerHTML
                + '</body></html>';

            var blob = new Blob([html], { type: 'application/vnd.ms-excel' });
            var url = URL.createObjectURL(blob);
            var link = document.createElement("a");

            link.href = url;
            link.download = "EVSharpness_" + new Date().toISOString().slice(0, 10) + ".xls";

            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            return false;
        }
    </script>
    <style type="text/css">
        .ev-period {
            font-weight: bold;
            color: #555;
        }

        .tier-sharp {
            background-color: #FCE4D6 !important;
            color: #C00000 !important;
            font-weight: bold;
        }

        .tier-semi-sharp {
            background-color: #FFF2CC !important;
            color: #B8860B !important;
            font-weight: bold;
        }

        .tier-regular {
            background-color: #E2EFDA !important;
            color: #375623 !important;
            font-weight: bold;
        }

        .tier-insufficient {
            background-color: #E8E8E8 !important;
            color: #888888 !important;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="row">
            <div class="page-titles">
                <h4>EV Sharpness</h4>
            </div>
        </div>

        <table cellspacing="1" cellpadding="1" border="0" class="filter">
            <tbody>
                <tr>
                    <td>
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="<%= txtDateFrom.ClientID %>">From:</label><br />
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="<%= txtDateTo.ClientID %>">To:</label><br />
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group" style="margin-top:23px;">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group" style="margin-top:23px;">
                                    <button type="button" onclick="exportEVSharpnessToExcel(); return false;" class="btn btn-success">
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i> Excel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>

        <asp:PlaceHolder ID="ReportHolder" runat="server" />
    </div>
</asp:Content>
