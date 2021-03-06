// Generated by CoffeeScript 1.6.2
(function() {
  var $, $w, BackgroundSlider, hasRAF,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $ = window.jQuery;

  $w = $(window);

  hasRAF = true;

  (function() {
    var lastTime, vendors, x;

    lastTime = 0;
    vendors = ["ms", "moz", "webkit", "o"];
    x = 0;
    while (x < vendors.length && !window.requestAnimationFrame) {
      window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
      window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] || window[vendors[x] + "CancelRequestAnimationFrame"];
      ++x;
    }
    if (!window.requestAnimationFrame) {
      hasRAF = false;
    }
    if (!window.cancelAnimationFrame) {
      return hasRAF = false;
    }
  })();

  (function() {
    var animate, lastTime, running;

    if (!hasRAF) {
      return;
    }
    lastTime = 0;
    running = null;
    animate = function(elem) {
      if (running) {
        window.requestAnimationFrame(animate, elem);
        return jQuery.fx.tick();
      }
    };
    jQuery.fx.timer = function(timer) {
      if (timer() && jQuery.timers.push(timer) && !running) {
        running = true;
        return animate(timer.elem);
      }
    };
    return jQuery.fx.stop = function() {
      return running = false;
    };
  })();

  BackgroundSlider = (function() {
    function BackgroundSlider(el, opts) {
      this.el = el;
      this.opts = opts;
      this.handleResize = __bind(this.handleResize, this);
      this.getOriginalImgSizes = __bind(this.getOriginalImgSizes, this);
      this.nextSlide = __bind(this.nextSlide, this);
      this.anim_sidebyside = __bind(this.anim_sidebyside, this);
      this.anim_fade = __bind(this.anim_fade, this);
      this.anim_reveal = __bind(this.anim_reveal, this);
      this.getSlide = __bind(this.getSlide, this);
      this.$el = $(this.el);
      this.lis = $('li', this.$el);
      this.imgEls = $('img', this.lis);
      this.imgs = [];
      this.origpos = this.$el.css('position');
      this.origpostop = this.$el.css('top');
      this.origposleft = this.$el.css('left');
      this.$el.css({
        position: 'fixed',
        top: '-30000px',
        left: '-30000px'
      });
      this.ready = false;
      this.slideNum = this.opts.current;
      this.animType = this.opts.animType.toLowerCase();
      this.getOriginalImgSizes();
    }

    BackgroundSlider.prototype.getSlide = function() {
      if (this.slideNum >= this.lis.length - 1) {
        this.slideNum = 0;
      } else {
        this.slideNum += 1;
      }
      return this.lis[this.slideNum];
    };

    BackgroundSlider.prototype.anim_reveal = function(newSlide, oldSlide) {
      var _this = this;

      newSlide.css({
        zIndex: 5,
        display: 'block',
        left: '0px'
      });
      return (function(newSlide, oldSlide) {
        return oldSlide.animate({
          left: "-" + ($w.width()) + "px"
        }, {
          easing: _this.opts.easing,
          duration: _this.opts.animationTime,
          always: function() {
            oldSlide.css({
              display: 'none',
              zIndex: 1
            });
            return newSlide.css({
              zIndex: 10
            });
          }
        });
      })(newSlide, oldSlide);
    };

    BackgroundSlider.prototype.anim_fade = function(newSlide, oldSlide) {
      var _this = this;

      newSlide.css({
        zIndex: 5,
        display: 'block',
        opacity: 1
      });
      oldSlide.css({
        opacity: 1,
        display: 'block',
        zIndex: 10
      });
      return (function(newSlide, oldSlide) {
        return oldSlide.animate({
          opacity: 0
        }, {
          easing: _this.opts.easing,
          duration: _this.opts.animationTime,
          always: function() {
            oldSlide.css({
              display: 'none',
              zIndex: 1
            });
            return newSlide.css({
              zIndex: 10
            });
          }
        });
      })(newSlide, oldSlide);
    };

    BackgroundSlider.prototype.anim_sidebyside = function(newSlide, oldSlide) {
      var _this = this;

      newSlide.css({
        zIndex: 5,
        display: 'block',
        left: "" + (oldSlide.width() + oldSlide.offset().left) + "px",
        top: '0px'
      });
      oldSlide.css({
        display: 'block',
        zIndex: 10,
        left: "0px",
        top: '0px'
      });
      return (function(newSlide, oldSlide) {
        oldSlide.animate({
          left: "-" + ($w.width()) + "px"
        }, {
          easing: _this.opts.easing,
          duration: _this.opts.animationTime,
          queue: false,
          always: function() {
            return oldSlide.css({
              display: 'none',
              zIndex: 1
            });
          }
        });
        return newSlide.animate({
          left: '0px'
        }, {
          easing: _this.opts.easing,
          duration: _this.opts.animationTime,
          queue: false,
          always: function() {
            return newSlide.css({
              zIndex: 10
            });
          }
        });
      })(newSlide, oldSlide);
    };

    BackgroundSlider.prototype.nextSlide = function() {
      var newSlide, oldSlide;

      oldSlide = this.currentSlide;
      newSlide = $(this.getSlide());
      this["anim_" + this.animType](newSlide, oldSlide);
      return this.currentSlide = newSlide;
    };

    BackgroundSlider.prototype.setBaseStyles = function() {
      this.$el.css({
        listStyle: 'none',
        margin: '0',
        padding: '0',
        overflow: 'hidden',
        width: '100%',
        height: '100%',
        position: 'fixed',
        top: '0',
        left: '0'
      });
      this.lis.css({
        listStyle: 'none',
        margin: '0',
        padding: '0',
        position: 'absolute',
        top: '0',
        left: '0',
        width: '100%',
        height: '100%',
        display: 'none',
        overflow: 'hidden',
        zIndex: 1
      });
      return this.imgEls.css({
        position: 'absolute',
        top: '0',
        left: '0'
      });
    };

    BackgroundSlider.prototype.getOriginalImgSizes = function() {
      var $img, ih, img, imgs, iw, ready, _i, _len, _ref;

      imgs = [];
      ready = true;
      _ref = this.imgEls;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        img = _ref[_i];
        $img = $(img);
        iw = $img.width();
        ih = $img.height();
        if (iw === 0 || ih === 0) {
          ready = false;
        }
        imgs.push({
          origWidth: iw,
          origHeight: ih,
          $img: $img
        });
      }
      if (!ready) {
        return setTimeout(this.getOriginalImgSizes, 100);
      }
      this.imgs = imgs;
      this.ready = true;
      return this.whenReady();
    };

    BackgroundSlider.prototype.whenReady = function() {
      var $firstSlide, firstSlide;

      if (!this.ready) {
        return;
      }
      $w.resize(this.handleResize);
      this.handleResize();
      this.$el.css({
        position: this.origpos,
        top: this.origpostop,
        left: this.origposleft
      });
      if (this.opts.injectStyles) {
        this.setBaseStyles();
      }
      firstSlide = this.lis[this.slideNum];
      $firstSlide = $(firstSlide);
      $firstSlide.css({
        zIndex: 10,
        display: 'block'
      });
      this.currentSlide = $firstSlide;
      return setInterval(this.nextSlide, this.opts.delay);
    };

    BackgroundSlider.prototype.handleResize = function(e) {
      if (!this.ready) {
        return;
      }
      return this.positionImages($w.width(), $w.height());
    };

    BackgroundSlider.prototype.positionImages = function(w, h) {
      var $img, height, highestScale, ih, img, iw, left, top, width, _i, _len, _ref;

      _ref = this.imgs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        img = _ref[_i];
        $img = img.$img;
        iw = img.origWidth;
        ih = img.origHeight;
        highestScale = Math.max(w / iw, h / ih);
        width = Math.round(iw * highestScale);
        height = Math.round(ih * highestScale);
        left = Math.round((w / 2) - (width / 2));
        top = Math.round((h / 2) - (height / 2));
        $img.css({
          width: "" + width + "px",
          height: "" + height + "px",
          top: "" + top + "px",
          left: "" + left + "px"
        });
      }
      return void 0;
    };

    return BackgroundSlider;

  })();

  $.fn.backgroundSlider = function($o) {
    var _o;

    _o = $.extend({
      easing: 'linear',
      delay: 6000,
      animationTime: 600,
      current: 0,
      sliding: false,
      animType: 'reveal',
      injectStyles: false
    }, $o);
    return this.each(function(i, el) {
      var slider;

      slider = new BackgroundSlider(el, _o);
      return $(el).data('slider', slider);
    });
  };

}).call(this);

/*
//@ sourceMappingURL=jquery.backgroundSlider.map
*/
