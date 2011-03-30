(function($) {
    $.fn.backgroundSlider = function($o) {
        var _o = $.extend({
            easing: "linear",
            delay: 6000,
            animationTime: 600,
            current: 0,
            sliding: false,
            animType: "reveal"
        }, $o),
        
        __ = {
            scaleCrop: function(li) {
                var img = $($(li).find('img:first')),
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
            },
            
            center: function(li) {
                __.centerX($(li));
                __.centerY($(li));
            },
            centerX: function(li) {
                var img = $(li.find('img:first')),
        	        wW = $(window).width(),
        	        iW = img.width();                
                li.css({
    				left:((0 - (iW / 2)) + (wW / 2)).toString() + "px"
                });
            },
            centerY: function(li) {
                img = $(li.find('img:first')),
        	    wH = $(window).height(),
        	    iH = img.height(),
                li.css({
    				top:((0 - (iH / 2)) + (wH / 2)).toString() + "px"
                });
            },
            matchInnerOuter: function(li) {
                var $li = $(li),
                    img = $li.find('img:first')),
            	    iH = img.height(),
            	    iW = img.width();
            	$li.width(iw);
            	$li.height(ih);
            },
            showFirstSlide: function(el) {
                $(el.find('li')).each(function(index, _el) {
                    var $_el = $(_el);
                    $_el.css({
                        position: 'absolute',
                        top: "0px",
                        left:"0px"
                    });
                    __.matchInnerOuter($_el);
                    if (index != _o.current) {
                        console.log("fixing " + index);
                        $_el.css({opacity:0, zIndex: 98});
                    } else {
                        console.log("fixing first");
                        console.log($_el.css("top"), $_el.css("left"), $_el.width(), $_el.height());
                        __.scaleCrop($_el);
                        __.centerX($_el);
                        __.centerY($_el);
                        $_el.css({zIndex: 100});
                        console.log($_el.css("top"), $_el.css("left"), $_el.width(), $_el.height());
                    }
                });
            },
            
            nextSlide: function(el) {
                _o.sliding = true;
                // get li's
                var LIs = $(el.find('li')),
                // get next slide li
                    nextIndex = (_o.current+1)%LIs.length,
                    nextLi = $(LIs[nextIndex]),
                    nextImg = nextLi.find('img:first');
                __.scaleCrop(nextLi);
                // centerY next slide
                __.centerY(nextLi);    
                var nextWidth = nextImg.width(),
                    nextHeight = nextImg.height(),
                // get dimensions / top left of current slide
                    currentLi = $(LIs[_o.current]),
                    currentImg = currentLi.find('img:first'),
                    currentWidth = currentImg.width(),
                    currentHeight = currentImg.height(),
                    currentTop = currentLi.css('top'),
                    currentLeft = currentLi.css('left');
                
                // If we want the new slide to 'push' the old slide out.
                if (_o.animType == "sidebyside") {
                    console.log("sidebyside");
                    // set left of next slide to the right edge of the current slide
                    nextLi.css({
                        left:(parseInt(currentLeft.replace("px", ""))+currentWidth)+"px",
                        opacity:1
                    });
                    // determine where the top and left will animate to for the next slide.
                    var nextStopLeft = ((0 - (nextWidth / 2)) + ($(window).width() / 2)).toString();
                    // figure where top and left will animate to for current slide
                    var currentStopLeft = nextStopLeft - currentWidth;
                    nextLi.animate({left:nextStopLeft+"px"}, _o.animationTime, _o.easing);
                    currentLi.animate({left:currentStopLeft+"px"}, _o.animationTime, _o.easing, function() {
                        currentLi.css({opacity:0});
                        _o.current = nextIndex;
                        _o.sliding = false;
                    });
                } else {
                    console.log("reveal");
                    // 'reveal' old slide underneath new one.
                    __.centerX(nextLi);
                    nextLi.css({zIndex:99,opacity:1});
                    console.log("set opacity of next to 1");
                    var currentStopLeft = parseInt(nextLi.css("left").replace("px", "")) - currentWidth;
                    currentLi.animate({left:currentStopLeft+"px"}, _o.animationTime, _o.easing, function() {
                        console.log("done animating");
                        currentLi.css({opacity:0, zIndex:98});
                        nextLi.css({zIndex:100});
                        _o.current = nextIndex;
                        _o.sliding = false;
                    });

                }

            },
            
            handler: function(el) {
                var _tmr = null;
                $(window).bind('resize.backgroundSlider', function() {
                    if (_tmr) {
                        clearTimeout(_tmr);
                    }
                    _tmr = setTimeout(function() { var _li = $($(el).find('li')[_o.current]); __.scaleCrop(_li); __.center(_li); }, 250)
                });
            },
            
            switchHandler: function(el) {
                var _sTmr = null;
                if (_sTmr) {
                    clearTimeout(_sTmr);
                }
                if (!_o.sliding) {
                   __.nextSlide(el);
                }
                _sTmr = setTimeout(function() { __.switchHandler(el); }, _o.delay)
            }
        };

        return this.each(function(index, el) {
            $el = $(el);
            $el.css({
                position:'absolute',
                top: '0px',
                left: '0px'
            });
            __.showFirstSlide($el);
            __.handler($el);
            _o.sliding = true;
            __.switchHandler($el);
            _o.sliding = false;
        });
    };
})(jQuery);