$(document).ready(function () {
    leftVMenu();
	lrHeightEqual();
	UserDropdown();
    TopNav();
	inlinePopup();
	Tabs();
	
});


// left toggle menu 

function leftVMenu() {
    var menu = $('.vLeftMenu a'),
			anchorText = $('.vMenu .heading> span, .vMenu a> span'),
			leftCol = $('.leftCol');
   
    menu.on('click', function (event) {
        event.preventDefault();      
        anchorText.toggle();
        leftCol.toggleClass('leftColToggle');
    

    });
}

function lrHeightEqual() {

    var leftCol = $('.leftCol'),
 rightColHeight = $('.middle_col').height();
    $(leftCol).css('height', (rightColHeight));
    $('.leftCol').css('height', (rightColHeight	));
    

}

function UserDropdown()
{
    $("#notificationLink").click(function () {
        $("#notificationContainer").fadeToggle(300);
        return false;
    });
    //Document Click
    $(document).click(function ()
    {
        $("#notificationContainer").hide();
    });
    //Popup Click
    $("#notificationContainer").click(function () {
        e.preventDefault;
        return false;
    });
}

function TopNav()
{
    $('.top_nav > a.toggle').click(function () {
        selfActive = $(this).hasClass("show") ? true : false;
        $(".show").removeClass("show").next("ul").slideUp();
        if (!selfActive) { $(this).addClass("show").next("ul").slideDown(); }
    });
    $(document).click(function () { $(".show").removeClass("show").next("ul").hide(); });
    $(".top_nav > a.toggle").click(function (e) { e.stopPropagation(); });
}

function Tabs()
{
    $(".tabs_menu a").click(function (event) {
        event.preventDefault();
        $(this).parent().addClass("current");
        $(this).parent().siblings().removeClass("current");
        var tab = $(this).attr("href");
        $(".tab_content").not(tab).css("display", "none");
        $(tab).fadeIn();
    });
}

function inlinePopup()
{
		$('.open-popup-link').magnificPopup({
        	type:'inline',
            midClick: true // Allow opening popup on middle mouse click. Always set it to true if you don't provide alternative source in href.
        });
}

