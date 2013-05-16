$ = window.jQuery

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
        @$w = $ window
        @handlers = []
        @windowWidth = @$w.width()
        @windowHeight = @$w.height()
        @handle = debounce @_handle, 150
        @$w.resize @handle

    _handle: =>
        @windowWidth = @$w.width()
        @windowHeight = @$w.height()

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
        @imgs = $ 'img', @lis

        if @opts.injectStyles
            @setBaseStyles()

        @ready = false
        @$w = $ window
        @$w.load @getOriginalImgSizes

        @slideNum = @opts.current
        @animType = @opts.animType.toLowerCase()

        firstSlide = @lis[@slideNum]

        $firstSlide = $ firstSlide
        $firstSlide.css
            zIndex: 10
            display: 'block'

        @currentSlide = $firstSlide

        setInterval @nextSlide, @opts.delay

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

            oldSlide.animate
                left: "-#{@$w.width()}px"
            ,
                easing: @opts.easing
                duration: @opts.animationTime
            , =>
                oldSlide.css
                    display: 'none'
                    zIndex: 1

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

        @imgs.css
            position: 'absolute'
            top: '0'
            left: '0'

    getOriginalImgSizes: =>
        imgs = []
        ww = @$w.width()
        wh = @$w.height()

        for img in @imgs
            $img = $ img

            imgs.push
                origWidth: $img.width()
                origHeight: $img.height()
                $img: $img

        @imgs = imgs
        @ready = true
        windowResize.addListener @handleResize
        @updateImgs(@$w.width(), @$w.height())


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



