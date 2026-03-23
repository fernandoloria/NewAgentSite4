<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerAccess.aspx.cs" Inherits="AgentSite4.Report.PlayerAccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <!-- Título -->
<div class="row">
  <div class="page-titles">
    <h4>Player Access</h4>
  </div>
</div>

<!-- Card: Filtros -->
<div class="row">
  <div class="col-12">
    <div class="card">
      <div class="card-body">
        <div class="row g-3 align-items-end">
          <div class="col-12 col-md-4 col-lg-3 col-xl-2">
            <label for="Date1" class="form-label">Initial Date:</label>
            <div class="input-group input-group-sm">
              <input type="text" class="form-control form-control-sm datepicker" name="Date1" id="Date1">
              <button type="button" class="btn btn-outline-secondary" id="anchor1"
                onclick="cal && cal.select(document.getElementById('Date1'),'anchor1','MM/dd/yyyy'); return false;">
                <i class="fa-regular fa-calendar"></i>
              </button>
            </div>
          </div>

          <div class="col-12 col-md-4 col-lg-3 col-xl-2">
            <label for="Date2" class="form-label">End Date:</label>
            <div class="input-group input-group-sm">
              <input type="text" class="form-control form-control-sm datepicker" name="Date2" id="Date2">
              <button type="button" class="btn btn-outline-secondary" id="anchor2"
                onclick="cal && cal.select(document.getElementById('Date2'),'anchor2','MM/dd/yyyy'); return false;">
                <i class="fa-regular fa-calendar"></i>
              </button>
            </div>
          </div>

          <div class="col-12 col-md-4 col-lg-3 col-xl-2">
            <label for="cPlayer" class="form-label">Player:</label>
            <select id="cPlayer" name="cPlayer" class="form-control form-control-sm tomlist">
              <option value="-1">All Players</option>
            </select>
          </div>

          <div class="col-12 col-md-4 col-lg-3 col-xl-2">
            <label for="txtIP" class="form-label">IP:</label>
            <input type="text" id="txtIP" name="txtIP" class="form-control form-control-sm">
          </div>

          <div class="col-6 col-md-2 col-xl-1">
            <label class="form-label d-none d-md-block">&nbsp;</label>
            <button type="button" id="btnSubmitPA" class="btn btn-primary w-100">Submit</button>
          </div>

          <div class="col-6 col-md-2 col-xl-1">
            <label class="form-label d-none d-md-block">&nbsp;</label>
            <button type="button" id="btnResetPA" class="btn btn-outline-secondary w-100">Reset</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Card: Tabla -->
<div class="row">
  <div class="col-12">
    <div class="card">
      <div class="card-body">

        <div class="row g-2 align-items-center mb-2">
          <div class="col-12 col-md-6">
            <div class="input-group input-group-sm">
              <span class="input-group-text"><i class="fa fa-search"></i></span>
              <input type="text" id="tableSearch" class="form-control" placeholder="Search...">
            </div>
          </div>
          <div class="col-6 col-md-3">
            <select id="pageSize" class="form-control form-control-sm tomlist">
              <option value="25">25 rows</option>
              <option value="50">50 rows</option>
              <option value="100">100 rows</option>
              <option value="250">250 rows</option>
            </select>
          </div>
          <div class="col-6 col-md-3 text-end">
            <small id="resultCount" class="text-muted"></small>
          </div>
        </div>

        <div id="paLoader" class="text-center my-3 d-none">
          <div class="spinner-border spinner-border-sm" role="status"></div>
          <span class="ms-2">Loading...</span>
        </div>

        <div class="table-responsive">
          <table id="paTable" class="table-dynamic table table-bordered table-striped">
            <thead>
              <tr class="trAgent">
                <th>Agent</th>
                <th>Player</th>
                <th>Start Time</th>
                <th>IP</th>
              </tr>
            </thead>
            <tbody id="paTbody"></tbody>
          </table>
        </div>

        <nav aria-label="Page navigation">
          <ul id="paPagination" class="pagination pagination-sm justify-content-center mt-2"></ul>
        </nav>

      </div>
    </div>
  </div>
