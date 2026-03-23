var dtCh = "/";
var minYear = 1900;
var maxYear = 2100;

$(function () {
    if (localStorage.getItem('reloadPreviousPage') === 'true') {
        localStorage.removeItem('reloadPreviousPage');
        location.reload();
    }

});
function isInteger(s) {
    var i;
    for (i = 0; i < s.length; i++) {
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}
function stripCharsInBag(s, bag) {
    var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++) {
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}
function daysInFebruary(year) {
    // February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ((!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28);
}
function DaysArray(n) {
    for (var i = 1; i <= n; i++) {
        this[i] = 31
        if (i == 4 || i == 6 || i == 9 || i == 11) { this[i] = 30 }
        if (i == 2) { this[i] = 29 }
    }
    return this
}
function isDate(dtStr) {
    var daysInMonth = DaysArray(12);
    var pos1 = dtStr.indexOf(dtCh);
    var pos2 = dtStr.indexOf(dtCh, pos1 + 1);
    var strMonth = dtStr.substring(0, pos1);
    var strDay = dtStr.substring(pos1 + 1, pos2);
    var strYear = dtStr.substring(pos2 + 1);

    strYr = strYear;
    if (strDay.charAt(0) == '0' && strDay.length > 1) strDay = strDay.substring(1)
    if (strMonth.charAt(0) == '0' && strMonth.length > 1) strMonth = strMonth.substring(1)
    for (var i = 1; i <= 3; i++) {
        if (strYr.charAt(0) == '0' && strYr.length > 1) strYr = strYr.substring(1)
    }
    month = parseInt(strMonth);
    day = parseInt(strDay);
    year = parseInt(strYr);

    if (pos1 == -1 || pos2 == -1) {
        alert('The date format should be : mm/dd/yyyy');
        return false;
    }
    if (strMonth.length < 1 || month < 1 || month > 12) {
        alert('Please enter a valid month');
        return false;
    }
    if (strDay.length < 1 || day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month]) {
        alert('Please enter a valid day');
        return false;
    }
    if (strYear.length != 4 || year == 0 || year < minYear || year > maxYear) {
        alert('Please enter a valid 4 digit year between ' + minYear + ' and ' + maxYear);
        return false;
    }
    if (dtStr.indexOf(dtCh, pos2 + 1) != -1 || isInteger(stripCharsInBag(dtStr, dtCh)) == false) {
        alert('Please enter a valid date');
        return false;
    }
    return true;
}
function ValidateForm() {
    var dt = document.frmSample.txtDate
    if (isDate(dt.value) == false) {
        dt.focus()
        return false
    }
    return true
}
function toggle_tab(objeto) {
    var m = objeto;
    if (m.nextSibling.nodeName == "DD") { //IE
        var afectar = m.nextSibling
    } else if (m.nextSibling.nextSibling.nodeName == "DD") { //FF
        var afectar = m.nextSibling.nextSibling;
    }
    if (typeof tab_activo == "undefined") { var tab_activo = "none" }

    if (afectar.style.display == "block") {
        afectar.style.display = "none";
    } else {
        afectar.style.display = "block";
    }
}
function swap(img) {
    str = new String(img.src); img.src = str.replace("Out", "Over");
}
function swap2(img) {
    str = new String(img.src); img.src = str.replace("Over", "Out");
}
function ChangeLT(lt) {
    document.forms[0].action = 'MoveLine.aspx?LT=' + lt;
    document.forms[0].submit();
}
function PageReload() {
    window.location.reload();
}
function FindStr() {
    if (document.forms[0].txtFind.value != '')
        findString(document.forms[0].txtFind.value)
    return false;
}
function findString(str) {
    if (parseInt(navigator.appVersion) < 4) return;
    var strFound;
    var TRange = null

    if (navigator.appName == "Netscape") {

        // NAVIGATOR-SPECIFIC CODE

        strFound = window.find(str, 0, 1);
        if (!strFound) {
            strFound = window.find(str, 0, 1)
            while (window.find(str, 0, 1)) continue
        }
    }
    else if (navigator.appName.indexOf("Microsoft") != -1) {

        // EXPLORER-SPECIFIC CODE

        if (TRange != null) {
            TRange.collapse(false)
            strFound = TRange.findText(str)
            if (strFound) TRange.select()
        }
        if (TRange == null || strFound == 0) {
            TRange = self.document.body.createTextRange()
            strFound = TRange.findText(str)
            if (strFound) TRange.select()
        }
    }
    else if (navigator.appName == "Opera") {
        alert("Opera browsers not supported, sorry...")
        return;
    }
    if (!strFound) alert("String '" + str + "' not found!")
    return;

}
function ClosePage() {
    window.close();
}
function LTExplorer() {
    var Data = document.getElementById('ctl00_CRLLineType_CmbLineType');
    ChangeLT(Data.value);
}
function Suma(A, B) {
    return (parseInt(A) + parseInt(B));
}
function Resta(A, B) {
    return (parseInt(A) - parseInt(B));
}
function FormatString(str) {
    var s = String(parseInt(str));
    if (s.length > 3) {
        s = s.substring(0, s.length - 3) + ',' + s.substring(s.length, s.length - 3)
    }
    return s;
}
function respConfirm() {
    var Type = document.forms[0].sTransac.value;
    var OldBal = document.forms[0].hBalance.value;
    var Amount = document.forms[0].txtAmount.value;
    var NewBal = Suma(OldBal, Amount);
    var NewRest = Resta(OldBal, Amount);
    var Resp = "";

    if (Type == 'R' || Type == 'D') {
        if (0 > parseInt(Amount)) {
            alert('Amount value cant be less that 0.');
            document.forms[0].txtAmount.focus();
            return false;
        }
        else {
            if (Type == 'R')
                Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewBal));
            else if (Type == 'D')
                Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewRest));
        }
    }
    else if (Type == 'P') {
        var FreeAmount = document.forms[0].hFreePlay.value;

        if (FreeAmount == null)
            FreeAmount = 0;

        Resp = confirm('Free Play Amount: ' + FormatString(FreeAmount) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Free Play Amount: ' + FormatString(Suma(FreeAmount, Amount)));
    }
    else {
        if (Type == 'C' && 0 > parseInt(Amount)) {
            Amount = parseInt(Amount) * -1;
            Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(Resta(OldBal, Amount)));
        }
        else
            Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewBal));
    }

    if (Resp) {/*
            document.forms[0].action = 'PlayerPayment.aspx?Step=2';
          document.forms[0].submit();*/
        $('.preloader').show();
        $.post('PlayerPayment.aspx?Step=2', $(document.forms[0]).serialize()).done(function () {
            // $.notify("Changes saved!", "success");
            if (window.opener != null) {
                window.opener.location.reload();
                window.close();
            }
            //localStorage.setItem('reloadPreviousPage', 'true');
            var sourceParam = (new URL(document.location)).searchParams.get("source");

            if (sourceParam === null) {
                window.location.href = "/Report/Welcome.aspx";
            } else if (sourceParam === "wb") {
                window.location.href = "/Report/WeeklyBalancesEnhanced.aspx";
            } else if (sourceParam === "pm") {
                window.location.href = "/Report/PlayerManagement.aspx";
            } else {
                window.history.go(1);
            }
        });
    }
    else
        return false;
}
function respConfirmPopUp() {
    $('#PopUpModal').modal('hide');
    var Type = $('#sTransac').val();
    var OldBal = $('#hBalance').val();
    var Amount = $('#txtAmount').val();
    var NewBal = Suma(OldBal, Amount);
    var NewRest = Resta(OldBal, Amount);
    var Resp = "";

    if (Type == 'R' || Type == 'D') {
        if (0 > parseInt(Amount)) {
            alert('Amount value cant be less that 0.');
            $('#txtAmount').focus();
            return false;
        }
        else {
            if (Type == 'R')
                Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewBal));
            else if (Type == 'D')
                Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewRest));
        }
    }
    else if (Type == 'P') {
        var FreeAmount = $('#hFreePlay').val(); 

        if (FreeAmount == null)
            FreeAmount = 0;

        Resp = confirm('Free Play Amount: ' + FormatString(FreeAmount) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Free Play Amount: ' + FormatString(Suma(FreeAmount, Amount)));
    }
    else {
        if (Type == 'C' && 0 > parseInt(Amount)) {
            Amount = parseInt(Amount) * -1;
            Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(Resta(OldBal, Amount)));
        }
        else
            Resp = confirm('Current Balance: ' + FormatString(OldBal) + '\n Transaction Amount: ' + FormatString(Amount) + '\n New Balance: ' + FormatString(NewBal));
    } 
    if (Resp) {

        var postData = {
            hPlayer: $('#hPlayer').val(),
            txtAmount: $('#txtAmount').val(),
            txtFee: $('input[name="txtFee"]').val(),
            txtBonus: $('input[name="txtBonus"]').val(),
            txtDescription: $('#txtDescription').val(),
            txtReference: $('textarea[name="txtReference"]').val(),
            sMethod: $('select[name="sMethod"]').val(),
            sTransac: $('#sTransac').val(),
            Date1: new Date().toISOString(), // Assuming you want the current date-time
            chBOW: $('input[name="chBOW"]').is(':checked') ? 'on' : 'off'
        };
        $('.preloader').show();
        $.post('/Popup/PlayerPaymentPopUp.aspx?Step=2', postData).done(function (response) {
            $('#playerPaymentModal .modal-body').html(response);

            // Option 2: Display a success message and close the modal after a few seconds
            $('#playerPaymentModal .modal-body').html('<div class="alert alert-success">Changes saved!</div>');
            setTimeout(function () {
                $('#playerPaymentModal').modal('hide');
                var sourceParam = (new URL(document.location)).searchParams.get("source");
                if (sourceParam === null) {
                    location.reload();
                } else if (sourceParam === "wb") {
                    window.location.href = "/Report/WeeklyBalancesEnhanced.aspx";
                } else if (sourceParam === "pm") {
                    window.location.href = "/Report/PlayerManagement.aspx";
                } else {
                    location.reload();
                }
            }, 2000);
        });
    } else {
        return false;
    }
}
function MarkInfoUpdate() {
    document.forms[0].action = 'PlayerMarketingInfo.aspx?Step=2';
    document.forms[0].submit();
}
function ChangeHD(TabId) {
    var txtValue = document.getElementById(TabId);
    var HDValue = document.getElementById('TabChanged');
    if (txtValue.value != "") {
        if (HDValue.value != "") {
            HDValue.value = HDValue.value + ',' + txtValue.checked + '_' + TabId;
        }
        else {
            HDValue.value = txtValue.checked + '_' + TabId;
        }
    }
}
function ShowCode(e, TabID, Origen, Agent, Field) {
    var KeyID = (document.all) ? e.keyCode : e.keyCode;
    var txtValue = document.getElementById(TabID);
    var NewValue = "";
    var Negative = true;
    var Changed = false;

    if (txtValue.value != "") {
        NewValue = txtValue.value;
    }
    else if (Agent != "") {
        NewValue = Agent;
    }
    else {
        NewValue = Origen;
    }
    NewValue = NewValue.replace("½", ".5");
    NewValue = NewValue.replace("o", "");
    NewValue = NewValue.replace("u", "");
    if (parseFloat(NewValue) > 0) {
        Negative = false;
    }
    else {
        NewValue = parseFloat(NewValue) * -1;
    }
    if (Field == "Odds") {
        if (KeyID == 38) {
            NewValue = parseFloat(NewValue) + 1;
            Changed = true;
        }
        else if (KeyID == 40) {
            NewValue = parseFloat(NewValue) - 1;
            Changed = true;
        }
    }
    else {
        if (KeyID == 38) {
            NewValue = parseFloat(NewValue) + 0.5;
            Changed = true;
        }
        else if (KeyID == 40) {
            NewValue = parseFloat(NewValue) - 0.5;
            Changed = true;
        }
    }
    if (Changed) {
        if (Negative) {
            txtValue.value = parseFloat(NewValue) * -1;
        }
        else {
            txtValue.value = NewValue;
        }
    }
}
function BlockDiv(id) {
    var obj = document.getElementsByTagName('div'), o, i = 0;
    while (o = obj[i++]) {
        if (o.className == 'Action' || o.className == 'Master' || o.className == 'Sum' || o.className == 'Change') {
            o.style.display = 'none';
        }
        if (o.className == id) {
            o.style.display = 'block';
        }
    }
}
function BlockMoney(id) {
    var obj2 = document.getElementsByTagName('div'), o2, j = 0;
    while (o2 = obj2[j++]) {

        if (o2.className == 'Risk' || o2.className == 'Win') {
            o2.style.display = 'none';
        }
        if (o2.className == id) {
            o2.style.display = 'block';
        }
    }
}
function ResetLine(Send) {
    document.forms[0].action = 'AgentLineMover.aspx?RS=' + Send;
    document.forms[0].submit();
}
function CreateMsg() {
    var txtValue = document.getElementById('txtMsg');
    var ch01 = document.getElementById('ch_Expiration');
    var ch02 = document.getElementById('ch_DisplayCounter');
    var ch03 = document.getElementById('ch_DisableMsg');
    var rbValue = '';
    var HDValue = document.getElementById('HDPlayers');

    if (txtValue.value == '') {
        alert('Message is necesary to continue.');
        txtValue.focus();
        return false;
    }

    for (var i = 0; i < document.forms[0].MsgType.length; i++) {
        if (document.forms[0].MsgType[i].checked) {
            rbValue = document.forms[0].MsgType[i].value;
        }
    }

    if (rbValue == 'Normal') {
        if ((!ch01.checked) && (!ch02.checked) && (!ch03.checked)) {
            alert('Mgs Type Normal dont has a checkbox assign.');
            return false;
        }
    }

    if (ch01.checked) {
        var txt = document.getElementById('Date1');
        if (txt.value == '') {
            alert('Expiration Date is necesary.');
            return false;
        }
    }

    if (ch02.checked) {
        var Count = document.getElementById('txtCounter');
        if (Count.value == '') {
            alert('Counter value is necesary.');
            Count.focus();
            return false;
        }
        if (!isInteger(Count.value)) {
            alert('Counter value is not valid.');
            Count.focus();
            return false;
        }
    }

    document.forms[0].action = 'PlayerMessage.aspx?Step=2';
    document.forms[0].submit();
}
function ResetEventLine(Send) {
    document.forms[0].action = 'EventSchedule.aspx?RS=' + Send;
    document.forms[0].submit();
}
function ValidateInfo() {
    var txtAmount = document.getElementById('txtAmount');
    var NegXFER = document.getElementById('hNegativeXFER');
    var CBal = document.getElementById('hCurrentBalance');

    if (txtAmount.value == '') {
        alert('Amount is requerid.');
        txtAmount.focus();
        return false;
    }
    else if (!isInteger(txtAmount.value)) {
        alert('Amount value is not valid.');
        txtAmount.focus();
        return false;
    }
    else if ((NegXFER.value == "False") && (CBal.value < 0)) {
        alert('Cant Send Transfers with Negative Current Balance.');
        txtAmount.focus();
        return false;
    }

    document.forms[0].action = 'AgentPayment.aspx?Step=2';
    document.forms[0].submit();
}
function PrintData() {
    var printContent = window.parent.frames['mainFrame'].document.getElementById('printAction');

    var windowUrl = 'about:blank';
    var uniqueName = new Date();
    var windowName = 'Print' + uniqueName.getTime();

    var printWindow = window.open(windowUrl, windowName, 'left=50000,top=50000,width=800,height=600');
    printWindow.document.body.innerHTML = printContent.innerHTML;
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
    printWindow.close();
    //return false;
}
function togglePasswordVisibility(elementId) {
    var passwordField = document.getElementById(elementId);
    var eyeIcon = document.getElementById('eyeIcon_' + elementId);

    if (passwordField.type === "password") {
        passwordField.type = "text";
        eyeIcon.classList.remove('fa-eye');
        eyeIcon.classList.add('fa-eye-slash');
    } else {
        passwordField.type = "password";
        eyeIcon.classList.remove('fa-eye-slash');
        eyeIcon.classList.add('fa-eye');
    }
}
function markRowAsModified(inputElement) {
    var $row = $(inputElement).closest('tr');
    var $hiddenField = $row.find('[id*="hfRowModified"]');
    $hiddenField.val('modified');
}


