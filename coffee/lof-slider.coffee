#! Copyright (c) 2011 Brandon Aaron (http://brandonaaron.net)
# * Licensed under the MIT License (LICENSE.txt).
# *
# * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
# * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
# * Thanks to: Seamus Leahy for adding deltaX and deltaY
# *
# * Version: 3.0.6
# * 
# * Requires: 1.2.2+
# 
(($) ->
  handler = (event) ->
    orgEvent = event or window.event
    args = [].slice.call(arguments_, 1)
    delta = 0
    returnValue = true
    deltaX = 0
    deltaY = 0
    event = $.event.fix(orgEvent)
    event.type = "mousewheel"
    
    # Old school scrollwheel delta
    delta = orgEvent.wheelDelta / 120  if orgEvent.wheelDelta
    delta = -orgEvent.detail / 3  if orgEvent.detail
    
    # New school multidimensional scroll (touchpads) deltas
    deltaY = delta
    
    # Gecko
    if orgEvent.axis isnt `undefined` and orgEvent.axis is orgEvent.HORIZONTAL_AXIS
      deltaY = 0
      deltaX = -1 * delta
    
    # Webkit
    deltaY = orgEvent.wheelDeltaY / 120  if orgEvent.wheelDeltaY isnt `undefined`
    deltaX = -1 * orgEvent.wheelDeltaX / 120  if orgEvent.wheelDeltaX isnt `undefined`
    
    # Add event and delta to the front of the arguments
    args.unshift event, delta, deltaX, deltaY
    ($.event.dispatch or $.event.handle).apply this, args
  types = ["DOMMouseScroll", "mousewheel"]
  if $.event.fixHooks
    i = types.length

    while i
      $.event.fixHooks[types[--i]] = $.event.mouseHooks
  $.event.special.mousewheel =
    setup: ->
      if @addEventListener
        i = types.length

        while i
          @addEventListener types[--i], handler, false
      else
        @onmousewheel = handler

    teardown: ->
      if @removeEventListener
        i = types.length

        while i
          @removeEventListener types[--i], handler, false
      else
        @onmousewheel = null

  $.fn.extend
    mousewheel: (fn) ->
      (if fn then @bind("mousewheel", fn) else @trigger("mousewheel"))

    unmousewheel: (fn) ->
      @unbind "mousewheel", fn

) jQuery

###
@version		2.0
@package		jquery
@subpackage	lofslidernews
@copyright	Copyright (C) JAN 2010 LandOfCoder.com <@emai:landofcoder@gmail.com>. All rights reserved.
@website     http://landofcoder.com
@license		This plugin is dual-licensed under the GNU General Public License and the MIT License
###

