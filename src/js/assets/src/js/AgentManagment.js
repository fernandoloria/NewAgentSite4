
function renderTree(nodes, parentId, level = 0) {
    var html = '<ul class="treeview">';
    nodes.forEach(function (node, index) {
        var nodeId = parentId ? parentId + '-' + node.IdAgent : 'node-' + node.IdAgent;
        var hasChildren = node.Children && node.Children.length > 0;
        var collapseClass = hasChildren ? 'collapse' : '';
        var expandedClass = hasChildren ? '' : 'show';

        html += '<li class="tv-item ' + (hasChildren ? 'tv-folder' : '') + '">';
        html += '<div class="tv-header" id="heading-' + nodeId + '">';
        html += '<div class="tv-collapsible" data-bs-toggle="collapse" data-bs-target="#' + nodeId + '" aria-expanded="' + (hasChildren ? 'false' : 'true') + '" aria-controls="' + nodeId + '">';
        html += '<div class="icon">' +
            '<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-right" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">' +
            '<path stroke="none" d="M0 0h24v24H0z" fill="none"></path>' +
            '<polyline points="9 6 15 12 9 18"></polyline>' +
            '</svg>' +
            '</div>';
        html += '<p class="title">' + node.Agent + '</p>';
        html += '</div>';
        html += '</div>';
        if (index === 0 || level === 0) {
            html += '<div class="tv-header-columns">';
            html += '<table class="table-dynamic table table-bordered table-striped"><tr>';
            html += '<td class="tv-column">Password</td>';
            html += '<td class="tv-column">Enable</td>';
            html += '<td class="tv-column">Online Access</td>';
            html += '<td class="tv-column">Is Distributor</td>';
            html += '<td class="tv-column">dontXFer</td>';
            html += '<td class="tv-column">Current Balance</td>';
            html += '<td class="tv-column">This Week</td>';
            html += '<td class="tv-column">Last Week</td>';
            html += '<td class="tv-column">MakeUp</td>';
            html += '<td class="tv-column">Agent Type</td>';
            html += '<td class="tv-column">Commision</td>';
            html += '<td class="tv-column">Manage</td>';
            html += '</tr></table>';
        }
        if (hasChildren) {
            html += '<div id="' + nodeId + '" class="treeview-collapse ' + collapseClass + ' ' + expandedClass + '" aria-labelledby="heading-' + nodeId + '">';
            html += renderTree(node.Children, nodeId, level + 1);
            html += '</div>';
        }
        html += '<div class="tv-content">';
        html += '<table class="table-dynamic table table-bordered table-striped"><tr>';
        html += '<td class="password"><div class="input-group input-group-extra-sm mb-1"><input type="password" class="form-control form-control-sm" id="password-' + node.IdAgent + '" value="' + node.Password + '" readonly><span class="input-group-text eye-icon" onclick="togglePasswordVisibility(\'password-' + node.IdAgent + '\')"><i class="fa fa-eye" id="eyeIcon-password-' + node.IdAgent + '"></i></span></div></td>';
        html += generateSwitchControl(node.enable, 'enable-' + node.IdAgent);
        html += generateSwitchControl(node.OnlineAccess, 'onlineAccess-' + node.IdAgent);
        html += generateSwitchControl(node.IsDistributor, 'isDistributor-' + node.IdAgent);
        html += generateSwitchControl(node.DontXferPlayerActivity, 'dontXferPlayerActivity-' + node.IdAgent);
        html += '<td>' + node.CurrentBalance + '</td>';
        html += '<td>' + node.ThisWeek + '</td>';
        html += '<td>' + node.LastWeek + '</td>';
        html += '<td>' + node.MakeUp + '</td>';
        html += '<td>' + node.AgentType + '</td>';
        html += '<td>' + node.CommSports + '</td>';
        html += '<td><a href="/Report/ManageSubAgent.aspx?idAgent=' + node.IdAgent + '" class="btn btn-sm btn-primary"><i class="fa-duotone fa-gear"></i></a></td>';
        html += '</tr></table>';
        html += '</div>';
        html += '</li>';
    });
    html += '</ul>';
    return html;
}


function generateSwitchControl(value, id) {
    return '<td><div class="switch form-switch-custom switch-inline form-switch-primary form-switch-custom inner-text-toggle">' +
        '<div class="input-checkbox">' +
        '<span class="switch-chk-label label-left">ON</span>' +
        '<input class="switch-input" type="checkbox" role="switch" id="' + id + '" ' + (value ? 'checked' : '') + '>' +
        '<span class="switch-chk-label label-right">OFF</span>' +
        '</div>' +
        '</div></td>';
}