function GetDetail(Send) {
    $.get('/Popup/ChartStraightValue.aspx?Data=' + Send, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetScore(Send) {
    $.get('/Popup/ViewScore.aspx?Id=' + Send, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPositionDetail(Send) {
    $.get('/Popup/AgentPositionDetail.aspx?GAME=' + Send, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetExposureDetail(Send) {
    var Currency = document.getElementById('cCurrency');
    $.get('/Popup/AgentExposureDetail.aspx?Data=' + Send + '_' + Currency.value, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPlayerPayment(idPlayer) {
    var Currency = document.getElementById('cCurrency');
    $.get('/Popup/PlayerPaymentPopUp.aspx?player=' + idPlayer, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}

function GetOpenBets(idPlayer) {
    $.get('/Popup/OpenBetsPop.aspx?IdPlayer=' + idPlayer, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}

function GetPlayerHistory(Id, Date, Day) {
    var Currency = document.getElementById('cCurrency');
    var sCurrency = "0";

    if (Currency != null) {
        sCurrency = Currency.value;
    }

    Id = Id + "";
    Date = Date + "";
    Day = Day + "";
    $.get('/Popup/WeeklyBalanceDayHistory.aspx?Data=' + Id + '_' + Date + '_' + Day + '_' + sCurrency, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPlayerWeekHistoryV2(Id, Date, Day) {
    var Currency = document.getElementById('cCurrency');
    var sCurrency = "0";

    if (Currency != null) {
        sCurrency = Currency.value;
    }

    Id = Id + "";
    Date = Date + "";
    Day = Day + "";
    $.get('/Popup/WeeklyBalanceWeekHistoryV2.aspx?Data=' + Id + '_' + Date + '_' + Day + '_' + sCurrency, function (data) {
        var content = $(data);
        var divContent = content.find('.UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPlayerWeekHistoryPayment(Id, Date, Day) {
    var Currency = document.getElementById('cCurrency');
    var sCurrency = "0";
    if (Currency != null) {
        sCurrency = Currency.value;
    }
    Id = Id + "";
    Date = Date + "";
    Day = Day + "";
    $.get('/Popup/WeeklyBalanceWeekHistoryPayments.aspx?Data=' + Id + '_' + Date + '_' + Day + '_' + sCurrency, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPlayerWeekHistory(Id, Date) {
    Id = Id + "";
    Date = Date + "";
    $.get('/Popup/WeeklyBalanceWeekHistory.aspx?id=' + Id + '&date=' + Date + '', function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetGameActionDetail(Send) {
    $.get('/Popup/ChartGameActionDetail.aspx?GAME=' + Send, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetGameEventDetail(Send) {
    $.get('/Popup/EventSchedule.aspx?INIT=' + Send, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function OpenTransfer() {
    $.get('/Popup/AgentPayment.aspx', function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function GetPlayerProfitHistory(Id, dateFrom, dateTo) {
    $.get('/Popup/PlayerWeeklyProfitHistory.aspx?id=' + Id + '&datefrom=' + dateFrom + '&dateto=' + dateTo, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function CancelWagerPopup(Id, IdSport) {
    Id = Id + "";
    $.get('/Popup/CancelWagerPopUp.aspx?tn=' + Id + '&idsport=' + IdSport + '', function (data) {
        var content = $(data);
        var divContent = content.find('.UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}
function OpenPlayerStats(IdPlayer) {
    $.get('/Popup/PlayerStats.aspx?player=' + IdPlayer, function (data) {
        var content = $(data);
        var divContent = content.find('#UpdatePanelReport').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}

function GetBeatTheLineAnalis(player, df, dt) {
    var url = '../Report/BeatTheLine.aspx?player=' + player + '&df=' + df + '&dt=' + dt;
    $.get(url, function (data) {
        var content = $(data);
        var divContent = content.find('#ctl00_MainContent_PnGrids').html();
        $('#PopUpModal .modal-body').html(divContent);
        $('#PopUpModal').modal('show');
    });
}

function OpenEditPlayer(IdPlayer) {
    window.location.href = '/Report/PlayerEditEnhanced.aspx?player=' + IdPlayer;
}
function OpenPlayerPayment(idPlayer) {
    window.location.href = '/Report/PlayerPayment.aspx?player=' + idPlayer;
}
function OpenPlayerMessage(idPlayer) {
    window.location.href = '/Report/PlayerMessage.aspx?player=' + idPlayer;
}