# JavaScript Document
(($) ->
  $.fn.lofJSidernews = (settings) ->
    @each ->
      
      # get instance of the lofSiderNew.
      new $.lofSidernews(this, settings)


  $.lofSidernews = (obj, settings) ->
    @settings =
      direction: ""
      mainItemSelector: "li"
      navInnerSelector: "ul"
      navSelector: "li"
      navigatorEvent: "click" # click|mouseenter
      wapperSelector: ".sliders-wrap-inner"
      interval: 5000
      auto: false # whether to automatic play the slideshow
      maxItemDisplay: 3
      startItem: 0
      navPosition: "vertical" # values: horizontal|vertical
      navigatorHeight: 100
      navigatorWidth: 310
      duration: 600
      navItemsSelector: ".navigator-wrap-inner li"
      navOuterSelector: ".navigator-wrapper"
      isPreloaded: true
      easing: "easeInOutQuad"
      onPlaySlider: (obj, slider) ->

      onComplete: (slider, index) ->

    $.extend @settings, settings or {}
    @nextNo = null
    @previousNo = null
    @maxWidth = @settings.mainWidth or 684
    @wrapper = $(obj).find(@settings.wapperSelector)
    wrapOuter = $("<div class=\"sliders-wrapper\"></div>").width(@maxWidth)
    @wrapper.wrap wrapOuter
    @slides = @wrapper.find(@settings.mainItemSelector)
    return  if not @wrapper.length or not @slides.length
    
    # set width of wapper
    @settings.maxItemDisplay = @slides.length  if @settings.maxItemDisplay > @slides.length
    @currentNo = (if isNaN(@settings.startItem) or @settings.startItem > @slides.length then 0 else @settings.startItem)
    @navigatorOuter = $(obj).find(@settings.navOuterSelector)
    @navigatorItems = $(obj).find(@settings.navItemsSelector)
    @navigatorInner = @navigatorOuter.find(@settings.navInnerSelector)
    
    # if use automactic calculate width of navigator
    if not @settings.navigatorHeight? or not @settings.navigatorWidth?
      @settings.navigatorHeight = @navigatorItems.eq(0).outerWidth(true)
      @settings.navigatorWidth = @navigatorItems.eq(0).outerHeight(true)
    if @settings.navPosition is "horizontal"
      @navigatorInner.width @slides.length * @settings.navigatorWidth
      @navigatorOuter.width @settings.maxItemDisplay * @settings.navigatorWidth
      @navigatorOuter.height @settings.navigatorHeight
    else
      @navigatorInner.height @slides.length * @settings.navigatorHeight
      @navigatorOuter.height @settings.maxItemDisplay * @settings.navigatorHeight
      @navigatorOuter.width @settings.navigatorWidth
    @slides.width @settings.mainWidth
    @navigratorStep = @__getPositionMode(@settings.navPosition)
    @directionMode = @__getDirectionMode()
    if @settings.direction is "opacity"
      @wrapper.addClass "lof-opacity"
      $(@slides).css(
        opacity: 0
        "z-index": 1
      ).eq(@currentNo).css
        opacity: 1
        "z-index": 3

    else
      @wrapper.css
        left: "-" + @currentNo * @maxSize + "px"
        width: (@maxWidth) * @slides.length

    if @settings.isPreloaded
      @preLoadImage @onComplete
    else
      @onComplete()
    $buttonControl = $(".button-control", obj)
    if @settings.auto
      $buttonControl.addClass "action-stop"
    else
      $buttonControl.addClass "action-start"
    self = this
    $(obj).hover (->
      self.stop()
      $buttonControl.addClass("action-start").removeClass("action-stop").addClass "hover-stop"
    ), ->
      if $buttonControl.hasClass("hover-stop")
        if self.settings.auto
          $buttonControl.removeClass("action-start").removeClass("hover-stop").addClass "action-stop"
          self.play self.settings.interval, "next", true

    $buttonControl.click ->
      if $buttonControl.hasClass("action-start")
        self.settings.auto = true
        self.play self.settings.interval, "next", true
        $buttonControl.removeClass("action-start").addClass "action-stop"
      else
        self.settings.auto = false
        self.stop()
        $buttonControl.addClass("action-start").removeClass "action-stop"


  $.lofSidernews.fn = $.lofSidernews::
  $.lofSidernews.fn.extend = $.lofSidernews.extend = $.extend
  $.lofSidernews.fn.extend
    startUp: (obj, wrapper) ->
      seft = this
      @navigatorItems.each (index, item) ->
        $(item).bind seft.settings.navigatorEvent, (->
          seft.jumping index, true
          seft.setNavActive index, item
        )
        $(item).css
          height: seft.settings.navigatorHeight
          width: seft.settings.navigatorWidth


      @registerWheelHandler @navigatorOuter, this
      @setNavActive @currentNo
      @settings.onComplete @slides.eq(@currentNo), @currentNo
      @registerButtonsControl "click", @settings.buttons, this  if @settings.buttons and typeof (@settings.buttons) is "object"
      @play @settings.interval, "next", true  if @settings.auto
      this

    onComplete: ->
      setTimeout (->
        $(".preload").fadeOut 900, ->
          $(".preload").remove()

      ), 400
      @startUp()

    preLoadImage: (callback) ->
      self = this
      images = @wrapper.find("img")
      count = 0
      images.each (index, image) ->
        unless image.complete
          image.onload = ->
            count++
            self.onComplete()  if count >= images.length

          image.onerror = ->
            count++
            self.onComplete()  if count >= images.length
        else
          count++
          self.onComplete()  if count >= images.length


    navivationAnimate: (currentIndex) ->
      if currentIndex <= @settings.startItem or currentIndex - @settings.startItem >= @settings.maxItemDisplay - 1
        @settings.startItem = currentIndex - @settings.maxItemDisplay + 2
        @settings.startItem = 0  if @settings.startItem < 0
        @settings.startItem = @slides.length - @settings.maxItemDisplay  if @settings.startItem > @slides.length - @settings.maxItemDisplay
      @navigatorInner.stop().animate eval_("({" + @navigratorStep[0] + ":-" + @settings.startItem * @navigratorStep[1] + "})"),
        duration: 500
        easing: "easeInOutQuad"


    setNavActive: (index, item) ->
      if @navigatorItems
        @navigatorItems.removeClass "active"
        $(@navigatorItems.get(index)).addClass "active"
        @navivationAnimate @currentNo

    __getPositionMode: (position) ->
      return ["left", @settings.navigatorWidth]  if position is "horizontal"
      ["top", @settings.navigatorHeight]

    __getDirectionMode: ->
      switch @settings.direction
        when "opacity"
          @maxSize = 0
          ["opacity", "opacity"]
        else
          @maxSize = @maxWidth
          ["left", "width"]

    registerWheelHandler: (element, obj) ->
      element.bind "mousewheel", (event, delta) ->
        dir = (if delta > 0 then "Up" else "Down")
        vel = Math.abs(delta)
        if delta > 0
          obj.previous true
        else
          obj.next true
        false


    registerButtonsControl: (eventHandler, objects, self) ->
      for action of objects
        switch action.toString()
          when "next"
            objects[action].click ->
              self.next true

          when "previous"
            objects[action].click ->
              self.previous true

      this

    onProcessing: (manual, start, end) ->
      @previousNo = @currentNo + ((if @currentNo > 0 then -1 else @slides.length - 1))
      @nextNo = @currentNo + ((if @currentNo < @slides.length - 1 then 1 else 1 - @slides.length))
      this

    finishFx: (manual) ->
      @stop()  if manual
      @play @settings.interval, "next", true  if manual and @settings.auto
      @setNavActive @currentNo
      @settings.onPlaySlider this, $(@slides).eq(@currentNo)

    getObjectDirection: (start, end) ->
      eval_ "({'" + @directionMode[0] + "':-" + (@currentNo * start) + "})"

    fxStart: (index, obj, currentObj) ->
      s = this
      if @settings.direction is "opacity"
        $(@slides).stop().animate
          opacity: 0
        ,
          duration: @settings.duration
          easing: @settings.easing
          complete: ->
            s.slides.css "z-index", "1"
            s.slides.eq(index).css "z-index", "3"

        $(@slides).eq(index).stop().animate
          opacity: 1
        ,
          duration: @settings.duration
          easing: @settings.easing
          complete: ->
            s.settings.onComplete $(s.slides).eq(index), index

      else
        @wrapper.stop().animate obj,
          duration: @settings.duration
          easing: @settings.easing
          complete: ->
            s.settings.onComplete $(s.slides).eq(index), index

      this

    jumping: (no_, manual) ->
      @stop()
      return  if @currentNo is no_
      obj = eval_("({'" + @directionMode[0] + "':-" + (@maxSize * no_) + "})")
      @onProcessing(null, manual, 0, @maxSize).fxStart(no_, obj, this).finishFx manual
      @currentNo = no_

    next: (manual, item) ->
      @currentNo += (if (@currentNo < @slides.length - 1) then 1 else (1 - @slides.length))
      @onProcessing(item, manual, 0, @maxSize).fxStart(@currentNo, @getObjectDirection(@maxSize), this).finishFx manual

    previous: (manual, item) ->
      @currentNo += (if @currentNo > 0 then -1 else @slides.length - 1)
      @onProcessing(item, manual).fxStart(@currentNo, @getObjectDirection(@maxSize), this).finishFx manual

    play: (delay, direction, wait) ->
      @stop()
      this[direction] false  unless wait
      self = this
      @isRun = setTimeout(->
        self[direction] true
      , delay)

    stop: ->
      return  unless @isRun?
      clearTimeout @isRun
      @isRun = null

) jQuery