</div>

<!-- Modal IPs -->
<div class="modal fade" id="ipModal" tabindex="-1" aria-labelledby="ipModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h6 class="modal-title" id="ipModalLabel">IPs</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="ipModalBody"></div>
    </div>
  </div>
</div>

<script>
    window.cal = window.cal || (typeof CalendarPopup !== 'undefined' ? new CalendarPopup() : null);

    const SERVICE_URL = '/services/playerAccess.ashx';

    let fullRows = [];
    let filteredRows = [];
    let sortField = 'Agent';
    let sortDir = 'asc';
    let currentPage = 1;
    let rowsPerPage = 25;

    const dqs = s => document.querySelector(s);
    const show = el => el.classList.remove('d-none');
    const hide = el => el.classList.add('d-none');

    function parseIPs(ipStr) {
        if (!ipStr) return [];
        return String(ipStr)
            .split(/[,\s;]+/g)
            .map(x => x.trim())
            .filter(Boolean);
    }

    function flattenAgentList(agentList) {
        const out = [];
        if (!Array.isArray(agentList)) return out;

        agentList.forEach(agent => {
            const agentName =
                agent.Agent ?? agent.AgentName ?? agent.Name ?? agent.agent ?? agent.agentName ?? agent.name ?? '';

            let detail = null;
            const candidates = ['Detail', 'Details', 'Access', 'AccessList', 'Calls', 'Rows', 'Items', 'Data', 'Players', 'Player'];
            for (const key of candidates) {
                if (Array.isArray(agent[key]) && agent[key].length && typeof agent[key][0] === 'object') { detail = agent[key]; break; }
            }
            if (!detail) {
                for (const k of Object.keys(agent)) {
                    if (Array.isArray(agent[k]) && agent[k].length && typeof agent[k][0] === 'object') { detail = agent[k]; break; }
                }
            }
            if (!detail) return;

            detail.forEach(it => {
                const row = {
                    Agent: agentName,
                    Player: it.Player ?? it.player ?? it.PlayerName ?? it.playerName ?? '',
                    StartTime: it.StartTime ?? it.Start ?? it.Date ?? '',
                    IPs: parseIPs(it.IP ?? it.Ip ?? it.IpList ?? it.ip)
                };
                out.push(row);
            });
        });
        return out;
    }

    function populatePlayerCombo(combo) {
        const sel = dqs('#cPlayer');
        sel.innerHTML = '<option value="-1">All Players</option>';
        const list = combo ?? [];
        let hasSelected = false;

        list.forEach(p => {
            const val = p.value ?? p.Value ?? p.idPlayer ?? p.IdPlayer;
            const txt = p.text ?? p.Text ?? p.Player ?? p.player ?? String(val ?? '');
            const selFlag = (p.selected ?? p.Selected) === true || (p.selected ?? '').toString().toLowerCase() === 'true';

            if (val != null) {
                const opt = document.createElement('option');
                opt.value = String(val);
                opt.textContent = String(txt);
                if (selFlag) { opt.selected = true; hasSelected = true; }
                sel.appendChild(opt);
            }
        });

        if (!hasSelected) sel.value = '-1';
    }

    function setFilterDefaults(resp) {
        if (resp && resp.StartDate) dqs('#Date1').value = resp.StartDate;
        if (resp && resp.EndDate) dqs('#Date2').value = resp.EndDate;
        if (resp && resp.IP) dqs('#txtIP').value = resp.IP;

        if (!dqs('#Date1').value) {
            const dt = new Date(Date.now() - 86400000);
            dqs('#Date1').value = `${(dt.getMonth() + 1).toString().padStart(2, '0')}/${dt.getDate().toString().padStart(2, '0')}/${dt.getFullYear()}`;
        }
        if (!dqs('#Date2').value) {
            const dt = new Date(Date.now() + 86400000);
            dqs('#Date2').value = `${(dt.getMonth() + 1).toString().padStart(2, '0')}/${dt.getDate().toString().padStart(2, '0')}/${dt.getFullYear()}`;
        }
    }

    function applySort() {
        if (!sortField) return;
        const dir = sortDir === 'asc' ? 1 : -1;
        filteredRows.sort((a, b) => {
            const va = (a[sortField] ?? '').toString().toLowerCase();
            const vb = (b[sortField] ?? '').toString().toLowerCase();
            if (va < vb) return -1 * dir;
            if (va > vb) return 1 * dir;
            return 0;
        });
    }

    function renderTable() {
        const tbody = dqs('#paTbody');
        tbody.innerHTML = '';

        const start = (currentPage - 1) * rowsPerPage;
        const end = Math.min(start + rowsPerPage, filteredRows.length);
        for (let i = start; i < end; i++) {
            const r = filteredRows[i];

            const tr = document.createElement('tr');

            const tdAgent = document.createElement('td');
            tdAgent.textContent = r.Agent || '';
            tr.appendChild(tdAgent);

            const tdPlayer = document.createElement('td');
            tdPlayer.textContent = r.Player || '';
            tr.appendChild(tdPlayer);

            const tdStart = document.createElement('td');
            tdStart.textContent = r.StartTime || '';
            tr.appendChild(tdStart);

            const tdIP = document.createElement('td');
            if (r.IPs.length) {
                const first = r.IPs[0];
                const a = document.createElement('a');
                a.href = 'https://ipinfo.io/' + encodeURIComponent(first) + '?lookup_source=search-bar';  
                a.target = '_blank';
                a.rel = 'noopener';
                a.textContent = first;

                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'btn btn-sm btn-outline-primary ms-2';
                btn.textContent = `View (${r.IPs.length})`;
                btn.dataset.rowIndex = String(i);
                btn.addEventListener('click', openIpModal);

                tdIP.appendChild(a);
                tdIP.appendChild(btn);
            } else {
                tdIP.textContent = '';
            }
            tr.appendChild(tdIP);

            tbody.appendChild(tr);
        }
        dqs('#resultCount').textContent = `${filteredRows.length} rows`;
    }

    function renderPagination() {
        const ul = dqs('#paPagination');
        ul.innerHTML = '';
        const totalPages = Math.max(1, Math.ceil(filteredRows.length / rowsPerPage));

        function add(label, page, disabled = false, active = false) {
            const li = document.createElement('li');
            li.className = `page-item ${disabled ? 'disabled' : ''} ${active ? 'active' : ''}`;
            const a = document.createElement('a');
            a.className = 'page-link';
            a.href = '#';
            a.textContent = label;
            a.onclick = (e) => { e.preventDefault(); if (!disabled && currentPage !== page) { currentPage = page; renderTable(); renderPagination(); } };
            li.appendChild(a); ul.appendChild(li);
        }

        add('«', Math.max(1, currentPage - 1), currentPage === 1);

        const windowSize = 5;
        let s = Math.max(1, currentPage - Math.floor(windowSize / 2));
        let e = Math.min(totalPages, s + windowSize - 1);
        if (e - s + 1 < windowSize) s = Math.max(1, e - windowSize + 1);

        if (s > 1) { add('1', 1, false, currentPage === 1); if (s > 2) add('...', currentPage, true, false); }
        for (let p = s; p <= e; p++) add(String(p), p, false, currentPage === p);
        if (e < totalPages) { if (e < totalPages - 1) add('...', currentPage, true, false); add(String(totalPages), totalPages, false, currentPage === totalPages); }

        add('»', Math.min(totalPages, currentPage + 1), currentPage === totalPages);
    }

    function applySearch(q) {
        if (!q) {
            filteredRows = [...fullRows];
        } else {
            const term = q.toLowerCase();
            filteredRows = fullRows.filter(r =>
                (r.Agent && r.Agent.toLowerCase().includes(term)) ||
                (r.Player && r.Player.toLowerCase().includes(term)) ||
                (r.StartTime && r.StartTime.toLowerCase().includes(term)) ||
                (r.IPs && r.IPs.some(ip => ip.toLowerCase().includes(term)))
            );
        }
        applySort(); currentPage = 1; renderTable(); renderPagination();
    }

    function buildFromResponse(resp) {
        const rows = flattenAgentList(resp?.AgentList);
        fullRows = rows;
        filteredRows = [...fullRows];
        sortField = 'Agent';
        sortDir = 'asc';
        applySort(); currentPage = 1; renderTable(); renderPagination();
    }

    function buildUrlWithQuery(base, payload) {
        const params = new URLSearchParams();
        Object.keys(payload).forEach(k => {
            if (payload[k] !== undefined && payload[k] !== null && payload[k] !== '') {
                params.append(k, payload[k]);
            }
        });
        const qs = params.toString();
        return qs ? `${base}?${qs}` : base;
    }

    function loadReport(useFilters) {
        const loader = dqs('#paLoader'); show(loader);

        const payload = useFilters ? {
            Date1: dqs('#Date1').value || '',
            Date2: dqs('#Date2').value || '',
            cPlayer: dqs('#cPlayer').value || '-1',
            txtIP: dqs('#txtIP').value || ''
        } : {};

        const url = buildUrlWithQuery(SERVICE_URL, payload);

        $.ajax({
            url: url,
            method: 'POST',
            data: payload,
            dataType: 'json'
        }).done(function (resp) {
            try {
                populatePlayerCombo(resp?.PlayerCombo || resp?.playerCombo || []);
                setFilterDefaults(resp);
                buildFromResponse(resp);
            } catch (e) {
                console.error(e); alert('Error parsing response.');
            }
        }).fail(function (xhr) {
            console.error(xhr); alert('Error loading data.');
        }).always(function () { hide(loader); });
    }

    function openIpModal(e) {
        const idx = parseInt(e.currentTarget.dataset.rowIndex, 10);
        const row = filteredRows[idx];
        const body = dqs('#ipModalBody');
        body.innerHTML = '';

        if (row && row.IPs && row.IPs.length) {
            row.IPs.forEach(ip => {
                const a = document.createElement('a');
                a.href = 'https://ipinfo.io/' + encodeURIComponent(ip) + '?lookup_source=search-bar';    
                a.target = '_blank';
                a.rel = 'noopener';
                a.textContent = ip;
                body.appendChild(a);
                body.appendChild(document.createElement('br'));
            });
        } else {
            body.textContent = 'No IPs';
        }

        const modal = new bootstrap.Modal(document.getElementById('ipModal'));
        modal.show();
    }

    document.addEventListener('DOMContentLoaded', function () {
        dqs('#pageSize').addEventListener('change', (e) => {
            rowsPerPage = parseInt(e.target.value, 10) || 25;
            currentPage = 1; renderTable(); renderPagination();
        });

        let t = null;
        dqs('#tableSearch').addEventListener('input', (e) => {
            const q = e.target.value;
            clearTimeout(t);
            t = setTimeout(() => applySearch(q), 200);
        });

        dqs('#btnSubmitPA').addEventListener('click', () => loadReport(true));
        dqs('#btnResetPA').addEventListener('click', () => {
            dqs('#Date1').value = '';
            dqs('#Date2').value = '';
            dqs('#cPlayer').value = '-1';
            dqs('#txtIP').value = '';
            dqs('#tableSearch').value = '';
            loadReport(true);
        });

        loadReport(false);
    });
</script>

</asp:Content>
