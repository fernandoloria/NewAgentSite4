<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LockScreen.aspx.cs" Inherits="AgentSite4.Report.LockScreen" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no">
    <title>Admin</title>

    <link rel="icon" type="image/x-icon" href="/src/assets/img/favicon.svg" />
    <link href="/layouts/vertical-light-menu/css/light/loader.css" rel="stylesheet" type="text/css" />
    <link href="/layouts/vertical-light-menu/css/dark/loader.css" rel="stylesheet" type="text/css" />
    <script src="/layouts/vertical-light-menu/loader.js?v=123"></script>

    <!-- BEGIN GLOBAL MANDATORY STYLES -->
    <link href="https://fonts.googleapis.com/css?family=Nunito:400,600,700" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <link href="/layouts/vertical-light-menu/css/light/plugins.css?v=124" rel="stylesheet" type="text/css" />
    <link href="/layouts/vertical-light-menu/css/dark/plugins.css?v=124" rel="stylesheet" type="text/css" />
    <link href="/src/fontawesome/css/fontawesome.css?v=123" rel="stylesheet">
    <link href="/src/fontawesome/css/all.css?v=123" rel="stylesheet">
    <!-- END GLOBAL MANDATORY STYLES -->

    <!-- BEGIN PAGE LEVEL PLUGINS/CUSTOM STYLES -->
    <link href="/src/plugins/src/apex/apexcharts.css" rel="stylesheet" type="text/css">
    <link href="/src/assets/css/light/dashboard/dash_1.css" rel="stylesheet" type="text/css" />
    <link href="/src/assets/css/dark/dashboard/dash_1.css" rel="stylesheet" type="text/css" />
    <!-- END PAGE LEVEL PLUGINS/CUSTOM STYLES -->

 

    <style>
        #loading {
            background: url(/src/assets/img/sports.gif) rgba(0,0,0,.815) no-repeat center center;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            z-index: 1999;
            -webkit-backdrop-filter: blur(5px);
            backdrop-filter: blur(5px)
        }
    </style>
    <script type="text/javascript">
        window.history.forward();

        function refreshPage() {
            window.location.reload(true);
        }

        setTimeout(refreshPage, 180000);
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-container d-flex h-100">

            <div class="container mx-auto align-self-center">

                <div class="row">

                    <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-8 col-12 d-flex flex-column align-self-center mx-auto">
                        <div class="card mt-3 mb-3">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-md-12 mb-3">

                                        <div class="media mb-4">

                                            <div class="avatar avatar-lg me-3">
                                                <img alt="avatar" src="../src/assets/img/profile-7.jpeg" class="rounded-circle">
                                            </div>

                                            <div class="media-body align-self-center">

                                                <h3 class="mb-0"><%=Session["Agent"] %></h3>
                                                <p class="mb-0">Enter your password to unlock your ID</p>
                                                <asp:Label ID="lblMessage" runat="server"></asp:Label>
                                            </div>

                                        </div>

                                    </div>
                                    <div class="col-12">
                                        <div class="mb-4">
                                            <label class="form-label">Password</label>

                                            <div class="input-group mb-3">
                                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" class="form-control form-control-sm" placeholder="Password"></asp:TextBox>

                                                <span class="input-group-text eye-icon" onclick="togglePasswordVisibility('ctl00_MainContent_txtPassword')"><i class="fa fa-eye" id="eyeIcon_txtPassword1"></i></span>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-12">
                                        <div class="mb-4">
                                            <asp:Button ID="btnUnlock" runat="server" CssClass="btn btn-secondary w-100" Text="UNLOCK" OnClick="btnUnlock_Click" />
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>

    </form>
</body>
</html>
