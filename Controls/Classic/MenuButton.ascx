<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuButton.ascx.cs" Inherits="AgentSite4.Controls.MenuButton" %>

<nav id="sidebar">

    <div class="navbar-nav theme-brand flex-row  text-center">
        <div class="nav-logo">
            <div class="nav-item theme-logo">
                <a href="/Report/Welcome.aspx">
                    <img src="/src/assets/img/logo.svg" class="navbar-logo" alt="logo">
                </a>
            </div>
            <div class="nav-item theme-text">
                <a href="/Report/Welcome.aspx" class="nav-link"><%=Session["SubAgent"] %> </a>
            </div>
        </div>
        <div class="nav-item sidebar-toggle">
            <div class="btn-toggle sidebarCollapse">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevrons-left">
                    <polyline points="11 17 6 12 11 7"></polyline><polyline points="18 17 13 12 18 7"></polyline></svg>
            </div>
        </div>
    </div>
    <%--<div class="shadow-bottom"></div>--%> 


    <asp:ListView ID="ListViewReports" runat="server">
        <LayoutTemplate>
            <ul class="list-unstyled menu-categories" id="sidebarnav">
                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
            </ul>
        </LayoutTemplate>
        <ItemTemplate>
            <li class="menu">
                <a href="#<%# Eval("CategoryID") %>" data-bs-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <div class="">
                        <div class='menuCategory <%# Eval("icon") %> feather' alt='<%# Eval("CategoryName") %>'></div>
                        <span><%# Eval("CategoryName") %></span>
                    </div>
                    <div>
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-right">
                            <polyline points="9 18 15 12 9 6"></polyline></svg>

                    </div>
                </a>
                <ul class="collapse submenu list-unstyled" id="<%# Eval("CategoryID") %>" data-bs-parent="#sidebarnav">
                    <asp:Repeater ID="ReportsRepeater" runat="server" DataSource='<%# Eval("Reports") %>'>
                        <ItemTemplate>
                            <li>
                                <asp:HyperLink runat="server" NavigateUrl='<%# Eval("URL") %>' Target="_self"><%# Eval("Name") %></asp:HyperLink>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </li>
        </ItemTemplate>
    </asp:ListView>

</nav>

<script>
    // ============================================================== 
    // Auto select left navbar
    // ============================================================== 
    $(function () {
        var url = window.location;
        var element = $('ul#sidebarnav a').filter(function () {
            return this.href == url;
        }).addClass('active').parent().addClass('active');
        while (true) {
            if (element.is('li')) {
                element = element.parent().addClass('in show').parent().addClass('active');

            }
            else {
                break;
            }
        }

    });

    document.addEventListener("DOMContentLoaded", function () {
        const menuLinks = document.querySelectorAll('a[data-bs-toggle="collapse"]');
            menuLinks.forEach(link => {
            link.addEventListener("click", function (e) {
                const targetId = this.getAttribute("href").replace("#", "");
                if (targetId.toLowerCase() === "dashboard") {
                    e.preventDefault(); 
                    const dashboardLink = document.querySelector('#' + targetId + ' a[href="Welcome.aspx"]');
                    if (dashboardLink) {
                        window.location.href = dashboardLink.getAttribute("href");
                    }
                }
            });
        });
    });

</script>

<style>
    .menuCategory {
        width: 24px;
        height: 24px;
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
        display: inline-block;
    }

    .financial {
        background-image: url('/src/fontawesome/duotone/chart-mixed-up-circle-dollar.svg');
    }

    .dashboard {
        background-image: url('/src/fontawesome/duotone/gauge.svg');
    }

    .agent {
        background-image: url('/src/fontawesome/duotone/user-tie.svg');
    }

    .lines {
        background-image: url('/src/fontawesome/duotone/chart-line-up-down.svg');
    }

    .management {
        background-image: url('/src/fontawesome/duotone/sliders.svg');
    }

    .player {
        background-image: url('/src/fontawesome/duotone/users.svg');
    }

    .wager {
        background-image: url('/src/fontawesome/duotone/money-bill-trend-up.svg');
    }
</style>
