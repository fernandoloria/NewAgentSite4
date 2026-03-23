<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentCommissionV2.aspx.cs" Inherits="AgentSite4.Report.AgentCommissionV2" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <%
            DateTime from = fromOrTo(true);
        %>
        <h3 class="page-title">Agent Commission Seattled Figure</h3>
        <ul class="page-breadcrumb breadcrumb">
            <li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx" target="mainFrame">Home</a><i
                    class="fa fa-angle-right"></i></li>
            <li><a href="#">Agent Commission Seattled Figure</a></li>
        </ul>
        <table cellspacing="1" cellpadding="1" border="0" class="pagination">
            <tr>
                <td>
                    <asp:LinkButton ID="lnkThisWeek" runat="server" OnClick="lnkThisWeek_Click" CssClass="link">This Week</asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="lnkLastWeek" runat="server" OnClick="lnkLastWeek_Click" CssClass="link">Last Week</asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="lnk2Weeks" runat="server" OnClick="lnk2Weeks_Click" CssClass="link">Two Weeks Ago</asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="lnk3Week" runat="server" OnClick="lnk3Weeks_Click" CssClass="link">Three Weeks Ago</asp:LinkButton>

                    &nbsp;|
                    Day Week Date
                </td>
                <td>
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                    <a href="#" onclick="JavaScript:cal.select(document.forms[0].ctl00_MainContent_txtDate,'anchor1','MM/dd/yyyy'); return false;"
                        name="anchor2" id="a2">
                        <img src="../App_Themes/Classic/images/calendar2.png" border="0" width="24" />
                    </a>
                </td>
                <td></td>
                <td></td>
                <td>
                    <input type="submit" value="Submit" name="Submit" class="btnForm" />
                </td>
            </tr>
        </table>
        <%
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            int maxPage = 0;
            try
            {
                Cnn.Open();
                int prmIdAgent = int.Parse(Session["IdAgent"].ToString());
                DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text);
                SqlCommand comm1 = new SqlCommand("AddOn_Web_Report_Agent_Weekly_BalanceComm", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = prmIdAgent;
                comm1.Parameters.Add("@prmDateWeek", SqlDbType.DateTime).Value = prmDateWeek;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();

                double totalPerAgent = 0;
                double generalTotal = 0;
                double activePlayers = 0;
                double totalPlayers = 0;
                string Agent = "";
                string lastAgent = "";
                int row = 0;
                while (reader.Read())
                {
                    double day1 = Convert.ToDouble(reader["Day1"].ToString());
                    double day2 = Convert.ToDouble(reader["Day2"].ToString());
                    double day3 = Convert.ToDouble(reader["Day3"].ToString());
                    double day4 = Convert.ToDouble(reader["Day4"].ToString());
                    double day5 = Convert.ToDouble(reader["Day5"].ToString());
                    double day6 = Convert.ToDouble(reader["Day6"].ToString());
                    double day7 = Convert.ToDouble(reader["Day7"].ToString());
                    double Ptms = Convert.ToDouble(reader["Pmts"].ToString());
                    double BalFwd = Convert.ToDouble(reader["BalFwd"].ToString());
                    double SettledFigure = Convert.ToDouble(reader["SettledFigure"].ToString());
                    double thisWeek = day1 + day2 + day3 + day4 + day5 + day6 + day7;
                    double newBalance = BalFwd + thisWeek + Ptms;

                    if (thisWeek > 0)
                    {
                        activePlayers += 1;
                    }

                    totalPlayers += 1;

                    if (lastAgent != reader["Agent"].ToString() && lastAgent != "")
                    {
        %>
                        <tr>
                            <td colspan="14" align="center"><strong>Total Players: <%= totalPlayers.ToString("N0")%> Total Active: <%= activePlayers.ToString("N0")%></strong></td>
                        </tr>
                        <%= printTotalAgent(lastAgent) %>
                        <%= printAgentComission(lastAgent) %>
                        </table><br />
        <%
                        totalPerAgent = 0;
                        generalTotal = 0;
                    }

                    if (Agent != reader["Agent"].ToString())
                    {
                        activePlayers = 1;
                        totalPlayers = 1;
                        totalPerAgent = 0;
                        generalTotal = 0;
                        Agent = reader["Agent"].ToString();
        %>
                        <table style="width: 98%;" cellspacing="0" cellpadding="3" border="0" class="filter table-bordered" align="center">
                            <tr>
                                <td colspan="14">
                                    <div class="portlet-title">
                                        <h4><%= Agent %></h4>
                                    </div>
                                </td>
                            </tr>
                            <tr class="GameHeader">
                                <td>Player</td>
                                <td>BalFwd</td>
                                <td>Mon</td>
                                <td>Tue</td>
                                <td>Wed</td>
                                <td>Thu</td>
                                <td>Fri</td>
                                <td>Sat</td>
                                <td>Sun</td>
                                <td>Week</td>
                                <td>Pmts</td>
                                <td>Balance</td>
                                <td>Settled Figure</td>
                                <td>Make Request</td>
                            </tr>
        <%
                    }
        %>
                    <tr class='<%= row % 2 == 0 ? "TrGameEven" : "TrGameOdd" %>'>
                        <td align="left">
                            <%= reader["Player"].ToString() %> (<%= reader["Password"].ToString() %>)
                        </td>
                        <td>
                            <%= BalFwd.ToString("N0") %>
                        </td>
                        <td>
                            <%= day1.ToString("N0") %>
                        </td>
                        <td>
                            <%= day2.ToString("N0") %>
                        </td>
                        <td>
                            <%= day3.ToString("N0") %>
                        </td>
                        <td>
                            <%= day4.ToString("N0") %>
                        </td>
                        <td>
                            <%= day5.ToString("N0") %>
                        </td>
                        <td>
                            <%= day6.ToString("N0") %>
                        </td>
                        <td>
                            <%= day7.ToString("N0") %>
                        </td>
                        <td>
                            <%= thisWeek.ToString("N0") %>
                        </td>
                        <td>
                            <%= Ptms.ToString("N0") %>
                        </td>
                        <td>
                            <%= newBalance.ToString("N0") %>
                        </td>
                        <td>
                            <%= SettledFigure.ToString("N0") %>
                        </td>
                        <td>
                            <a href="#">Request</a>
                        </td>
                    </tr>
        <%
                    lastAgent = reader["Agent"].ToString();
                    totalPerAgent = totalPerAgent + BalFwd;
                    generalTotal = generalTotal + SettledFigure;
                    Agent = reader["Agent"].ToString();
                    row++; // to determine even or odd
                }
        %>
                <tr>
                    <td colspan="14" align="center"><strong>Total Players: <%= totalPlayers.ToString("N0") %> Total Active: <%= activePlayers.ToString("N0") %></strong></td>
                </tr>
                <%= printTotalAgent(lastAgent) %>
                <%= printAgentComission(lastAgent) %>
            </table>
            <br />
            <table style="width: 98%;" cellspacing="0" cellpadding="3" border="0" class="filter table-bordered" align="center">
                <tr>
                    <td colspan="14">
                        <div class="portlet-title">
                            <h4><%= Session["Agent"].ToString() %></h4>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <%= printTotalAgent(Session["Agent"].ToString()) %>
                <%= printAgentComission(Session["Agent"].ToString()) %>
            </table>
        <%
            }
            catch (Exception e)
            {
                string nano = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        %>
    </div>
</asp:Content>
