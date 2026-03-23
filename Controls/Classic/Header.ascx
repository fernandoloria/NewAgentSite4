<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="AgentSite4.Controls.Header" %>
<%@ Register Src="~/Controls/Classic/MenuAgent.ascx" TagPrefix="uc1" TagName="MenuAgent" %>

<ul class="navbar-item theme-brand flex-row  text-center">
    <li class="nav-item theme-logo">
        <a href="/Report/Welcome.aspx">
            <img src="/src/assets/img/logo.svg?v=123" class="navbar-logo" alt="logo">
        </a>
    </li>
    <li class="nav-item theme-text">
        <a href="/Report/Welcome.aspx" class="nav-link"><%=Session["SubAgent"] %> </a>
    </li>
</ul>

<div class="search-animated toggle-search">
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
        <circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
    <div class="form-inline search-full form-inline search" role="search">
        <div class="search-bar" style="position: relative;">
            <input id="searchInput" type="text" class="form-control search-form-control ml-lg-auto" placeholder="Search..." autocomplete="off">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x search-close" style="cursor: pointer;">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </div>
        <ul id="userList" style="display: none;"></ul>
    </div>
    <span class="badge badge-secondary">Ctrl + /</span>
</div>

<ul class="navbar-item flex-row ms-lg-auto ms-0 action-area">


    <li class="nav-item theme-toggle-item">
        <a href="javascript:void(0);" class="nav-link theme-toggle">
            <i class="fa-duotone fa-sun fa-2xl feather feather-sun light-mode"></i>
            <i class="fa-duotone fa-moon-stars fa-2xl feather feather-moon dark-mode"></i>
        </a>
    </li>

    <li class="nav-item dropdown notification-dropdown">
        <uc1:MenuAgent runat="server" ID="MenuAgent1" />
    </li>

    <li class="nav-item dropdown user-profile-dropdown  order-lg-0 order-1">
        <a href="javascript:void(0);" class="nav-link dropdown-toggle user" id="userProfileDropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <div class="avatar-container">
                <i class="fa-duotone fa-user fa-2xl"></i>
            </div>
        </a>

        <div class="dropdown-menu position-absolute" aria-labelledby="userProfileDropdown">
            <div class="user-profile-section">
                <div class="media mx-auto">
                    <div class="emoji me-2">
                        &#x1F44B;
                    </div>
                    <div class="media-body">
                        <h5><%=Session["SubAgent"] %></h5>
                    </div>
                </div>
            </div>
            <div class="dropdown-item">
                <a href="UserProfile.aspx">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-user">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Profile</span>
                </a>
            </div>
            <div class="dropdown-item">
                <a href="App-Chat.aspx">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-inbox">
                        <polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"></path></svg>
                    <span>Inbox</span>
                </a>
            </div>
            <div class="dropdown-item">

                <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-lock">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    <span>Lock Screen</span>
                </asp:LinkButton>
            </div>
            <div class="dropdown-item">
                <a href="/Logout.aspx">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-log-out">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Log Out</span>
                </a>
            </div>
        </div>

    </li>
</ul>
