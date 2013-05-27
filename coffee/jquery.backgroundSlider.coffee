$ = window.jQuery
$w = $ window

debounce = (func, wait, immediate) ->

    timeout = null

    (args...) ->

        context = @

        later = ->
            timeout = null
            unless immediate
                func.apply context, args

        callNow = immediate and not timeout
        clearTimeout timeout
        timeout = setTimeout later, wait

        if callNow
            func.apply context, args

class WindowResize
    constructor: ->
        @handlers = []
        @windowWidth = $w.width()
        @windowHeight = $w.height()
        @handle = debounce @_handle, 150
        $w.resize @handle

    _handle: =>
        @windowWidth = $w.width()
        @windowHeight = $w.height()

        for handler in @handlers
            handler.call handler, @windowWidth, @windowHeight

    addListener: (hndlr) =>
        # don't allow duplicates
        for handler in @handlers
            if hndlr is handler
                return false

        @handlers.push hndlr
        # return true because no dupes were found.
        hndlr.call hndlr, @windowWidth, @windowHeight
        true


    removeListener: (hndlr) =>
        _handlers = []
        removed = false
        for handler in @handlers
            if handler isnt hndlr
                _handlers.push handler
            else
                removed = true
        @handlers = _handlers

        removed

windowResize = new WindowResize

class BackgroundSlider
    constructor: (@el, @opts) ->
        @$el = $ @el
        @lis = $ 'li', @$el
        @imgEls = $ 'img', @lis
        @imgs = []

        # if @opts.injectStyles
        #     @setBaseStyles()

        @ready = false
        @getOriginalImgSizes()

        @slideNum = @opts.current
        @animType = @opts.animType.toLowerCase()

        @origpos = @$el.css 'position'
        @origpostop = @$el.css 'top'
        @origposleft = @$el.css 'left'
        @$el.css
            position: 'fixed'
            top: '-30000px'
            left: '-30000px'


    getSlide: =>
        if @slideNum > @lis.length
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
            console.log 'newSlide', newSlide, 'oldSlide', oldSlide

            oldSlide.animate
                left: "-#{$w.width()}px"
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                always: =>
                    console.log 'oldSlide', oldSlide
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
            left: "#{$w.width()}px"
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
                always: =>
                    oldSlide.css
                        display: 'none'
                        zIndex: 1

            newSlide.animate
                left: '0px'
            ,
                easing: @opts.easing
                duration: @opts.animationTime
                always: =>
                    newSlide.css
                        zIndex: 10

    nextSlide: =>
        oldSlide = @currentSlide
        newSlide = $ @getSlide()
        @updateImgs $w.width(), $w.height()

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
        ww = $w.width()
        wh = $w.height()

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
        windowResize.addListener @handleResize
        @updateImgs($w.width(), $w.height())

        @$el.css
            position: @origpos
            top: @origpostop
            left: @origposleft

        if @opts.injectStyles
            @setBaseStyles()

        firstSlide = @lis[@slideNum]

        $firstSlide = $ firstSlide
        $firstSlide.css
            zIndex: 10
            display: 'block'

        @currentSlide = $firstSlide

        setInterval @nextSlide, @opts.delay


    handleResize: (w, h) =>
        return unless @ready

        @updateImgs w, h

    updateImgs: (w, h) ->
        for img in @imgs
            @updateImg w, h, img

    updateImg: (w, h, img) ->
        $img = img.$img
        iw = img.origWidth
        ih = img.origHeight

        if iw is 0 or ih is 0
            console.log 'iw', iw, 'ih', ih
            # WHAT THE HELL??
            # Okay... So, the browser was being a dick earlier. We need to dbl
            # check our w and h of this img real quick.
            $img.width null
            $img.height null
            $img.css
                height: 'auto'
                width: 'auto'
            iw = $img.width()
            ih = $img.height()

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



