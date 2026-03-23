<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.ascx.cs" Inherits="AgentSite4.Controls.Dashboard" %>
<%@ Register Src="~/Controls/Classic/MenuButtonDashboard.ascx" TagPrefix="uc1" TagName="MenuButtonDashboard" %>
<%@ Register Src="~/Controls/Classic/SideBarTickets.ascx" TagPrefix="uc1" TagName="SideBarTickets" %>


<div class="layout-px-spacing">

    <div class="middle-content container-xxl p-0">

        <!--  BEGIN BREADCRUMBS  -->
        <div class="secondary-nav">
            <div class="breadcrumbs-container" data-page-heading="Analytics">
                <header class="header navbar navbar-expand-sm">
                    <a href="javascript:void(0);" class="btn-toggle sidebarCollapse" data-placement="bottom">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-menu">
                            <line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                    </a>
                    <div class="d-flex breadcrumb-content">
                        <div class="page-header">

                            <div class="page-title">
                            </div>

                            <nav class="breadcrumb-style-one" aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Analytics</li>
                                </ol>
                            </nav>

                        </div>
                    </div>
                </header>
            </div>
        </div>
        <!--  END BREADCRUMBS  -->

        <div class="row layout-top-spacing">

            <!-- FIGURES (ThisWeek + Today) -->
            <div class="col-xl-4 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                <div class="widget widget-six">
                    <div class="widget-heading">
                        <h6 class="value">Figures</h6>
                    </div>

                    <div class="w-chart">
                        <div class="w-chart-section">
                            <div class="w-detail">
                                <p class="w-title">This Week</p>
                                <p class="w-stats" data-field="grand-total-weekly">$0</p>
                            </div>
                            <div class="w-chart-render-one">
                                <div id="total-users"></div>
                            </div>
                        </div>

                        <div class="w-chart-section">
                            <div class="w-detail">
                                <p class="w-title">Today</p>
                                <p class="w-stats" data-field="grand-total-day">$0</p>
                            </div>
                            <div class="w-chart-render-one">
                                <div id="paid-visits"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ACTIVE PLAYERS -->
            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                <div class="widget widget-card-four">
                    <div class="widget-content">
                        <div class="w-header">
                            <div class="w-info">
                                <h6 class="value">Active Players</h6>
                            </div>
                        </div>

                        <div class="w-content">
                            <div class="w-info">
                                <p class="w-title">This Week</p>
                                <p class="value" data-field="grand-total-player">0</p>
                                <div class="w-chart-render-one" >
                                     
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trending-up">
                                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>



            <!-- AGENT BALANCE -->
            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                <div class="widget widget-card-five">
                    <div class="widget-content">
                        <div class="account-box">
                            <div class="info-box">
                                <div class="icon">
                                    <span>
                                        <img src="/src/assets/img/money-bag.png" alt="money-bag"></span>
                                </div>

                                <div class="balance-info">
                                    <h6>Agent Balance</h6>
                                    <p data-field="balance">$0.00</p>
                                </div>
                            </div>

                            <div class="card-bottom-section">
                                <a href="/Report/AgentHistory.aspx" class="">View Report</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <uc1:MenuButtonDashboard runat="server" ID="MenuButtonDashboard" />

            <div class="col-xl-9 col-lg-12 col-md-12 col-sm-12 col-12 layout-spacing">
                <div class="widget widget-chart-three">
                    <div class="widget-heading">
                        <div class="">
                            <h5 class="">Weekly Balance</h5>
                        </div>
                    </div>

                    <div class="widget-content">
                        <div id="uniqueVisits"></div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                <div class="widget widget-activity-five">
                    <div class="widget-heading">
                        <h5 class="">Bet Ticker</h5>
                    </div>
                    <div class="widget-content">
                        <div class="w-shadow-top"></div>
                        <div class="mt-container mx-auto">
                            <div class="timeline-line">
                                <uc1:SideBarTickets runat="server" ID="SideBarTickets" />
                            </div>
                        </div>
                        <div class="w-shadow-bottom"></div>
                    </div>
                </div>
            </div>


            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-12 col-12 layout-spacing">
                <div class="widget-four">
                    <div class="widget-heading">
                        <h5 class="">Sales</h5>
                    </div>
                    <div class="widget-content">
                        <div class="vistorsBrowser">
                            <div class="browser-list">
                                <div class="w-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chrome">
                                        <circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="4"></circle><line x1="21.17" y1="8" x2="12" y2="8"></line><line x1="3.95" y1="6.06" x2="8.54" y2="14"></line><line x1="10.88" y1="21.94" x2="15.46" y2="14"></line></svg>
                                </div>
                                <div class="w-browser-details">
                                    <div class="w-browser-info">
                                        <h6>Straigh Bet</h6>
                                        <p class="browser-count">65%</p>
                                    </div>
                                    <div class="w-browser-stats">
                                        <div class="progress">
                                            <div class="progress-bar bg-gradient-primary" role="progressbar" style="width: 65%" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="browser-list">
                                <div class="w-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-compass">
                                        <circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                                </div>
                                <div class="w-browser-details">

                                    <div class="w-browser-info">
                                        <h6>Parlay</h6>
                                        <p class="browser-count">25%</p>
                                    </div>

                                    <div class="w-browser-stats">
                                        <div class="progress">
                                            <div class="progress-bar bg-gradient-danger" role="progressbar" style="width: 35%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>

                                </div>

                            </div>

                            <div class="browser-list">
                                <div class="w-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-globe">
                                        <circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                                </div>
                                <div class="w-browser-details">

                                    <div class="w-browser-info">
                                        <h6>Others</h6>
                                        <p class="browser-count">15%</p>
                                    </div>

                                    <div class="w-browser-stats">
                                        <div class="progress">
                                            <div class="progress-bar bg-gradient-warning" role="progressbar" style="width: 15%" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>
                </div>
            </div>

            <div class="col-xl-8 col-lg-12 col-md-12 col-sm-12 col-12">
                <div class="row widget-statistic">
                    <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-12 layout-spacing">
                        <div class="widget widget-one_hybrid widget-followers">
                            <div class="widget-heading">
                                <div class="w-title">
                                    <div class="w-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-users">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    </div>
                                    <div class="">
                                        <p class="w-value">31.6K</p>
                                        <h5 class="">Free play</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div class="w-chart">
                                    <div id="hybrid_followers"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-12 layout-spacing">
                        <div class="widget widget-one_hybrid widget-referral">
                            <div class="widget-heading">
                                <div class="w-title">
                                    <div class="w-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-link">
                                            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>
                                    </div>
                                    <div class="">
                                        <p class="w-value">1,900</p>
                                        <h5 class="">Deleted Wager</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div class="w-chart">
                                    <div id="hybrid_followers1"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-12 layout-spacing">
                        <div class="widget widget-one_hybrid widget-engagement">
                            <div class="widget-heading">
                                <div class="w-title">
                                    <div class="w-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-message-circle">
                                            <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg>
                                    </div>
                                    <div class="">
                                        <p class="w-value">18.2%</p>
                                        <h5 class="">Payments</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div class="w-chart">
                                    <div id="hybrid_followers3"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>




        </div>

    </div>

