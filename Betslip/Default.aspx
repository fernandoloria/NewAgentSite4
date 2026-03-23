<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AgentSite4.Betslip.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticket Wirter</title>

    <link href="assets/fonts/fontawesome/css/fontawesome.css" rel="stylesheet" />
    <link href="assets/fonts/fontawesome/css/all.css" rel="stylesheet" />

    <script type="text/javascript">
        function getRandom() { return Math.random(); }
        document.write('<link href="assets/css/root.css?v=' + getRandom() + '" rel="stylesheet" type="text/css" />');
        document.write('<link href="assets/css/custom.css?v=' + getRandom() + '" rel="stylesheet" type="text/css" />');
    </script>

    <script type="text/javascript" src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="assets/js/bootstrap-select/bootstrap-select.js"></script>
    <script type="text/javascript" src="assets/js/plugins.js?v=1235"></script>
    <script type="text/javascript" src="assets/js/md5.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sticky-kit/1.1.3/sticky-kit.min.js"></script>
    <script type="text/javascript">
        document.write('<script src="assets/js/web.js?v=' + getRandom() + '"><\/script>');
        document.write('<script src="assets/js/main.js?v=' + getRandom() + '"><\/script>');
    </script>

    <style type="text/css">
        html, body {
            height: 100%;
        }

        .center-screen {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .card-box {
            max-width: 520px;
            width: 100%;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            background: #fff;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

            .card-box h3 {
                margin: 0 0 16px 0;
            }

        .player-strong {
            font-weight: 600;
            color: #111;
        }

        .text-muted {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="center-screen">
            <div class="card-box">
                <h3 class="text-center"><i class="fa fa-user"></i>Pick a Player</h3>

                <asp:Literal ID="litMsg" runat="server" />

                <div class="form-group">
                    <label for="<%= ddlPlayers.ClientID %>">Player</label>
                    <asp:DropDownList ID="ddlPlayers" runat="server"
                        CssClass="selectpicker form-control"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlPlayers_SelectedIndexChanged"
                        data-live-search="true" data-size="10" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            (function () {
                function init() {
                    try {
                        $('.selectpicker').selectpicker();
                        // Forzar postback al cambiar para disparar SelectedIndexChanged
                        $('.selectpicker').on('changed.bs.select', function () {
                            __doPostBack('<%= ddlPlayers.UniqueID %>', '');
                    });
                    } catch (e) { }
                }
                if (window.jQuery) { jQuery(init); }
                else if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', init); }
                else { init(); }
            })();

            (function () {
                function run() {
                    try {
                        if (window.parent && window.parent !== window) {
                            var frs = window.parent.frames;
                            for (var i = 0; i < frs.length; i++) {
                                var w = frs[i];
                                if (w === window) continue;
                                try {
                                    if (typeof w.toggleAgentCol === 'function') {
                                        w.toggleAgentCol();
                                        return;
                                    }
                                } catch (e) { }
                            }
                        }
                    } catch (e) { }

                    try {
                        if (window.top && window.top !== window && window.top !== window.parent) {
                            var tfrs = window.top.frames;
                            for (var j = 0; j < tfrs.length; j++) {
                                var w2 = tfrs[j];
                                if (w2 === window) continue;
                                try {
                                    if (typeof w2.toggleAgentCol === 'function') {
                                        w2.toggleAgentCol();
                                        return;
                                    }
                                } catch (e) { }
                            }
                        }
                    } catch (e) { }
                }

                if (window.jQuery) {
                    jQuery(run);
                } else if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', run);
                } else {
                    run();
                }
            })();
        </script>
    </form>
</body>
</html>

