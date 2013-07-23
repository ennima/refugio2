###
@license
jQuery Tools 1.2.5 Tabs- The basics of UI design.

NO COPYRIGHTS OR LICENSES. DO WHAT YOU LIKE.

http://flowplayer.org/tools/tabs/

Since: November 2008
Date:    Wed Sep 22 06:02:10 2010 +0000
###
(($) ->
  
  # static constructs
  
  # 1.2
  
  # simple "toggle" effect
  
  #
  #			configuration:
  #				- fadeOutSpeed (positive value does "crossfading")
  #				- fadeInSpeed
  #		
  
  # for basic accordions
  
  ###
  AJAX effect
  ###
  
  ###
  Horizontal accordion
  
  @deprecated will be replaced with a more robust implementation
  ###
  
  # store original width of a pane into memory
  
  # set current pane's width to zero
  
  # grow opened pane to it's original width
  Tabs = (root, paneSelector, conf) ->
    self = this
    trigger = root.add(this)
    tabs = root.find(conf.tabs)
    panes = (if paneSelector.jquery then paneSelector else root.children(paneSelector))
    current = undefined
    
    # make sure tabs and panes are found
    tabs = root.children()  unless tabs.length
    panes = root.parent().find(paneSelector)  unless panes.length
    panes = $(paneSelector)  unless panes.length
    
    # public methods
    $.extend this,
      click: (i, e) ->
        tab = tabs.eq(i)
        if typeof i is "string" and i.replace("#", "")
          tab = tabs.filter("[href*=" + i.replace("#", "") + "]")
          i = Math.max(tabs.index(tab), 0)
        if conf.rotate
          last = tabs.length - 1
          return self.click(last, e)  if i < 0
          return self.click(0, e)  if i > last
        unless tab.length
          return self  if current >= 0
          i = conf.initialIndex
          tab = tabs.eq(i)
        
        # current tab is being clicked
        return self  if i is current
        
        # possibility to cancel click action				
        e = e or $.Event()
        e.type = "onBeforeClick"
        trigger.trigger e, [i]
        return  if e.isDefaultPrevented()
        
        # call the effect
        effects[conf.effect].call self, i, ->
          
          # onClick callback
          e.type = "onClick"
          trigger.trigger e, [i]

        
        # default behaviour
        current = i
        tabs.removeClass conf.current
        tab.addClass conf.current
        self

      getConf: ->
        conf

      getTabs: ->
        tabs

      getPanes: ->
        panes

      getCurrentPane: ->
        panes.eq current

      getCurrentTab: ->
        tabs.eq current

      getIndex: ->
        current

      next: ->
        self.click current + 1

      prev: ->
        self.click current - 1

      destroy: ->
        tabs.unbind(conf.event).removeClass conf.current
        panes.find("a[href^=#]").unbind "click.T"
        self

    
    # callbacks	
    $.each "onBeforeClick,onClick".split(","), (i, name) ->
      
      # configuration
      $(self).bind name, conf[name]  if $.isFunction(conf[name])
      
      # API
      self[name] = (fn) ->
        $(self).bind name, fn  if fn
        self

    if conf.history and $.fn.history
      $.tools.history.init tabs
      conf.event = "history"
    
    # setup click actions for each tab
    tabs.each (i) ->
      $(this).bind conf.event, (e) ->
        self.click i, e
        e.preventDefault()


    
    # cross tab anchor link
    panes.find("a[href^=#]").bind "click.T", (e) ->
      self.click $(this).attr("href"), e

    
    # open initial tab
    if location.hash and conf.tabs is "a" and root.find("[href=" + location.hash + "]").length
      self.click location.hash
    else
      self.click conf.initialIndex  if conf.initialIndex is 0 or conf.initialIndex > 0
  $.tools = $.tools or version: "1.2.5"
  $.tools.tabs =
    conf:
      tabs: "a"
      current: "current"
      onBeforeClick: null
      onClick: null
      effect: "default"
      initialIndex: 0
      event: "click"
      rotate: false
      history: false

    addEffect: (name, fn) ->
      effects[name] = fn

  effects =
    default: (i, done) ->
      @getPanes().hide().eq(i).show()
      done.call()

    fade: (i, done) ->
      conf = @getConf()
      speed = conf.fadeOutSpeed
      panes = @getPanes()
      if speed
        panes.fadeOut speed
      else
        panes.hide()
      panes.eq(i).fadeIn conf.fadeInSpeed, done

    slide: (i, done) ->
      @getPanes().slideUp 200
      @getPanes().eq(i).slideDown 400, done

    ajax: (i, done) ->
      @getPanes().eq(0).load @getTabs().eq(i).attr("href"), done

  w = undefined
  $.tools.tabs.addEffect "horizontal", (i, done) ->
    w = @getPanes().eq(0).width()  unless w
    @getCurrentPane().animate
      width: 0
    , ->
      $(this).hide()

    @getPanes().eq(i).animate
      width: w
    , ->
      $(this).show()
      done.call()


  
  # jQuery plugin implementation
  $.fn.tabs = (paneSelector, conf) ->
    
    # return existing instance
    el = @data("tabs")
    if el
      el.destroy()
      @removeData "tabs"
    conf = onBeforeClick: conf  if $.isFunction(conf)
    
    # setup conf
    conf = $.extend({}, $.tools.tabs.conf, conf)
    @each ->
      el = new Tabs($(this), paneSelector, conf)
      $(this).data "tabs", el

    (if conf.api then el else this)
) jQuery
