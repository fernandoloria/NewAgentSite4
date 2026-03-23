<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerManagementV5.aspx.cs" Inherits="AgentSite4.Report.PlayerManagementV5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
       <script language="JavaScript">


        function GetOpenBets(Id) {
            Id = Id + "";
            window.open('../Popup/OpenBetsPop.aspx?IdPlayer=' + Id + '', null, 'scrollbars=yes,directories=no,height=400,width=700,menubar=no,left=50,top=80');
        }

        function GetPlayerPayment(idPlayer) {
            var Currency = document.getElementById('cCurrency');
            window.open('PlayerPayment2.aspx?player=' + idPlayer, null, 'scrollbars=yes,directories=no,height=600,width=993,menubar=no,left=50,top=10');
        }


       </script>
    <style>
        .playerName {
            width: 10% !important;
            max-width: 113px !important;
            min-width: 113px !important;
        }

        .weekDay {
            width: 7%;
        }

        .bow {
            width: 9%;
        }

        @media(min-width:480px) {
            .tblWeeklyBalance td {
                font-weight: 600;
            }

            .bold td {
                font-weight: 900 !important;
            }
        }

        @media (max-width: 767px) {
            td, th {
                padding: 1px;
                font-size: 7px;
            }

            .wb_passowrd {
                font-size: 0.4rem;
            }

            a.editUser {
            }

            .playerName {
                max-width: 65px !important;
                min-width: 65px !important;
            }
        }

        @media (max-width: 480px) {
            .tblWeeklyBalance td {
                font-size: 6.5px;
            }
    </style>

    <div class="dgsContent">


        <div class="row page-titles">
            <div class="col-md-5 col-8 align-self-center">
                <h3 class="text-themecolor m-b-0 m-t-0">Players Management</h3>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="../Report/Welcome.aspx" target="_self">Home</a></li>
                    <li class="breadcrumb-item active">Players Management</li>
                </ol>
            </div>
            <div class="col-md-7 col-4 align-self-center">
                <div class="d-flex m-t-10 justify-content-end">
                    <div class="d-flex m-r-20 m-l-10 hidden-md-down">
                    </div>
                    <div class="">
                        <button class="btn btn-secondary" type="button" onclick="window.print();"><i class="fa fa-print"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div align="right">
            <a href="/Report/AddPlayer.aspx" class="btn btn-danger">Add Player</a> <a href="/Report/AddAgent.aspx" class="btn btn-danger">Add Agent</a> <a href="ManagePlayerMessage.aspx" class="btn btn-primary"><i class="fa fa-envelope" aria-hidden="true"></i>New Online Msg</a>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <%

        //int prmIdAgent = 10818;
        int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
        string prmAgent = this.Session["SubAgent"].ToString();
            
        
                Response.Write(buildAgent(prmIdAgent, prmAgent));


                    
        
    %>
            </div>
            <!-- dgsContent -->
        </div>
</asp:Content>
