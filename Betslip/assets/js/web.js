path = "../betslip/"

var win = null;
const STRAIGHT_WT = 0;
const TEASER_WT = 2;

function NewWindow(mypage, myname) {
    settings = "width=785,height=480,top=20,left=20,scrollbars=yes,location=no,status=no,menubar=no,toolbar=no,resizable=yes";
    win = window.open(mypage, myname, settings);
    win.focus();
}

function getactiveleagues(idp, idlt, idlan, pid, idbook) {
    const wagerType = $('#wt').val();
    $.post(path + "getActiveLeagues.asp", { pid: pid, idp: idp, idlt: idlt, idlan: idlan, bid: idbook, wt: wagerType },
        function (result) {
            $('#accordion').html(result);
            $('#currentLine').val("1,2,3,4,5");
            loadLinesByLeague();
        });
}

function getLinesBySport(pid, ids) {
    var idc = $('#idc').val();
    var cl = pid + "_" + "NBA_3"
    $('#currentLine').val(cl);
    $('#span-lines').html("<center><img src='" + path + "images/loading.gif' /></center>");
    $.post(path + "getLinesbySport.asp", { pid: pid, ids: ids, idc: idc },
        function(result) {
            $('#span-lines').html(result);
        });

}

function changeLineStyle() {

    var ls = $('#jm').val();
    $('#idls').val(ls);
    loadLinesByLeague();

}

function loadLinesByLeague() {
    $(".loading").css("display","block");

    leagues = $('#currentLine').val();

    var pid = $('#pid').val();
    var aid = $('#aid').val();
    var idp = $('#idp').val();
    var idpl = $('#idpl').val();
    var idc = $('#idc').val();
    var idlt = $('#idlt').val();
    var idls = $('#idls').val();
    var nhll = $('#nhll').val();
    var mlbl = $('#mlbl').val();
    var utc = $('#utc').val();
    var idlan = $('#idlan').val();
    var book = $('#idbook').val();
    const wt = $('#wt').val();

    $.get(path + "getLinesbyLeague.asp", {
            pid: pid,
            aid: aid,
            idp: idp,
            idpl: idpl,
            idc: idc,
            idlt: idlt,
            idls: idls,
            idl: leagues,
            nhll: nhll,
            mlbl: mlbl,
            utc: utc,
            idlan: idlan,
        bid: book,
        wt,
        wtid: 0
        },
        function(result) {
            $('#span-lines').html(result);

            sg = $('#games-sel').val();
            if (sg != "") {
                sg = sg.slice(0, -1);
                x = sg.split(",")
                for (i = 0; i < x.length; i++) {
					$('#' + x[i]).removeClass('btn-light').addClass('btn-warning');
			}

            }
            loadPanels();
        
            $(".loading").css("display","none");
        });

}

function loadSingleLeague(league) {

    if (league == "") {
        err_modal("No League is supplied.");
        return false
    }

    $('#span-lines').html("<center><img src='" + path + "images/loading.gif' /></center>");

    var pid = $('#pid').val();
    var aid = $('#aid').val();
    var idp = $('#idp').val();
    var idpl = $('#idpl').val();
    var idc = $('#idc').val();
    var idlt = $('#idlt').val();
    var idls = $('#idls').val();
    var nhll = $('#nhll').val();
    var mlbl = $('#mlbl').val();
    var utc = $('#utc').val();
    var idlan = $('#idlan').val();

    $.get(path + "getLinesbyLeague.asp", { pid: pid, aid: aid, idp: idp, idpl: idpl, idc: idc, idlt: idlt, idls: idls, idl: league, nhll: nhll, mlbl: mlbl, utc: utc, idlan: idlan },
        function(result) {
            $('#span-lines').html(result);

            sg = $('#games-sel').val();
            if (sg != "") {
                sg = sg.slice(0, -1);
                x = sg.split(",")
                for (i = 0; i < x.length; i++) {
                    //$('#'+x[i]).addClass('div-active');
                    $('#' + x[i]).removeClass('btn-light').addClass('btn-warning');
                }
            }
        });

}

function autoRefresh() {
    loadLinesByLeague();
}

