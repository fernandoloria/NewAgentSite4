(function() {
    $(".box.sub-menu").off().on("click", function() {
        $(".sub-menu-session").toggleClass("hide fadeIn animated faster")
    });
    
    $('[data-action="more-options-menu"]').on("mouseenter", function() {
        $(".sub-menu-more").removeClass("hide")
    });

    $('[data-action="more-options-menu"]').on("mouseleave", function(e) {
        (e.offsetX < 0 || e.offsetX > $(this).width()) && $(".sub-menu-more").addClass("hide")
    });

    $(".sub-menu-more").on("mouseleave", function() {
        $(".sub-menu-more").addClass("hide")
    });
    
    $(".left-menu [data-action='show-menu-left']").off().on("click", function() {
        $(".left-menu .sub-menu-left").toggleClass("slideInLeft");
        $(".left-menu .sub-menu-left").toggleClass("hide");
        const isDisplayed = !$(".left-menu .sub-menu-left").hasClass('hide');
        $('body').css('overflow', isDisplayed ? 'hidden' : '');
    });
    
    $(".right-menu [data-action='show-menu-right']").off().on("click", function() {
        $(".right-menu .sub-menu-right").toggleClass("slideInRight");
        $(".right-menu .sub-menu-right").toggleClass("hide");

        $(".right-menu .account-menu").removeClass("slideInRight");
        $(".right-menu .account-menu").addClass("hide");
    });

    $(".right-menu [data-action='show-account-menu']").off().on("click", function() {
        $(".right-menu .account-menu").toggleClass("slideInRight");
        $(".right-menu .account-menu").toggleClass("hide");

        $(".right-menu .sub-menu-right").removeClass("slideInRight");
        $(".right-menu .sub-menu-right").addClass("hide");
    });
})();

function goTo(element) {
    const url = $(element).data('url')
    if(url != undefined) {
        window.location.href = url;
    }
}

function modalIframe(element) {
    const url = $(element).data('url')
    if(url != undefined) {
        $('.iframe-container iframe').attr('src', url);
        $('.dynamicModal').modal('show');
    }
}