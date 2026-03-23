<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuAgent.ascx.cs" Inherits="AgentSite4.Controls.MenuAgent" %>
<%if (SubAgents != "")
    { %>



            <a href="javascript:void(0);" class="nav-link dropdown-toggle" id="agentTree" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-duotone fa-list-tree fa-2xl feather feather-bell"></i><span class="badge badge-success"></span>
            </a>

            <div class="dropdown-menu position-absolute" aria-labelledby="agentTree">
                <div class="drodpown-title message">
                    <h6 class="d-flex justify-content-between"><span class="align-self-center">Agent Tree</span> <span class="badge badge-primary"><%=SubAgents %></span></h6>
                </div>
                <label class="visually-hidden" for="agentSearchInput">Search agents</label>
                <div class="input-group">
                    <div class="input-group-text"><i class="fa-duotone fa-users"></i></div>
                    <input type="text" class="form-control" id="agentSearchInput" placeholder="Search agents">
                </div>
                <div class="notification-scroll">
                    <asp:TreeView ID="AgentMenu" runat="server" CssClass="AgentMenu" OnTreeNodeDataBound="TreeView1_TreeNodeDataBound" ExpandDepth="1" ImageSet="Msdn"  SkipLinkText="">
                        <LeafNodeStyle CssClass="tesr" />
                        
                    </asp:TreeView>
                </div>
            </div>

<%}
    else
    {%>
<script>
    console.log(window.frames["menu"]);

</script>
<% } %>


<script type="text/javascript">
    $(document).ready(function () {
        $('.dropdown-menu').on('click', function (e) {
            e.stopPropagation();
        });

        $('#<%= AgentMenu.ClientID %>').on('click', function (e) {
            e.stopPropagation();
        });

        $('#agentSearchInput').on('input', function () {
            var searchTerm = $(this).val().toLowerCase();
            $('#<%= AgentMenu.ClientID %> .MenuAgent').each(function () {
                var agentText = $(this).text().toLowerCase();
                $(this).closest('tr').toggle(agentText.includes(searchTerm));
            });
        });
    });


</script>


<style type="text/css">
    .agent-search-input {
        width: 100%;
        padding: 5px;
        margin-bottom: 10px;
        box-sizing: border-box;
    }

}
     .navbar .navbar-item .nav-item.notification-dropdown .dropdown-menu .agent-tree img {
        width: auto; /* or any specific width you want */
    height: auto; /* or any specific height you want */
    border-radius: 0; /* or any specific border-radius you want */
    border: none; /* or any specific border style you want */
    }

#ctl00_Header_MenuAgent1_AgentMenun0Nodes img {
    width: auto; /* or any specific width you want */
    height: auto; /* or any specific height you want */
    border-radius: 0; /* or any specific border-radius you want */
    border: none; 
}

#ctl00_Header_MenuAgent1_AgentMenun0Nodes span {
    font-family: "Font Awesome 5 Free" !important;
    font-weight: 900;
    cursor: pointer;
}

#ctl00_Header_MenuAgent1_AgentMenun0Nodes .fa-chevron-right:before {
    content: "\f054" !important; /* Font Awesome right arrow */
}

#ctl00_Header_MenuAgent1_AgentMenun0Nodes .fa-chevron-down:before {
    content: "\f078"  !important; /* Font Awesome down arrow */
}

</style>
