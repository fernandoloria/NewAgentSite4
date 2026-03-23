<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SideBarTickets.ascx.cs" Inherits="AgentSite4.Controls.SideBarTickets" %>

<script type="text/javascript">
    var rowNumber = 0;
    function isEven(n) { return n % 2 == 0; }

    // IDs reales generados por WebForms
    var minAmountInputId = '<%= txtMinAmount.ClientID %>';

    $(document).ready(function () {
        updateMiniBetTicker();
        window.setInterval(function () { updateMiniBetTicker(); }, 2000);
    });

    function amountToDotClass(amount) {
        if (amount >= 4000) return 't-dark';
        if (amount >= 3000) return 't-danger';
        if (amount >= 1500) return 't-warning';
        if (amount >= 500) return 't-primary';
        if (amount >= 250) return 't-success';
        if (amount >= 100) return 't-primary';
        if (amount >= 50) return 't-secondary';
        return 't-secondary';
    }

    function updateMiniBetTicker() {
        var url = "/Services/DashboardBetTicker.ashx?tick=" + $("#minitick").val() +"&placed=120"
            + "&minAmount=" + $("#" + minAmountInputId).val();

        var datas = {}, idWager = 0;

        ajaxConnexion(true, datas, url, function (data) {
            if (data && data.data && data.data.length > 0) {
                var newTickets = data.data.reverse();
                $('#ctl00_betTickerCounter').text(newTickets.length);

                for (var i = 0; i < newTickets.length; ++i) {
                    var item = newTickets[i];

                    var risk = parseFloat(item[5]) || 0;
                    var win = parseFloat(item[6]) || 0;
                    var sportLeg = item[13];

                    var sound = 'chime.mp3';
                    var bliqClass = '';
                    if (risk >= 50) { sound = 'newchime.mp3'; bliqClass = 'newitem1'; }
                    if (risk >= 100) { sound = 'newchime.mp3'; bliqClass = 'newitem1'; }
                    if (risk >= 250) { sound = 'newchime.mp3'; bliqClass = 'newitem1'; }
                    if (risk >= 500) { sound = 'newchime.mp3'; bliqClass = 'newitem1'; }
                    if (risk >= 1500) { sound = 'newchime.mp3'; bliqClass = 'newitem2'; }
                    if (risk >= 3000) { sound = 'newchime.mp3'; bliqClass = 'newitem3'; }
                    if (risk >= 4000) { sound = 'newchime.mp3'; bliqClass = 'newitem4'; }
                    if (risk >= 5000) { sound = 'submarinealert.mp3'; bliqClass = 'newitem5'; }
                    if (risk >= 10000) { sound = 'whistleblow.mp3'; bliqClass = 'newitem6'; }

                    if ($("#minitick").val() > 1) { playSound(sound); }

                    var dotClass = amountToDotClass(risk);

                    var row =
                        '<div class="item-timeline ' + bliqClass + '" style="' + (isEven(rowNumber) ? 'background-color:#f2f4f8' : 'background-color:#fff') + ';">' +
                        '<div class="t-dot"><div class="' + dotClass + '">' +
                        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-file">' +
                        '<path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path>' +
                        '<polyline points="13 2 13 9 20 9"></polyline>' +
                        '</svg>' +
                        '</div></div>' +
                        '<div class="t-content">' +
                        '<div class="t-uppercontent">' +
                        '<h5><strong>' + item[2] + '</strong> <span>#' + item[1] + '</span></h5>' +
                        '</div>' +
                        '<p>' + item[4] + ' · ' + risk.toFixed(0) + ' / ' + win.toFixed(0) + '</p>' +
                        '<div class="small">' + sportLeg + '</div>' +
                        '</div>' +
                        '</div>';

                    $('#miniticker').prepend(row);
                    rowNumber++;
                }

                $("#minitick").val(data.mark);

                var heatmap = 15000;

                $(".newitem1").removeClass("newitem1").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');
                $(".newitem2").removeClass("newitem2").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');
                $(".newitem3").removeClass("newitem3").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');
                $(".newitem4").removeClass("newitem4").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');
                $(".newitem5").removeClass("newitem5").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');
                $(".newitem6").removeClass("newitem6").hide().fadeIn(150).animate({ backgroundColor: '#fff' }, heatmap, 'swing');

                // Limita el tamaño del ticker para evitar crecimiento infinito
                var maxItems = 200;
                var $items = $('#miniticker').children('.item-timeline');
                if ($items.length > maxItems) {
                    $items.slice(maxItems).remove();
                }
            }
        });
    }

    function playSound(sound) {
        var tick = $("#minitick").val();
        if (tick > 0) {
            var audio = new Audio('/BetTicker/sounds/' + sound);
            audio.play();
        }
    }

    var html5_audiotypes = { "mp3": "audio/mpeg", "mp4": "audio/mp4", "ogg": "audio/ogg", "wav": "audio/wav", "aac": "audio/mpeg" };

    function createsoundbite() {
        var html5audio = document.createElement('audio');
        if (html5audio.canPlayType) {
            for (var i = 0; i < arguments.length; i++) {
                var sourceel = document.createElement('source');
                sourceel.setAttribute('src', "/BetTicker/sounds/" + arguments[i]);
                if (arguments[i].match(/\.(\w+)$/i))
                    sourceel.setAttribute('type', html5_audiotypes[RegExp.$1]);
                html5audio.appendChild(sourceel);
            }
            html5audio.load();
            html5audio.playclip = function () {
                html5audio.pause();
                html5audio.currentTime = 0;
                html5audio.play();
            };
            return html5audio;
        } else {
            return { playclip: function () { throw new Error("Your browser doesn't support HTML5 audio unfortunately"); } };
        }
    }

    function ajaxConnexion(ajaxStart, data, url, callback) {
        $.ajax({
            type: "GET",
            cache: false,
            url: url,
            data: data,
            dataType: "json",
            global: !!ajaxStart,
            timeout: 20000,
            success: function (result) {
                if (typeof callback === "function") callback(result);
            },
            error: function (xhr, status, err) {
                console.error("AJAX error:", status, err, "HTTP", xhr.status, xhr.statusText);
                console.error("Response:", (xhr.responseText || "").substring(0, 1000));
            }
        });
    }

    var chimesound = createsoundbite("chime.ogg", "chime.mp3", "chime.aac");
    var alertsound = createsoundbite("alert.ogg", "alert.mp3", "alert.aac");
    var newchimesound = createsoundbite("newchime.ogg", "newchime.mp3", "newchime.aac");
