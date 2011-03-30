/* Declare a namespace for the site */
var Site = window.Site || {};

/* Create a closure to maintain scope of the '$'
   and remain compatible with other frameworks.  */
(function($) {
	
	//same as $(document).ready();
	$(function() {
		
		  // for the home page script
		  jQuery(".homebox").hide();
		  //toggle the componenet with class msg_body
		  jQuery(".heading").click(function()
		  {
			jQuery(this).next(".homebox").slideToggle(500);
		  });
          $(window).resize(function() {
              var img = $(".background"),
                    wW = $(window).width(),
                    wH = $(window).height(),
                    iH = img.height(),
                    iW = img.width();
          	if (!(((iH < wH || iW < wW) || (iH > wH && iW > wW)) && (iH > 0 && iW > 0)))
          	{
          		//return;
          	}
          	var highestScale,
          	    widthScale = wW / iW,
          	    heightScale = wH / iH;
          	highestScale = Math.max(heightScale, widthScale);
          	newWidth = iW * highestScale;
          	newHeight = iH * highestScale;
          	img.css({
              	width:newWidth.toString()+"px",
              	height:newHeight.toString()+"px"
          	});
          });
	});


	$(window).bind("load", function() {
		
        //slides the element with class "menu_body" when mouse is over the paragraph
        $("#content article.what h1").mouseover(function()
        {
             $(this).next("div.menu_body").slideDown(500).siblings("div.menu_body").slideUp("slow");
        });
	
	});
	
})(jQuery);


/*    $(document).ready(function()
    {
        //slides the element with class "menu_body" when mouse is over the paragraph
        $("#content article.what h1").mouseover(function()
        {
             $(this).next("div.menu_body").slideDown(500).siblings("div.menu_body").slideUp("slow");
        });
    });
*/