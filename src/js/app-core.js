window.onbeforeunload = showMainLoading;
window.onunload = showMainLoading;

function showMainLoading() {
    window.scrollTo(0, 0);
    $("#loading").css("display", "block");
    $("body").attr("style", "overflow-y: hidden !important;");
}

$(document).ready(function () {
    notifyHideLoader();

    var datepickerElements = document.querySelectorAll('.datepicker');
    if (datepickerElements.length > 0) {
        datepickerElements.forEach(function (datepicker) {
            flatpickr(datepicker, {
                enableTime: false,
                dateFormat: "m-d-Y",
            });
        });
    }

    var tomSelectElements = document.querySelectorAll(".tomlist");
    if (tomSelectElements.length > 0) {
        tomSelectElements.forEach(function (element) {
            new TomSelect(element, {
                create: true,
                sortField: {
                    field: "text",
                    direction: "asc"
                }
            });
        });
    }
});



var AJAX_LOADING_COUNTER = 0;

const notifyShowLoader = () => {
    window.scrollTo(0, 0);
    AJAX_LOADING_COUNTER++;

    var loading = window.parent.document.getElementById('loading');
    $(loading).show();

    $('body').attr('style', 'overflow-y: hidden !important;');
    $('.card.card-page-responsive .card-body').attr('style', 'display: none !important;');
};

const notifyHideLoader = () => {
    if (AJAX_LOADING_COUNTER > 0) {
        AJAX_LOADING_COUNTER--;
    }

    if (AJAX_LOADING_COUNTER <= 0) {
        AJAX_LOADING_COUNTER = 0;
        $('body').attr('style', 'overflow-y: auto !important;');
        $('.card.card-page-responsive .card-body').attr('style', 'display: block !important;');

        var loading = window.parent.document.getElementById('loading');
        $(loading).hide();
    }
};


const resetAjaxLoadingCounter = () => AJAX_LOADING_COUNTER = 0;

const isAjaxLoading = () => AJAX_LOADING_COUNTER > 0;


$(function () {
    // Disables datatable error dialog.
    if ($.fn.dataTable) {
        $.fn.dataTable.ext.errMode = 'none';
    }

    var isFirstLoading = false;

    $.ajaxSetup({
        global: true,
        beforeSend: (xhr, settings) => {
            //notifyHideLoader();
            if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
                const csrf_token = $('input[name="__RequestVerificationToken"]').val();
                xhr.setRequestHeader("anti-csrf-token", csrf_token);
            }
        }
    });

    $(document).ajaxSend((event, jqxhr, settings) => {
        let executeLoader = true;
        if (settings.headers != undefined && settings.headers.trytoping != 'undefined') {
            executeLoader = false;
        }
        if (isFirstLoading && executeLoader) {
            notifyShowLoader();
        }
    });

    // Captures global ajax error responses and display a toast with the related error.
    $(document).ajaxComplete((event, xhr, ajaxOptions, thrownError) => {
        if (!document.cookie)
            $('.md-toast-top-right').hide();

        isFirstLoading = false;

        let responseJson = xhr.responseJSON;

        if (responseJson == undefined) {
            try {
                let responseText = xhr.responseText.substr(0, xhr.responseText.indexOf('}') + 1);
                responseJson = JSON.parse(responseText);
            } catch (e) { }
        }

        if (responseJson && responseJson.ErrorKey && responseJson.ErrorMessage) {
            if (responseJson.ErrorKey == "unauthorized" || xhr.status == 401) {
                const urlRef = responseJson.ExtraData;
                setTimeout(() => window.parent.location.href = urlRef, 3000);
                window.parent.toastr.error(responseJson.ErrorMessage);
            }
            else if (responseJson.ErrorKey == "forbidden" || xhr.status == 403) {
                window.parent.location.href = "/Report/ErrorHandle.aspx?errorCode=403";
            }
            else {
                window.parent.toastr.error(responseJson.ErrorMessage);
            }
        }
        else if (responseJson && responseJson.d) {
            try {
                const data = JSON.parse(responseJson.d);

                if (data.Key && data.Message) {
                    if (data.Key.includes("no_changes"))
                        window.parent.toastr.info(data.Message);
                    else if (data.Key.includes("warning"))
                        window.parent.toastr.warning(data.Message);
                    else if (data.Key.includes("error"))
                        window.parent.toastr.error(data.Message);
                    else
                        window.parent.toastr.success(data.Message);
                }
            } catch (e) { }
        } else if (xhr.status == 500) {
            window.parent.toastr.error("Unexpected Internal Error");
        }
        notifyHideLoader();
    });

    $(document).ajaxError((XMLHttpRequest) => {
        $('.dataTables_processing').attr('style', 'display: none;');
        $('.dataTables_wrapper').removeClass('processing');
    });

    $('.submit-with-loader').on('click touchstart', (e) => isFirstLoading = true);
});

const checkSuccess = (data, key) => {
    try {
        const respJson = JSON.parse(data.d);
        return respJson.Key == key;
    } catch (e) {
        return false;
    }
};

const isSuccess = (data) => (data.d) ? true : false;

const checkError = (data, key) => data.responseJSON.ErrorKey == key;

const getExtraData = (data) => {
    try {
        const respJson = JSON.parse(data.d);
        return respJson.ExtraData;
    } catch (e) {
        return "";
    }
};

let csrfSafeMethod = (method) => (/^(GET|HEAD|OPTIONS)$/.test(method));

var idleTime = 0;

function resetTimer() {
    clearTimeout(idleTime);
    idleTime = setTimeout(function () {
        window.location.href = '/Report/LockScreen.aspx';
    }, 1800000); // 30 minutes in milliseconds
}

document.onmousemove = resetTimer;
document.onkeypress = resetTimer;

window.onload = resetTimer;