</script>

<div class="collapse" id="colors">
    <div class="row">
        <div class="col-4"><font size="2" style="background-color:#FFFFFF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$0 - $49</div>
        <div class="col-4"><font size="2" style="background-color:#FFF9CD">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$50 - $99</div>
        <div class="col-4"><font size="2" style="background-color:#D0E977">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$100 - $249</div>
        <div class="col-4"><font size="2" style="background-color:#DAC3F7">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$250 - $499</div>
        <div class="col-4"><font size="2" style="background-color:#97BCD2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$500 - $1499</div>
        <div class="col-4"><font size="2" style="background-color:#A0CB8A">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$1500 - $2999</div>
        <div class="col-4"><font size="2" style="background-color:#FCF579">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$3000 - $3999</div>
        <div class="col-4"><font size="2" style="background-color:#F1BB69">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$4000 - $4999</div>
        <div class="col-4"><font size="2" style="background-color:#E74C44">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$5000 - $9999</div>
        <div class="col-4"><font size="2" style="background-color:#764DF6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;$10000 +</div>
        <div class="col-4"><asp:TextBox ID="txtMinAmount" CssClass="form-control form-control-sm" runat="server" PlaceHolder="Min Amount"></asp:TextBox></div>
        <div class="col-4"><asp:Button ID="btnFilter" CssClass="btn btn-success" runat="server" OnClick="btnFilter_Click" Text="Set" /></div>
    </div>
</div>

<!-- Contenedor donde se inyectan los items con la clase del widget -->
<div id="miniticker" class="timeline-line"></div>
<input type="hidden" id="minitick" value="0" />


<style>
.table-betticker { font-size: 13px; border-collapse: collapse; width: 100% }
.table-betticker thead th { position: sticky; top: 0; background: #fff; z-index: 1 }
.table-betticker th, .table-betticker td { padding: 6px 8px; border-bottom: 1px solid #e5e7eb }
.table-betticker tr:nth-child(even) { background: #f8fafc }
.table-betticker .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace }
.table-betticker .num { text-align: right; white-space: nowrap }
.table-betticker .time { width: 70px; white-space: nowrap }
.table-betticker .sport-badge { font-size: 11px; padding: 2px 6px; border-radius: 9999px; background:#eef2ff; }
@media (max-width: 992px){
  .table-betticker .col-odds { display:none } /* oculta Odds en pantallas chicas */
}
</style>