</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        fetch('/services/WelcomeReport.ashx')
            .then(response => response.json())
            .then(data => {
                if (!data || !data.length) return;
                const report = data[0];

                const agentBalance = report.agentBalance || 0;
                const week = report.ThisWeek || 0;
                const active = report.CntActive || 0;

                const nowUtc = new Date();
                const estOffset = -5 * 60;
                const estTime = new Date(nowUtc.getTime() + estOffset * 60000 + nowUtc.getTimezoneOffset() * 60000);
                let day = estTime.getUTCDay();
                if (day === 0) day = 7;
                const todayValue = report['Day' + day] || 0;

                function formatCurrency(val) {
                    const absVal = Math.abs(val).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                    return (val >= 0 ? '+' : '-') + '$' + absVal;
                }

                document.querySelector('[data-field="balance"]').textContent = formatCurrency(agentBalance);
                document.querySelector('[data-field="grand-total-weekly"]').textContent = '$' + week.toLocaleString('en-US', { minimumFractionDigits: 2 });
                document.querySelector('[data-field="grand-total-day"]').textContent = formatCurrency(todayValue);
                document.querySelector('[data-field="grand-total-player"]').textContent = active;

                const daySpan = document.querySelector('[data-field="grand-total-day"]');
                const balanceSpan = document.querySelector('[data-field="balance"]');
                [daySpan, balanceSpan].forEach(span => {
                    if (parseFloat(span.textContent.replace(/[^0-9.-]/g, '')) < 0) {
                        span.classList.remove('positive');
                        span.classList.add('negative');
                    } else {
                        span.classList.remove('negative');
                        span.classList.add('positive');
                    }
                });
            })
            .catch(err => console.error('WelcomeReport fetch error:', err));
    });
</script>
