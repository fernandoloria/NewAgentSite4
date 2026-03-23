$(document).ready(function () {
    updateBetTickerHistory();

	var timeRefresh = $("#ctl00_MainContent_ddlPlaced").val();
	timeRefresh = timeRefresh * 3000;
	if(timeRefresh > 30000 && timeRefresh <= 360000)
	{
		timeRefresh = 30000;
	}	
	if(timeRefresh > 60000)
	{
		timeRefresh = 60000;
	}
    window.setInterval(function () {
        updateBetTicker();
    }, 15000);

});
function updateBetTicker() {
	var url = "BetTicker.ashx?tick=" + $("#tick").val() + "&placed=" + $("#ctl00_MainContent_ddlPlaced").val();
    $.getJSON(url, function (data) {
		if(data.data != undefined)
		{
			if (data.data.length > 0) {
				var newTickets = data.data.reverse();
				
					for (var i = 0 ; i < newTickets.length ; ++i) {
						var item = newTickets[i];
						var backColor = '#FFFFFF';
						var sound = 'chime.mp3'
						if (item[5] >= 500) {
							backColor = '#8ebdd5';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 1500) {
							backColor = '#93ce82';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 3000) {
							backColor = '#fcf661';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 4000) {
							backColor = '#faba58';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 5000) {
							backColor = '#fa3a3a';
							sound = 'submarinealert.mp3'
						}
						if (item[5] >= 10000) {
							backColor = '#8042ff';
							sound = 'whistleblow.mp3'
						}
						//if(sound != undefined)
						if($("#tick").val() > 1)
				{
						playSound(sound);
				}
						var row = '<tr style="background-color: ' + backColor + ';"><td>' + item[1] + '</td><td>' + item[4] + '</td><td>' + item[2] + '</td><td>' + item[7] + '</td><td>' + item[10] + '</td><td>' + item[9] + '</td><td>' + item[11] + '</td><td>' + item[12] + '</td><td>' + parseFloat(item[5]) + ' / ' + parseFloat(item[6]) + '</td></tr>';

						$('#ticker > tbody').prepend(row);
					
					}
				$("#tick").val(data.mark);
			}
		}
    });
}

function updateBetTickerHistory() {
	var refresh = $("#ctl00_MainContent_ddlPlaced").val();
	if(refresh <= 1439)
	{
		updateBetTicker();
		
	}
	else
	{	
	var url = "BetTicker.ashx?tick=" + $("#tick").val() + "&placed=" + $("#ctl00_MainContent_ddlPlaced").val() + "&History=1";
    $.getJSON(url, function (data) {
		if(data.data != undefined)
		{
			if (data.data.length > 0) {
				var newTickets = data.data.reverse();
				
					for (var i = 0 ; i < newTickets.length ; ++i) {
						var item = newTickets[i];
						var backColor = '#FFFFFF';
						var sound = 'chime.mp3'
						if (item[5] >= 500) {
							backColor = '#8ebdd5';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 1500) {
							backColor = '#93ce82';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 3000) {
							backColor = '#fcf661';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 4000) {
							backColor = '#faba58';
							sound = 'newchime.mp3'
						}
						if (item[5] >= 5000) {
							backColor = '#fa3a3a';
							sound = 'submarinealert.mp3'
						}
						if (item[5] >= 10000) {
							backColor = '#8042ff';
							sound = 'whistleblow.mp3'
						}
						//if(sound != undefined)
						if($("#tick").val() > 1)
				{
						playSound(sound);
				}
						var row = '<tr style="background-color: ' + backColor + ';"><td>' + item[1] + '</td><td>' + item[4] + '</td><td>' + item[2] + '</td><td>' + item[7] + '</td><td>' + item[10] + '</td><td>' + item[9] + '</td><td>' + item[11] + '</td><td>' + item[12] + '</td><td>' + parseFloat(item[5]) + ' / ' + parseFloat(item[6]) + '</td></tr>';

						$('#ticker > tbody').prepend(row);
					
					}
				$("#tick").val(data.mark);
			}
		}
    });
}
}



function playSound(sound) {
        var audio = new Audio('/BetTicker/sounds/' + sound);
        audio.play();
    
}




var html5_audiotypes = {
    "mp3": "audio/mpeg",
    "mp4": "audio/mp4",
    "ogg": "audio/ogg",
    "wav": "audio/wav",
    "aac": "audio/mpeg"
}

function createsoundbite(sound) {
    var html5audio = document.createElement('audio')
    if (html5audio.canPlayType) { //check support for HTML5 audio
        for (var i = 0; i < arguments.length; i++) {
            var sourceel = document.createElement('source')
            sourceel.setAttribute('src', "/BetTicker/sounds/" + arguments[i])
            if (arguments[i].match(/\.(\w+)$/i))
                sourceel.setAttribute('type', html5_audiotypes[RegExp.$1])
            html5audio.appendChild(sourceel)
        }
        html5audio.load()
        html5audio.playclip = function () {
            html5audio.pause()
            html5audio.currentTime = 0
            html5audio.play()
        }
        return html5audio
    }
    else {
        return { playclip: function () { throw new Error("Your browser doesn't support HTML5 audio unfortunately") } }
    }
}

var chimesound = createsoundbite("chime.ogg", "chime.mp3", "chime.aac")
var alertsound = createsoundbite("alert.ogg", "alert.mp3", "alert.aac")
var newchimesound = createsoundbite("newchime.ogg", "newchime.mp3", "newchime.aac")