function onlyNumbers(evt) {
    var e = event || evt; // for trans-browser compatibility
    var charCode = e.which || e.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function del(div_id, divid) {

    bet_counter = $('#counter').val();
    $("div[data-did='" + div_id + "']").hide(300);

    dbet = $("div[data-did='" + div_id + "']").data("betid");

    deletebet = dbet;
    current_bets = $('#betslip_hide').html();
    new_bets = current_bets.replace(deletebet, "");
    $('#betslip_hide').html(new_bets);
    //	$('#betslip_temp').html(new_temp);

    gamesSel = $('#games-sel').val();
    gamesSel = gamesSel.replace(divid + ",", "");
    $('#games-sel').val(gamesSel)
        //$('#'+divid).removeClass('div-active');	
    $('#' + divid).removeClass('btn-warning').addClass('btn-light');
    $('#counter').val(Number(bet_counter) - 1);
    $('.bs_cnt').html( 'Bets (' + (Number(bet_counter) - 1) +')');

}

function removePP(betid, wt) {

    var newGameBets = [];
    var newBets = [];
    var bet_counter = $('#counter').val();

    if (bet_counter == 2) {
        remove_all();
    } else {
        var gamesSel = $('#games-sel').val();
        sg = gamesSel.split(",");
        for (x = 0; x < sg.length - 1; x++) {
            temp = betid.split("_");
            toRemove = temp[1] + "_" + temp[0];
            temp = sg[x].split("_");
            toCompare = temp[0] + "_" + temp[1];
            if (toRemove != toCompare) {
                newGameBets.push(sg[x]);
            } else {
                $('#' + sg[x]).removeClass('btn-warning').addClass('btn-light');
            }
        }

        varBets = $('#betslip_hide').html()
        b = varBets.split(",");
        for (x = 0; x < b.length - 1; x++) {
            temp = betid.split("_");
            toRemove = temp[0] + "_" + temp[1];
            temp = b[x].split("_");
            toCompare = temp[0] + "_" + temp[1];
            if (toRemove != toCompare) {
                newBets.push(b[x]);
            }
        }

        $('#counter').val(newBets.length);
        $('.bs_cnt').html('Bets (' + newBets.length + ')');
        $('#betslip_hide').html(newBets.toString() + ",");
        $('#games-sel').val(newGameBets.toString() + ",");
        start_parlay(wt);

    }

}

function goback(start) {

    $('#betslip_show').html("<center><img src='" + path + "images/loading.gif' /></center>");
    $('#betslip_show').html($('#betslip_temp').html());
    if (start == "1") {
        document.getElementById("sporttypes").style.display = "block";
    }
}

function changeAmount(focusID) {

    $('#betslip_show').html("<center><img src='" + path + "images/loading.gif' /></center>");
    $('#betslip_show').html($('#betslip_temp').html());
    $('#' + focusID).focus();
}

function changePicks() {

    $('#betslip_show').html("<center><img src='" + path + "images/loading.gif' /></center>");
    $('#betslip_show').html($('#betslip_temp').html());
    $('#betslip_on').html("");
    document.getElementById("sporttypes").style.display = "block";
}

function rtrim(stringToTrim) {
    return stringToTrim.replace(/\s+$/, "");
}

function remove_all() {
//    $('#SportWagerTypes').show();
    $('#counter').val(0);
    $('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Straight Bet</h3></div></div>");
    $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'> <a class='btn btn-success pull-right btn-sm-slip btn-block' href='javascript:;' onclick='start_straight(null, true)'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>");
    $('#betslip_temp').html("");
    $('#betslip_hide').html("");
    $('#betslip_final').html("");
    $('#betslip_start').html("");
    $('#betslip_on').html("");
    $('#teaser_list').html("");
    $('#errBet').html("").hide();
    $('#clearBtn').hide();
    $('#BT-msg').show();
    $('#sporttypes').hide();
    $('.bs_cnt').html('Bets');
    document.getElementById("betslip_final").style.display = "none";

    sg = $('#games-sel').val();

    if (sg != "") {
        sg = sg.slice(0, -1);
        x = sg.split(",");
        for (i = 0; i < x.length; i++) {
            //$('#'+x[i]).removeClass('div-active');
            $('#' + x[i]).removeClass('btn-warning').addClass('btn-light');
        }
    }
    $('#betslip_modal').modal('hide');
    $('#games-sel').val('');
    $('.selectpicker').selectpicker('destroy');
    $('#shoppingCart').removeAttr('style');


}


function addbet_BACK(p, gameid, bt, team, sel, odds, idsport, idleague, nss) {

    if ($("#betslip_on").html() == "True") {
        err_modal("You have a bet in process!");
        return false;
    }

    if ($("#betslip_on").html() == "Done") {
        remove_all();
    }

    divid = gameid + "_" + p + "_" + bt;
    $('#betslip_final').html("");
    $('#BT-msg').hide();
    $('#clearBtn').show();
    $('#sporttypes').show();
    document.getElementById("betslip_final").style.display = "none";

    line = sel;

    if (bt == "Ov") {
        sel = "-" + sel;
    }
    if (bt == "S") {
        sel = sel.replace("PK", "0");
    }

    sel = sel.replace("Â½", ".5");

    if (sel == "+.5") {
        sel = "0.5";
    }
    if (sel == "-.5") {
        sel = "-0.5";
    }

    //	sel = sel.replace("PK","0")
    odds = odds.replace("EV", "100");
    id = "d_" + p + "_" + gameid;
    bet_id = p + "_" + gameid + "_" + sel + "_" + odds + ",";
    bet_counter = $('#counter').val();
    tempDiv = $("div[data-did='" + id + "']");

    if (tempDiv.length > 0) {

        if ($('#' + divid).hasClass('btn-warning')) {
            $('#lk_' + divid).click();
        } else {
            tempDiv.show(300);
            sg = $('#games-sel').val();
            bshide = $('#betslip_hide').html();
            //$('#'+divid).addClass('div-active');
            $('#' + divid).removeClass('btn-light').addClass('btn-warning');
            $('#games-sel').val(sg + divid + ",");
            $('#counter').val(Number(bet_counter) + 1);
            $('.bs_cnt').html( 'Bets (' + (Number(bet_counter) + 1) +')');
            $('#betslip_hide').html(bshide + bet_id);
        }

        return false;
    }

    bet = "<div class='row pick_container' data-betid='" + bet_id + "' data-did='" + id + "'><div class='col-lg-12'>";
    bet = bet + "<span class='pull-left'><strong>" + nss + " " + team + "</strong></span> ";
    //	sel = sel.replace("0","PK")

    line = line.replace(".5", "Â½");
    if (odds > 0) odds = "+" + odds;

    if (bt == "S") {
        bet = bet + "<span class='pull-right'><strong>" + line + " " + odds + "</strong> <a href='javascript:;' id='lk_" + divid + "' onclick=del('" + id + "','" + divid + "')><i class='fa fa-times removeBet'></i></a></span>";

    } else if (bt == "ML") {
        bet = bet + "<span class='pull-right'><strong>" + bt + " " + odds + "</strong> <a href='javascript:;' id='lk_" + divid + "' onclick=del('" + id + "','" + divid + "')><i class='fa fa-times removeBet'></i></a></span>";
    } else {
        bet = bet + "<span class='pull-right'><strong>" + bt + " " + line + " " + odds + "</strong> <a href='javascript:;' id='lk_" + divid + "' onclick=del('" + id + "','" + divid + "')><i class='fa fa-times removeBet'></i></a></span>";
    }

    bet = bet + "<input type='hidden' name='t_" + id + "' id='t_" + id + "' value='" + team + "'>";
    bet = bet + "</div></div>";

    sg = $('#games-sel').val();
    //	$('#'+divid).addClass('div-active');
    $('#' + divid).removeClass('btn-light').addClass('btn-warning');
    $('#games-sel').val(sg + divid + ",");
    document.getElementById('betslip_show').innerHTML = document.getElementById('betslip_show').innerHTML + bet;
    document.getElementById('betslip_temp').innerHTML = document.getElementById('betslip_temp').innerHTML + bet;
    document.getElementById('betslip_hide').innerHTML = document.getElementById('betslip_hide').innerHTML + bet_id;
    $('#counter').val(Number(bet_counter) + 1);
    $('.bs_cnt').html( 'Bets (' + (Number(bet_counter) + 1) +')');

}

function addbet(p, gameid, bt, team, sel, odds, idsport, idleague, nss) {
    if ($('#betslip_on')['html']() == 'True') {
        err_modal('You have a bet in process!');
        return false
    };
    if ($('#betslip_on')['html']() == 'Done') {
        remove_all()
    };
    divid = gameid + '_' + p + '_' + bt;
    $('#betslip_final')['html']('');
    $('#BT-msg')['hide']();
    $('#clearBtn')['show']();
    $('#sporttypes')['show']();
    document['getElementById']('betslip_final')['style']['display'] = 'none';
    line = sel;
    if (bt == 'Ov') {
        sel = '-' + sel
    };
    if (bt == 'S') {
        sel = sel['replace']('PK', '0')
    };
    sel = sel['replace']('\xBD', '.5');
    if (sel == '+.5') {
        sel = '0.5'
    };
    if (sel == '-.5') {
        sel = '-0.5'
    };
    odds = odds['replace']('EV', '100');
    id = 'd_' + p + '_' + gameid;
    bet_id = p + '_' + gameid + '_' + sel + '_' + odds + ',';
    bet_counter = $('#counter')['val']();
    tempDiv = $('div[data-did=\'' + id + '\']');
    if (tempDiv['length'] > 0) {
        if ($('#' + divid)['hasClass']('btn-warning')) {
            $('#lk_' + divid)['click']()
        } else {
            tempDiv['show'](300);
            sg = $('#games-sel')['val']();
            bshide = $('#betslip_hide')['html']();
            $('#' + divid)['removeClass']('btn-light')['addClass']('btn-warning');
            $('#games-sel')['val'](sg + divid + ',');
            $('#counter')['val'](Number(bet_counter) + 1);
            $('.bs_cnt').html( 'Bets (' + (Number(bet_counter) + 1) +')');
            $('#betslip_hide')['html'](bshide + bet_id)
        };
        return false
    };
	//if($('#SportWagerTypes').is(":visible")){
	//	$('#errBet').html('Please select the wager type.').show().fadeOut(4500);
	//}
	
    bet = '<div class=\'row pick_container\' data-betid=\'' + bet_id + '\' data-did=\'' + id + '\'><div class=\'col-lg-12\'>';
    bet = bet + '<span class=\'pull-left\'><strong>' + nss + ' ' + team + '</strong></span> ';
    line = line['replace']('.5', '\xBD');
    if (odds > 0) {
        odds = '+' + odds
    };
    if (bt == 'S') {
        bet = bet + '<span class=\'pull-right\'><strong>' + line + ' ' + odds + '</strong> <a href=\'javascript:;\' id=\'lk_' + divid + '\' onclick=del(\'' + id + '\',\'' + divid + '\')><i class=\'fa fa-times removeBet\'></i></a></span>'
    } else {
        if (bt == 'ML') {
            bet = bet + '<span class=\'pull-right\'><strong>' + bt + ' ' + odds + '</strong> <a href=\'javascript:;\' id=\'lk_' + divid + '\' onclick=del(\'' + id + '\',\'' + divid + '\')><i class=\'fa fa-times removeBet\'></i></a></span>'
        } else {
            bet = bet + '<span class=\'pull-right\'><strong>' + bt + ' ' + line + ' ' + odds + '</strong> <a href=\'javascript:;\' id=\'lk_' + divid + '\' onclick=del(\'' + id + '\',\'' + divid + '\')><i class=\'fa fa-times removeBet\'></i></a></span>'
        }
    };
    bet = bet + '<input type=\'hidden\' name=\'t_' + id + '\' id=\'t_' + id + '\' value=\'' + team + '\'>';
    bet = bet + '</div></div>';
    sg = $('#games-sel')['val']();
    $('#' + divid)['removeClass']('btn-light')['addClass']('btn-warning');
    $('#games-sel')['val'](sg + divid + ',');
    document['getElementById']('betslip_show')['innerHTML'] = document['getElementById']('betslip_show')['innerHTML'] + bet;
    document['getElementById']('betslip_temp')['innerHTML'] = document['getElementById']('betslip_temp')['innerHTML'] + bet;
    document['getElementById']('betslip_hide')['innerHTML'] = document['getElementById']('betslip_hide')['innerHTML'] + bet_id;
    $('#counter')['val'](Number(bet_counter) + 1);
    $('.bs_cnt').html('Bets (' + (Number(bet_counter) + 1) + ')');
    $('#shoppingCart').css('background-color', 'var(--green-2)');
}

function dobet() {
    pwd = $('#cnfpwd')['val']();
    // pwd = pwd['toUpperCase']();
    idlt = $('#idlt')['val']();
    if (pwd === '') {
        $('#p_pwd')['html']('Please provide your Password.');
        $('#p_pwd')['removeClass']('hide');
        $('#grppwd')['addClass']('has-error');
        $('#cnfpwd')['focus']();
        return false
    };
    p = CryptoJS.MD5(pwd).toString();
    hash = $('#hash')['val']();
    hash = hash['toUpperCase']();
    if (hash != p['toUpperCase']()) {
        $('#p_pwd')['html']('Password does not match.');
        $('#p_pwd')['removeClass']('hide');
        $('#grppwd')['addClass']('has-error');
        $('#cnfpwd')['focus']();
        return false
    };

    $('#betslip_show')['html']('<center><img src=\'' + path + 'images/loading.gif\' /></center>');
    $['get'](path + 'doBet.asp', {
        p: pwd,
        idlt: idlt
    }, function(_0xb2aexb) {
        $('#betslip_show')['html'](_0xb2aexb);
        $('#pwd_button')['focus']()
    })
}

function dobetafterchanges(bets, p, wt, idwt) {

    pid = $('#pid').val();
    idc = $('#idc').val();
    idlt = $("#idlt").val();

    $('#betslip_show').html("<center><img src='" + path + "images/loading.gif' /></center>");
    $.get(path + "getAcceptChanges.asp", { pid: pid, idc: idc, bets: bets, p: p, wt: wt, idwt: idwt, idlt: idlt },
        function(result) {
            $('#betslip_show').html(result);
            $("#pwd_button").focus();
        });

}

function startNewBet() {
    remove_all();
    resetSteps();
}

function start_teaser() {
    $(".loading").css("display", "block");
		remove_all();
    $('[data-text="left-header"]').text('Teaser Types');
		$('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Teaser Bet</h3></div></div>");
    // if ($("#betslip_on").html() == "True"){
    //     varBets = $('#games-sel').val();
    //     remove_all();
    // 	openspots = "";
    // 	$('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Teaser Bet</h3></div></div>");
    //     $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'><a class='btn btn-success pull-right btn-sm' href='javascript:;' onClick='start_teaser()'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>")
    //     document.getElementById("sporttypes").style.display = 'none';
    // 	b = varBets.split(",");
    //     for (x = 0; x < b.length - 1; x++) {
    //         var anchorId = b[x];
    // 		$("#" + anchorId).click();     
    //     }
    // 	return false;
    // }

    bet_counter = $('#counter').val();
    bets = $('#betslip_hide').html();
    idp = $('#idp').val();
    const pid = $('#pid').val();
    $('#wt').val(TEASER_WT);

    if ($("#openspots").length) {
        openspots = $("#openspots").val();
        if (openspots == "") {
            $("#grpstr").addClass("has-error");
            $("#openspots").focus();
            return false;
        }
        if (Number(bet_counter) == 1 && Number(openspots) == 0) {
            $('#errBet').html("You need at least two picks for a Teaser Bet").show().fadeOut(1500);
            return false;
        }
    } else {
        openspots = "";
    }

    tempBets = bets.split(",")
    for (x = 0; x < tempBets.length - 1; x++) {
        info = tempBets[x].split("_")
        if (info[0] == 4 || info[0] == 5) {
            $('#errBet').html("You can not do a Teaser with Money Lines").show().fadeOut(1500);
            return false;
        }

    }

    // if (Number(bet_counter) == 0) {
    //     $('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Teaser Bet</h3></div></div>");
    //     $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'><a class='btn btn-success pull-right btn-sm' href='javascript:;' onClick='start_teaser()'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>")
    //     document.getElementById("sporttypes").style.display = 'none';
    //     return false;
    // }

    // if (Number(bet_counter) < 1) {
    //     err_modal("You need at least one pick to start a Teaser Bet.");
    //     return false;
    // }

    pick_counter = Number(bet_counter) + Number(openspots);

    //if (pick_counter > 6){
    //	$('#errBet').html("For a Teaser Bet you can only select up to 6 teams as maximum.").show().fadeOut(1500);
    //	return false;
    //}

    if (Number(bet_counter) > 1) {
        document.getElementById("sporttypes").style.display = 'none';
    } else {
        document.getElementById("sporttypes").style.display = 'none';
    }

    $('#betslip_show_temp').html("");
    $('#teaser_list').html("<center><img src='" + path + "images/loading.gif' /></center>");

    $.get(path + `getteaserlist.asp?pid=${pid}`,
        function (result) {
            if (openspots == "") {
                $('#betslip_show h3').text('');
                temp = $('#betslip_show').html();
                $('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Teaser Bet</h3></div></div>");
            }
            $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'> <a class='btn btn-success pull-right btn-sm-slip btn-block' href='javascript:;' onClick='prepareTeaser()'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>");
            const anchors = $.parseHTML(result);
            var w = window.innerWidth;
            $('#sportSide').html('');
            $(anchors).each(function (i) {
                const li = $('<li></li>');
                li.append($(this));
                $('#sportSide').append(li);
            });
            if (w >= 991) {
                $('#sportSide a').eq(0).click();
            } else {
                $('[data-step="Step-2"]').removeClass('show');
                $('[data-step="Step-2"]').addClass('hide');
                $('[data-step="Step-1"]').removeClass('hide');
                $('[data-step="Step-1"]').addClass('show');
            }
            $('#teaser_list').html("");
            $(".loading").css("display", "none");
        });

}

function prepareTeaser() {
    const idp = $("#idp").val();
    const bc = $("#counter").val();
    const os = $("#openspots").val() ?? 0;
    const idwt = $("#idwt").val();
    const teaserSize = $('#ts').val();
    const teaserReady = bc === teaserSize;
    const maxOpenSpots = $('#maxOpenSpots').val();
    if (teaserReady) {
        do_teaser(idwt, os);
    } else {
        $.get(path + `prepareTeaser.asp?idp=${idp}&bc=${bc}&os=${os || ""}&idwt=${idwt}&ts=${teaserSize}&maxOpenSpots=${maxOpenSpots}`,
        function(result) {
            if (openspots == "") {
                temp = $('#betslip_show').html();
                $('#betslip_show').html("<div class='BT-header'> <i class='fa fa-caret-square-o-right'></i> Teaser </div>" + temp);
            }
            $('#teaser_list').html(result);
            $('#ts').selectpicker({ style: 'input-sm', container: 'body' });
            }
        );
    }
    $('#betslip_show_temp').html('');
}

function loadLinesByTeaser(wt, wtid, teaserSize, maxOpenSpots) {
    $(".loading").css("display", "block");
    $('.btn-leagues').removeClass('option-active');
    $(`#option-${wtid}`).addClass('option-active');
    $('#idwt').val(wtid);
    $('#ts').val(teaserSize);
    $('#maxOpenSpots').val(maxOpenSpots);
    const leagues = "1%2c46%2c2%2c54%2c18%2c3%2c4551"; // 69-NFL GAME LINES, 157-NBA SUMMER LEAGUE, 66-NBA GAME LINES
    if (wt > 0 && wtid > 0) {
        var pid = $('#pid').val();
        var aid = $('#aid').val();
        var idp = $('#idp').val();
        var idpl = $('#idpl').val();
        var idc = $('#idc').val();
        var idlt = $('#idlt').val();
        var idls = $('#idls').val();
        var nhll = $('#nhll').val();
        var mlbl = $('#mlbl').val();
        var utc = $('#utc').val();
        var idlan = $('#idlan').val();
        var book = $('#idbook').val();

        $.get(path + "getLinesbyLeague.asp", {
            pid: pid, aid: aid, idp: idp, idpl: idpl, idc: idc, idlt: idlt, idls: idls,
            idl: leagues, nhll: nhll, mlbl: mlbl, utc: utc, idlan: idlan, bid: book, wt: wt, wtid: wtid
        },
            function (result) {
                $('#span-lines').html(result);
                $('#currentWTID').val(wtid);
                var w = window.innerWidth;
                if (w < 991) {
                    $('#collapseLeagues').collapse("hide");
                    betSliptControl($('.betSlipt-control[data-wager-type="CONTINUE"]')[0]);
                }
                $(".loading").css("display", "none");
            }
        );
    } else {
        alert("Missing Params!")
    }
}

function refresh_teaser(selObj) {

    if ($("#openspots").length) {
        openspots = $("#openspots").val();
        if (openspots == "") {
            err_modal("You need to enter a number.");
            return false;
        }
    } else {
        openspots = 0;
    }

    teaserSelection = selObj.options[selObj.selectedIndex].value;
    $('#ts').selectpicker('destroy');
    $("#teaser_list").html('');
    do_teaser(teaserSelection, openspots);

}

function do_teaser(idwt, openspots) {
    const openSpots = openspots ?? $('#openspots').val();
    if (idwt == "") {
        err_modal("Missing Information");
        return false;
    }

    bet_counter = $('#counter').val();
    bets = $('#betslip_hide').html();

    if (bets.search("_ML_") != -1) {
        err_modal("You can not do a Teaser with Money Lines");
        return false;
    }

    pick_counter = Number(bet_counter) + Number(openSpots);

    if (Number(pick_counter) < 2) {
        err_modal("For a Teaser Bet you have to select 2 teams as minimum");
        return false;
    }

    //if (pick_counter > 6){
    //	err_modal("For a Teaser Bet you can only select up to 6 teams as maximum");
    //	return true;
    //}

    $("#betslip_show").html("<center><img src='" + path + "images/loading.gif' /></center>");

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();
    idlt = $('#idlt').val();

    $.get(path + "getteaser.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 0, idwt: idwt, idlt: idlt, os: openSpots },
        function(result) {
            $('#betslip_show').html(result);
            $('.selectpicker').selectpicker({ style: 'input-sm', container: 'body' });
            $('#t_risk').focus();
        });

}

function place_teaser(idwt, openspots) {

    if (idwt == "") {
        err_modal("Missing Information");
        return false;
    }

    bets = ""
    bet_counter = $("#counter").val();
    betid = $("#bet_id").val();
    bp = $("#TeaserBuyPoints").val();
    x = betid.split("|")

    for (i = 0; i < x.length - 1; i++) {

        amt = document.getElementById('t_risk');

        if (amt.value != "") {
            bets = bets + x[i] + "_" + amt.value + "_" + bp + ",";
        }

    }

    if (bets == "") {
        $("#grpamt").addClass("has-error");
        $("#t_risk").focus();
        return false
    }

    if (Number(bet_counter) == 0) {
        err_modal("You need at least one pick for Teaser Bet.");
        return false;
    }

    if ($('#freeplay').is(':checked'))
        freeplay = 1
    else
        freeplay = 0

    $("#betslip_temp").html($("#betslip_show").html());
    $("#betslip_show").html("<center><img src='" + path + "images/loading.gif' /></center>");;

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();

    $.get(path + "getteaser.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 1, idwt: idwt, os: openspots, fp: freeplay },
        function(result) {
            $('#betslip_show').html(result);
            $('#clearBtn').hide();
            $('#cnfpwd').focus();
        });

}

function clicker(url) {
    var thediv = document.getElementById('displaybox');
    if (thediv.style.display == "none") {
        thediv.style.display = "";
        thediv.innerHTML = "<br><br><div><iframe src=" + url + " width='800' height='600' frameborder='0' scrolling='auto'></iframe><a href='#' onclick='return clicker();'></div><div><img src='images/close.png'></a></div>";
    } else {
        thediv.style.display = "none";
        thediv.innerHTML = '';
    }
    return false;
}

function fetchSportsOfferings() {
    const wt = $('#wt').val();
    $.get("Leagues.aspx", { WT: wt, auth: 'mPEV5DMcUXb4FzGG' },
        function (result) {
            //			alert(result)
            var menu = $(result).find("#sportNav").html();
            const w = window.innerWidth;
            $("#sportSide").html(menu);
            //			alert(menu);
            if (w < 991) {
                $('[data-step="Step-2"]').removeClass('show');
                $('[data-step="Step-2"]').addClass('hide');
                $('[data-step="Step-1"]').removeClass('hide');
                $('[data-step="Step-1"]').addClass('show');
            }
            $('.nav > li > a').click(function () {
                if ($(this).attr('class') != 'active') {
                    //$('.nav li ul').slideUp();
                    $(this).next().slideToggle();
                    //$('.nav li a').removeClass('active');
                    $(this).addClass('active');
                } else {
                    $('.nav li ul').slideUp();
                    //$(this).next().slideToggle();
                    $('.nav li a').removeClass('active');
                }
            });
        });
}

function start_straight(element, preventFetchSports) {
//    $('#SportWagerTypes').hide();


    //if ($("#betslip_on").html() == "True") {
    //    err_modal("You have a bet in process!");
    //    return false;
    //}

    bet_counter = $('#counter').val();
    bets = $('#betslip_hide').html();
    $('[data-text="left-header"]').text('Sports Offerings');
    $('#wt').val(STRAIGHT_WT);
    if (!preventFetchSports) {
        fetchSportsOfferings();
    }
    loadLinesByLeague();
    if (Number(bet_counter) == 0) {
        $('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>Straight Bet</h3></div></div>");
        $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'> <a class='btn btn-success pull-right btn-sm-slip btn-block' href='javascript:;' onClick='start_straight(null, true)'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>");
        document.getElementById("sporttypes").style.display = 'none';
        return false;
    }

    document.getElementById("sporttypes").style.display = 'none';
    $("#betslip_show").html("<center><i class='refresh-spinner fa fa-spinner fa-spin fa-5x'></i></center>");
    $("#betslip_on").html("True");
    $('#betslip_show_temp').html("");

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();

    $.get(path + "getstraight.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 0 },
        function(result) {
            $('#clearBtn').hide();
            $('#betslip_show').html(result);
            $('.selectpicker').selectpicker({ style: 'input-sm', container: 'body' });
           // $('#betall').focus();
        });

}

function place_straight() {

    bets = "";
    bpsel_value = 0;
    bet_counter = $('#counter').val();
    betid = $("#bet_id").val();
    x = betid.split("|")

    for (i = 0; i < x.length - 1; i++) {

        temp = "win_" + x[i]
        y = temp.split("_");

        o = y[y.length - 1];
        if (o > 0) {
            temp = "risk_" + x[i]
        }

        amt = document.getElementById(temp);

        bpsel = "bp_" + x[i];
        if (document.getElementById(bpsel) != null) {
            bpsel_value = document.getElementById(bpsel).value;
        } else {
            bpsel_value = 0;
        }

        if (amt.value != "") {
            bets = bets + x[i] + "_" + amt.value + "_" + bpsel_value + ",";
        }
        else {
			err_modal("Wagers win/risk amount is required");
			return false;
		}

    }

    if (Number(bet_counter) == 0) {
        err_modal("You need at least one pick for straight bets.");
        return false;
    }

    if (bets == "") {
        $("#grpamt").addClass("has-error");
        $("#betall").focus();
        return false
    }

    if ($('#freeplay').is(':checked'))
        freeplay = 1
    else
        freeplay = 0

    $("#betslip_temp").html($("#betslip_show").html());
    $("#betslip_show").html("<center><i class='refresh-spinner fa fa-spinner fa-spin fa-5x'></i></center>");

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();

    $.get(path + "getstraight.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 1, fp: freeplay },
        function(result) {
            $('#betslip_show').html(result);
            $('#cnfpwd').focus();
        });
}

function start_parlay(wt) {
//    $('#SportWagerTypes').hide();
    $('[data-text="left-header"]').text('Sports Offerings');
    $('#wt').val(wt);
    loadLinesByLeague();
    fetchSportsOfferings();
    
    getOpenSpot = 0;

    if (wt == "") {
        err_modal("Missing Information.");
        return false;
    }

    if ($("#openspots").length) {
        getOpenSpot = 1;
        openspots = $("#openspots").val();
        if (openspots == "") {
            $("#grpopen").addClass("has-error");
            $("#openspots").focus();
            return false;
        }
    } else {
        openspots = 0;
    }

    bet_counter = $('#counter').val();
    bets = $('#betslip_hide').html();
    pick = bets.split(",");

    for (x = 0; x < pick.length - 1; x++) {
        bt = pick[x].split("_");
        templine = bt[2].toString();

        if (templine.slice(-3) == ".25" || templine.slice(-3) == ".75") {
            alert("You can't Parlay Handicap Lines")
            return false;
        }
    }

    if (Number(bet_counter) == 0) {
        txt = "";
        switch (Number(wt)) {
            case 1:
                txt = "Parlay";
                break;
            case 3:
                txt = "If Win Only";
                break;
            case 4:
                txt = "Win Reverse";
                break;
            case 5:
                txt = "Round Robin";
                break;
            case 7:
                txt = "If Win or Tie";
                break;
            case 8:
                txt = "Action Reverse";
                break;
        }

        $('#betslip_show').html("<div class='row row_betslip row-margin'><div class='col-lg-12'><h3>" + txt + " Bet</h3></div></div>");
        $('#betslip_show_temp').html("<div class='row row-margin row-margin-top'><div class='col-lg-12'> <a class='btn btn-success pull-right btn-sm-slip btn-block' href='javascript:;' onClick='start_parlay(" + wt + ")'>  Continue <i class='fa fa-angle-right'> </i> </a></div></div>")
        document.getElementById("sporttypes").style.display = 'none';
        return false;
    }

    if (Number(bet_counter) < 1) {
        err_modal("You need at least one pick to start a Bet.");
        return false;
    }

    if (Number(wt) == 5 && Number(bet_counter) < 3) {
        //$('#errBet').html("You need at least three picks to start a Round Robin.").show().fadeOut(1500);
		err_modal("You need at least three picks to start a Round Robin.");
        return false;
    }

    if (Number(wt) > 1 && Number(bet_counter) <= 1) {
        err_modal("You need at least two picks to start this kind of Bet.");
        return false;
    }

    if (Number(bet_counter) == 1) {

        if (Number(getOpenSpot) == 1 && Number(openspots) == 0) {
           // $('#errBet').html("You need at least one Open Spot to Continue.").show().fadeOut(1500);
			err_modal("You need at least one Open Spot to Continue.");
            return false;
        }
        if (Number(getOpenSpot) == 0) {
            openspots = Number(openspots) - 1;
        }

    }

    if (Number(bet_counter) > 0) {
        document.getElementById("sporttypes").style.display = 'none';
    }

    if (Number(openspots) >= 0) {

        $("#betslip_start").html($("#betslip_show").html());
        $("#betslip_show").html("<center><img src='" + path + "images/loading.gif' /></center>");
        $("#betslip_on").html("True");

    }

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();
    idlt = $('#idlt').val();

    $.get(path + "getparlay.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 0, wt: wt, idlt: idlt, os: openspots },
        function(result) {
            if (Number(openspots) == -1) {
                $("#betslip_show").html($("#betslip_show").html() + result);
                $('.removeBet').hide();
                $('#clearBtn').hide();
            } else {
                $('#clearBtn').hide();
                $("#betslip_show").html(result);
                $('.selectpicker').selectpicker({ style: 'input-sm', container: 'body' });
                $("#p_risk").focus();
            }
            $('#betslip_show_temp').html("");
        });

}

function place_parlay(wt, readOS) {

    if (wt == "") {
        alert("Missing Information.");
        return false;
    }

    bets = ""
    bet_counter = $('#counter').val();
    betid = $("#bet_id").val();
    openspot = $("#openspots").val();

    if (wt == 5) {
        combo = $('#combo').val();
    } else {
        combo = ""
    }

    if ($("#openspots").length) {
        openspots = $("#openspots").val();
        if (openspots == "") {
            $("#grpopen").addClass("has-error");
            $("#openspots").focus();
            return false;
        }
        if (openspots > 0 && readOS) {
            addParlayOS(wt, openspots);
            return false;
        }
    } else {
        openspots = 0;
    }

    if ($('#freeplay').is(':checked'))
        freeplay = 1
    else
        freeplay = 0

    x = betid.split("|")

    for (i = 0; i < x.length - 1; i++) {

        amt = $('#p_risk');

        bp = x[i].split("_")

        bpsel = "bp_" + bp[0] + "_" + bp[1];
        if (document.getElementById(bpsel) != null) {
            bpsel_value = document.getElementById(bpsel).value;
        } else {
            bpsel_value = 0;
        }

        if (amt.val() != "") {
            bets = bets + x[i] + "_" + amt.val() + "_" + bpsel_value + ",";
        }

        if (bets == "") {
            $("#grpamt").addClass("has-error");
            $("#p_risk").focus();
            return false
        }

        if (Number(bet_counter) == 0) {
            err_modal("You need at least one pick for parlay bets.");
            return false;
        }
    }

    $("#betslip_temp").html($("#betslip_show").html());
    $("#betslip_show").html("<center><img src='" + path + "images/loading.gif' /></center>");

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();
    idlt = $('#idlt').val();

    $.get(path + "getparlay.asp", { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 1, wt: wt, cb: combo, idlt: idlt, os: openspot, fp: freeplay },
        function(result) {
            $("#betslip_show").html(result);
            $("#cnfpwd").focus();
        });
}

function addParlayOS(wt, openspots) {

    if (wt == "" || openspots < 0) {
        err_modal("Missing Information.");
        return false;
    }

    bet_counter = $('#counter').val();
    bets = $('#betslip_hide').html();

    if (Number(bet_counter) < 1) {
        err_modal("You need at least one pick to start a Bet.");
        return false;
    }

    if (Number(wt) == 5 && Number(bet_counter) < 3) {
        $('#errBet').html("You need at least three picks to start a Round Robin.").show().fadeOut(1500);
        return false;
    }

    if (Number(wt) > 1 && Number(bet_counter) <= 1) {
        err_modal("You need at least two picks to start this kind of Bet.");
        return false;
    }

    pid = $('#pid').val();
    idp = $('#idp').val();
    idc = $('#idc').val();
    idlt = $('#idlt').val();

    $.ajax({
        url: path + "getparlay.asp",
        type: 'GET',
        data: { pid: pid, idp: idp, idc: idc, b: bets, c: bet_counter, amt: 0, wt: wt, idlt: idlt, os: openspots },
        dataType: "html",
        success: function(data) {
            result = $(data).filter('div.alert').length;
            if (result == 0) {
                place_parlay(wt, false);
            } else {
                alert($(data).filter('div.alert').html())
            }

        }
    });

}

function goStart() {
//    $('#SportWagerTypes').show();
    $('#betslip_on').html("");
    $("#betslip_show").html($("#betslip_start").html());
    document.getElementById("betslip_final").style.display = "none";
    document.getElementById("sporttypes").style.display = "block";
    $("#teaser_list").html('');
}

function r_amt(a, o, id) {
    odds = o;

    if (odds != "") {
        if (Number(odds) < 0) {
            odds = Math.abs(odds);
            var y = document.getElementById(a).value;
            winAmt = (Number(y) * 100) / Number(odds)
            document.getElementById(id).value = Math.floor(winAmt);
        } else {
            var y = document.getElementById(a).value;
            winAmt = (Number(y) * Number(odds)) / 100;
            document.getElementById(id).value = Math.floor(winAmt);
        }
        updateRiskWin();
    }

}

function w_amt(a, o, id) {
    odds = o;

    if (odds != "") {
        if (Number(odds) > 0) {
            odds = Math.abs(odds);
            var y = document.getElementById(a).value;
            winAmt = (Number(y) * 100) / Number(odds)
            document.getElementById(id).value = Math.round(winAmt);
            //document.getElementById(id).value = Math.round(Number(y)/Number(odds))*-1;
        } else {
            var y = document.getElementById(a).value;
            winAmt = (Number(y) * Number(odds)) / 100;
            document.getElementById(id).value = Math.round(winAmt * -1);
            //document.getElementById(id).value = Math.round(Number(y)*Number(odds))*-1;
        }
        updateRiskWin();
    }
}

function updateRiskWin() {

    var risktotal = 0;
    var wintotal = 0;

    $(".risk").each(function() {
        risk = $(this).val();
        if (risk >= 0) {
            risktotal = risktotal + Number(risk);
        }

    });

    $(".win").each(function() {
        win = $(this).val();
        if (win >= 0) {
            wintotal = wintotal + Number(win);
        }
    });

    $("#risk-total").html(risktotal);
    $("#win-total").html(wintotal);

}

function betall_apply(e) {
    $('#bet_all_apply')['click']()
   // $("#betall").blur();
  //  $('#btn-success').focus();
}

function p_amt(e, a, odds) {

    if (e.keyCode == 13) {
        $("#place_parlay_button").click();
    } else {

        if (odds != "") {
            var y = document.getElementById(a).value;
            document.getElementById("p_win").value = Math.round(Number(y) * Number(odds));
        }

    }

}

function p_cnt(e) {

    if (e.keyCode == 13) {
        $("#place_parlay_button").click();
    }

}

function t_amt(e) {

    if (e.keyCode == 13) {
        $("#placeTeaserButton").click();
    }
}

function submit_bet(e) {
    if (e.keyCode == 13) {
        dobet();
    }
}

/*
function err_modal(txt) {
    $("#myModalLabel").html("Error");
    $("#modal_txt").html(txt);
    $('#myModal').modal('show');
}
*/
function err_modal(message) {
    var toastId = 'toast_' + new Date().getTime();
    var toastHtml = '<div id="' + toastId + '" class="toast">' + message + '</div>';
    
    $('#toast-container').append(toastHtml);

    var toast = $('#' + toastId);
    setTimeout(function() {
        toast.addClass('show');
    }, 100); 
    
    setTimeout(function() {
        toast.removeClass('show');
        setTimeout(function() {
            toast.remove(); 
        }, 500); 
    }, 5000); 
	 $('#errBet').html(message).show().fadeOut(7000);
}

function closeLines(ev) {
    var search = $('#currentLine').val().indexOf("S:");
    var today = $('#currentLine').val().indexOf("today");

    if (search >= 0 || today >= 0) {
        var idDiv = '#lg-' + $(ev).data('lg');
        $(idDiv).fadeOut("slow");
    }
    else {
        lid = $(ev).data('lg');
        if ($('#span-lines').length == 0) {
            window.location = "TicketWriter.aspx?lid=" + lid;
        } else {
            var leagues = [];

            $(".activeLeague").each(function () {
                if ($(this).data("lg") == $(ev).data('lg')) {
                    $(this).removeClass("activeLeague");
                }
                else {
                    leagues.push($(this).data("lg"));
                }
            });
            if (leagues == "") {
                $('#span-lines').html('No Leagues Selected');
                return false;
            }
            $('#span-lines').html('Loading...');
            $('#currentLine').val(leagues);
            loadLinesByLeague();
        }
    }
}

function showLines(ev) {
    lid = $(ev).data('lg');
    if ($('#span-lines').length == 0) {
        window.location = "TicketWriter.aspx?lid=" + lid;
    } else {
        if ($(ev).hasClass("activeLeague")) {
            $(ev).removeClass("activeLeague");
        } else {
            $(ev).addClass("activeLeague");
        }
        // console.log($(ev).data('lg'));
        //	return false;
        var leagues = [];

        $(".activeLeague").each(function () {
            leagues.push($(this).data("lg"));
        });
        if (leagues == "") {
            $('#span-lines').html('No Leagues Selected');
            return false;
        }
        $('#span-lines').html('Loading...');
        $('#currentLine').val(leagues);
        loadLinesByLeague();
    }
}

function autoTrigger(id) {
    event.stopPropagation();

    if ($(`#check-${id}`).prop("checked")) {
        $(`#check-${id}`).prop("checked", false);
    } else {
        $(`#check-${id}`).prop("checked", true);
    }

    $(`[data-lg="${id}"]`).trigger('click');
}

function searchTeams() {
    if ($('#SearchText').length == 0) {
        window.location = "TicketWriter.aspx?lid=" + $('#SearchText').val();
    } else {
        $('#span-lines').html('Loading...');
        $('#currentLine').val('S:' + $('#SearchText').val());
        loadLinesByLeague();
    }
}

function XXL() {
    console.log('text');
}


function apply_riskAmt() {

    var risktotal = 0;
    var wintotal = 0;
    var bet = $("#betall").val();

    if (bet == "") {
        $("#grpamt").addClass("has-error");
        // $("#betall").focus();
        return false;
    }

    $(".risk").each(function() {
        inputrisk = this.id;
        inputrisk = inputrisk.replace(".", "\\.")
        inputwin = inputrisk.replace("risk_", "win_")
        x = inputrisk.split("_");
        odds = x[4];
        //		alert(inputrisk+" "+x[4]+" "+inputwin);
        amt = Math.floor((odds * bet) / 100);

        if (odds > 0) {
            $('#' + inputrisk).val(bet)
            $('#' + inputwin).val(amt)
            risktotal = Number(risktotal) + Number(bet);
        } else {
            $('#' + inputrisk).val(amt * -1)
            $('#' + inputwin).val(bet)
            risktotal = Number(risktotal) + Number(amt * -1);
        }

    });

    $(".win").each(function() {
        w = $(this).val();
        wintotal = Number(w) + wintotal;
    });

    $("#risk-total").html(risktotal);
    $("#win-total").html(wintotal);
    $('#place_straight_button').focus();

}

function fillleague(sportID) {

    if ($("#" + sportID + "_checkAll").is(':checked')) {
        $("#" + sportID + " input[type=checkbox]").each(function() {
            $(this).prop("checked", true);
        });

    } else {
        $("#" + sportID + " input[type=checkbox]").each(function() {
            $(this).prop("checked", false);
        });
    }
}

function fillall() {

    if ($("#check-all").is(':checked')) {
        $("input[type=checkbox]").each(function() {
            $(this).prop("checked", true);
        });

    } else {
        $("input[type=checkbox]").each(function() {
            $(this).prop("checked", false);
        });
    }
}


function getLeaguesbySport(sportID) {

    var leagues = [];
    //	alert(sportID)

    sport = sportID.split(",")

    for (x = 0; x < sport.length; x++) {

        $("#" + sport[x] + " input[type=checkbox]").each(function() {
            leagues.push(this.value);
            //		alert(this.value);
            //		alert($(this).val());
        });

        if (leagues != "")
            break;

    }
    //	alert(leagues)
    $('#span-lines').html('Loading...');
    $('#currentLine').val(leagues);

    loadLinesByLeague();
}

function getCredit(pid) {
    if (Number(pid) > 0) {
        $.post("/cs/getCredit.asp", { pid: pid },
            function(result) {
                $("#ctl00_WagerLnk_lbldCreditLimit").html(result);
            });
    }
}

function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function getFamily(gameID, playerID, gametypeID) {

    if (gameID > 0 && playerID > 0 && gametypeID > 0) {
        currentID = "";

        switch (gametypeID) {
            case 19:
                currentID = '#' + gameID + '_hf';
                break;
            case 27:
                currentID = '#' + gameID + '_qt';
                break;
            default:
                currentID = "";
        }

        current = $(currentID).html();
        if (current == "") {
            $(currentID).html("Loading...");
            $.post(path + "getFamilyGame.asp", { pid: playerID, gid: gameID, gtid: gametypeID },
                function(result) {
                    $(currentID).html(result);
                });
        }
    }
}

function refreshBalance() {
   /* $.ajax({
        url: "player.aspx",
        type: 'GET',
        success: function(data) {
            playerInfo = $(data).find('#playerInfo').html();
            $('#playerInfo').html(playerInfo);
            $('#betslip_on').html("Done")
            $('#teaser_list').html("")
            sg = $('#games-sel').val();

            if (sg != "") {
                sg = sg.slice(0, -1);
                x = sg.split(",")
                for (i = 0; i < x.length; i++) {
                    //$('#'+x[i]).removeClass('div-active');
                    $('#' + x[i]).removeClass('btn-warning').addClass('btn-light');
                }
            }
            $('#games-sel').val('');
            $('#clearBtn').hide();
            $('.bs_cnt').html('Bets');
            $('#shoppingCart').removeAttr('style');

        }
    });
	*/
}




function openBS() {
	
	var wt = Number($('#wt').val());  
    var counter = Number($('#counter').val());  
    var ts = Number($('#ts').val());  
    var maxOpenSpots = Number($('#maxOpenSpots').val());  

    if (wt == 2) {
        if (counter != ts && (counter + maxOpenSpots) != ts) {
            err_modal("You have to select at least " + ts + " details for this Teaser.");
            return false;
        }
    }
	
    if (wt == 2) {
        if (counter < ts && (counter + maxOpenSpots) < ts) {
            err_modal("You have to select at least " + ts + " details for this Teaser.");
            return false;
        }

        if (counter > ts) {
            err_modal("You have selected too many picks.");
        
        }
    }
	
	
	
    tempBS = $('#bs_mdl').html();
    if (tempBS.trim() == "") {
        tempBS = $('#bs_left_cont').html();
        $('#bs_left_cont').html('');
        $('#bs_mdl').html(tempBS);
    }
    $('#betslip_modal').modal('show');
	$('.main-content').addClass('body-blur')
}

function closeBS() {
    tempBS = $('#bs_mdl').html();
    $('#bs_left_cont').html(tempBS);
    $('#bs_mdl').html('');
	$('.main-content').removeClass('body-blur')
}

function loadPanels() {
    $(".panel-tools .minimise-tool").click(function(event) {
        $(this).parents(".panel").find(".panel-body").slideToggle(100);
    });

    $(".panel-tools .closed-tool").click(function(event) {
        $(this).parents(".panel").fadeToggle(400);
    });

    return false;
}


function expand(element) {
    if ($(element).find('i').hasClass('fa-arrows-alt')) {
        $(element).find('i').addClass('fa-compress').removeClass('fa-arrows-alt');
        $(element).find('span').text("Reduce");
        $("#span-lines").addClass("expand-lines");
        $(".betTicket-content").addClass("hidden");
        $(".stFooter").addClass("show");
    } else {
        $(element).find('i').addClass('fa-arrows-alt').removeClass('fa-compress');
        $(element).find('span').text("Expand");
        $("#span-lines").removeClass("expand-lines");
        $(".betTicket-content").removeClass("hidden");
        $(".stFooter").removeClass("show");
    }
}

function wagerTypeButtons(element) {
    $('div[data-wager-type]').removeClass("active");
    $(element).addClass("active");
}

function betSliptControl(element) {
    const btn = element.getAttribute("data-action");
    
    if(!element.classList.contains("disabled")) {
        if(btn == "continue-view-lines") {
            $(element).hide();
            $('[data-action="back-view-lines"]').show();
            $('.sidebar-panel.nav').addClass("hide");
            $('.sidebar-panel.nav').removeClass("show");
            $('.dynamicWagerContent').addClass("show");
            $('.dynamicWagerContent').removeClass("hide");
        } else {
            $(element).hide();
            $('[data-action="continue-view-lines"]').show();
            $('.sidebar-panel.nav').addClass("show");
            $('.sidebar-panel.nav').removeClass("hide");
            $('.dynamicWagerContent').addClass("hide");
            $('.dynamicWagerContent').removeClass("show");
        }
    }
}

function init() {     
    this.loadLinesByLeague();
    this.remove_all();
    this.start_straight($('div[data-wager-type="Straight"]')[0]);
    
    $(".wagerTypeBtn").on("click", function(e) {
        wagerTypeButtons(e.currentTarget);
    });
    
    window.addEventListener('resize', function(event){
        if (window.innerWidth > 992) {
            $('.dynamicWagerContent').removeClass("hide");
            $('.dynamicWagerContent').removeClass("show");
            $('.sidebar-panel.nav').removeClass("hide");
            $('[data-action="back-view-lines"]').addClass("disabled");
            $('[data-action="continue-view-lines"]').removeClass("disabled");
        }
    });
};

$(document).ready(function () {
    const pathObjects = (location.pathname || '').split('/');
    const currentPage = (pathObjects[pathObjects.length - 1]).replace('.aspx', '');
    // Option 1
    const { search } = location;
    $(`.menu-boxes .box[data-url='${location.pathname}${search || ''}']`).addClass('active');
    const textAmount = ($('#top-balance span').text() || '').trim().replace(',', '');
    const balance = Number(textAmount);
    if (balance >= 0) {
        $('#top-balance').css('color', '#16c816');
    } else {
        $('#top-balance').css('color', '#ee5151');
    }
    // $('.custom-responsive-table tbody tr td').each(function(index){
    //     const windowWidth = $(window).width();
    //     if(windowWidth < 768) {
    //         const header = $('.custom-responsive-table thead th').eq(index).text();
    //         const currentText = $(this).text();
    //         if(header) {
    //             $(this).prepend(`<span class="mobile-header">${header}:</span>`);
    //         }
    //     }
    // });
    $('.custom-responsive-table tbody tr').each(function () {
        $(this).find('td').each(function (index) {
            const header = $(this).closest('table').find('thead th').eq(index).text();
            const currentText = $(this).text();
            if (header) {
                $(this).prepend(`<span class="mobile-header">${header}:</span>`);
            }
        });
    });
    // Option 1

    // Option 2
    // $('.menu-boxes .box').each(function(){
    //     if($(this).attr('data-url').includes(currentPage)) {
    //         $(this).addClass('active');
    //     }
    // });
    // Option 2
});

function updateBetAndLine(play, gameid) {
    var hidden = document.getElementById('bet_id');
    var pointsEl = document.getElementById('points_' + play + '_' + gameid);
    var oddsEl = document.getElementById('odds_' + play + '_' + gameid);
    var lineEl = document.getElementById('line_' + play + '_' + gameid);

    var points = pointsEl ? pointsEl.value : '0';
    var odds = oddsEl ? oddsEl.value : '';

    if (lineEl) lineEl.textContent = (pointsEl ? points : '') + odds;

    if (!hidden) return;

    var segs = hidden.value ? hidden.value.split('|').filter(Boolean) : [];
    var oldSeg = null, idx = -1;
    for (var i = 0; i < segs.length; i++) {
        var p = segs[i].split('_');
        if (p[0] === String(play) && p[1] === String(gameid)) { oldSeg = segs[i]; idx = i; break; }
    }

    var newSeg = play + '_' + gameid + '_' + (pointsEl ? points : '0') + '_' + odds;

    if (idx >= 0) segs[idx] = newSeg; else segs.push(newSeg);
    hidden.value = segs.join('|') + '|';

    var riskOldId = 'risk_' + (oldSeg || newSeg);
    var winOldId = 'win_' + (oldSeg || newSeg);

    var riskEl = document.getElementById(riskOldId);
    var winEl = document.getElementById(winOldId);

    var riskNewId = 'risk_' + newSeg;
    var winNewId = 'win_' + newSeg;

    if (riskEl) {
        riskEl.id = riskNewId;
        riskEl.name = riskNewId;
        riskEl.setAttribute('onKeyUp',
            "r_amt(this.id, document.getElementById('odds_" + play + "_" + gameid + "').value, '" + winNewId + "')");
    }
    if (winEl) {
        winEl.id = winNewId;
        winEl.name = winNewId;
        winEl.setAttribute('onKeyUp',
            "w_amt(this.id, document.getElementById('odds_" + play + "_" + gameid + "').value, '" + riskNewId + "')");
    }

    var bpOldId = 'bp_' + (oldSeg || newSeg);
    var bpEl = document.getElementById(bpOldId);
    if (bpEl) { bpEl.id = 'bp_' + newSeg; bpEl.name = 'bp_' + newSeg; }
}

