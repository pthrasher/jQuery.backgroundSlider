$ = window.jQuery
$w = $ window

hasRAF = true

do ->
    lastTime = 0
    vendors = ["ms", "moz", "webkit", "o"]
    x = 0

    while x < vendors.length and not window.requestAnimationFrame
        window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
        window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
        ++x

    unless window.requestAnimationFrame
        hasRAF = false

    unless window.cancelAnimationFrame
        hasRAF = false


do ->
    return unless hasRAF
    lastTime = 0
    running = null
    animate = (elem) ->
        if running
            window.requestAnimationFrame animate, elem
            jQuery.fx.tick()

    jQuery.fx.timer = (timer) ->
        if timer() and jQuery.timers.push(timer) and not running
            running = true
            animate timer.elem

    jQuery.fx.stop = ->
        running = false

class BackgroundSlider
    constructor: (@el, @opts) ->
        @$el = $ @el
        @lis = $ 'li', @$el
        @imgEls = $ 'img', @lis
        @imgs = []

        @origpos = @$el.css 'position'
        @origpostop = @$el.css 'top'
        @origposleft = @$el.css 'left'

        @$el.css
            position: 'fixed'
            top: '-30000px'
            left: '-30000px'

        @ready = false
        @slideNum = @opts.current
        @animType = @opts.animType.toLowerCase()
        @getOriginalImgSizes()


    getSlide: =>
        if @slideNum >= @lis.length - 1
            @slideNum = 0
        else
            @slideNum += 1

        @lis[@slideNum]

    anim_reveal: (newSlide, oldSlide) =>
        newSlide.css
            zIndex: 5
            display: 'block'
            left: '0px'

        do (newSlide, oldSlide) =>

            oldSlide.animate
                left: "-#{$w.width()}px"
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                always: =>
                    oldSlide.css
                        display: 'none'
                        zIndex: 1

                    newSlide.css
                        zIndex: 10

    anim_fade: (newSlide, oldSlide) =>
        newSlide.css
            zIndex: 5
            display: 'block'
            opacity: 1

        oldSlide.css
            opacity: 1
            display: 'block'
            zIndex: 10

        do (newSlide, oldSlide) =>
            oldSlide.animate
                opacity: 0
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                always: =>
                    oldSlide.css
                        display: 'none'
                        zIndex: 1

                    newSlide.css
                        zIndex: 10

    anim_sidebyside: (newSlide, oldSlide) =>
        newSlide.css
            zIndex: 5
            display: 'block'
            left: "#{oldSlide.width() + oldSlide.offset().left}px"
            top: '0px'

        oldSlide.css
            display: 'block'
            zIndex: 10
            left: "0px"
            top: '0px'

        do (newSlide, oldSlide) =>
            oldSlide.animate
                left: "-#{$w.width()}px"
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                queue: false
                always: =>
                    oldSlide.css
                        display: 'none'
                        zIndex: 1

            newSlide.animate
                left: '0px'
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                queue: false
                always: =>
                    newSlide.css
                        zIndex: 10

    nextSlide: =>
        oldSlide = @currentSlide
        newSlide = $ @getSlide()

        @["anim_#{@animType}"] newSlide, oldSlide

        @currentSlide = newSlide

    setBaseStyles: ->
        @$el.css
            listStyle: 'none'
            margin: '0'
            padding: '0'
            overflow: 'hidden'
            width: '100%'
            height: '100%'
            position: 'fixed'
            top: '0'
            left: '0'

        @lis.css
            listStyle: 'none'
            margin: '0'
            padding: '0'
            position: 'absolute'
            top: '0'
            left: '0'
            width: '100%'
            height: '100%'
            display: 'none'
            overflow: 'hidden'
            zIndex: 1

        @imgEls.css
            position: 'absolute'
            top: '0'
            left: '0'

    getOriginalImgSizes: =>
        imgs = []

        ready = true
        for img in @imgEls
            $img = $ img

            iw = $img.width()
            ih = $img.height()

            if iw is 0 or ih is 0
                ready = false

            imgs.push
                origWidth: iw
                origHeight: ih
                $img: $img

        unless ready
            return setTimeout @getOriginalImgSizes, 100

        @imgs = imgs
        @ready = true
        @whenReady()

    whenReady: ->
        return unless @ready

        $w.resize @handleResize
        @handleResize()

        @$el.css
            position: @origpos
            top: @origpostop
            left: @origposleft

        if @opts.injectStyles
            @setBaseStyles()

        firstSlide = @lis[@slideNum]

        $firstSlide = $ firstSlide
        console.log $($firstSlide).html()
        $firstSlide.css
            zIndex: 10
            display: 'block'

        @currentSlide = $firstSlide

        setInterval @nextSlide, @opts.delay


    handleResize: (e) =>
        return unless @ready
        @positionImages $w.width(), $w.height()

    positionImages: (w, h) ->
        for img in @imgs
            $img = img.$img
            iw = img.origWidth
            ih = img.origHeight

            #scale and crop
            highestScale = Math.max (w / iw), (h / ih)
            width = Math.round(iw * highestScale)
            height = Math.round(ih * highestScale)

            #center
            left = Math.round((w / 2) - (width / 2))
            top = Math.round((h / 2) - (height / 2))

            $img.css
                width: "#{width}px"
                height: "#{height}px"
                top: "#{top}px"
                left: "#{left}px"

        undefined


$.fn.backgroundSlider = ($o) ->
    _o = $.extend
        easing: 'linear'
        delay: 6000
        animationTime: 600
        current: 0
        sliding: false
        animType: 'reveal'
        injectStyles: false
    , $o

    @each (i, el) ->
        slider = new BackgroundSlider el, _o
        $(el).data('slider', slider)



