# Jquery with no conflict
jQuery(document).ready ($) ->
  
  ###########################################
  # COLUMNIZR
  ###########################################
  $(".multicolumn").columnize columns: 2
  
  ###########################################
  # CAROUSEL
  ###########################################
  
  # Configuration goes here (http://sorgalla.com/projects/jcarousel/)
  $("#mycarousel").jcarousel vertical: false
  
  # Configuration goes here (http://sorgalla.com/projects/jcarousel/)
  $("#mycarousel-vertical").jcarousel vertical: true
  
  ###########################################
  # LOF SLIDER
  ###########################################
  buttons =
    previous: $("#home-slider .button-previous")
    next: $("#home-slider .button-next")

  $("#home-slider").lofJSidernews
    interval: 4000
    direction: "opacitys"
    easing: "easeInOutExpo"
    duration: 1200
    auto: false
    maxItemDisplay: 5
    navPosition: "horizontal" # horizontal
    navigatorHeight: 73
    navigatorWidth: 188
    mainWidth: 940
    buttons: buttons

  
  ###########################################
  # Superfish
  ###########################################
  $("ul.sf-menu").superfish
    animation: # slide-down effect without fade-in
      height: "show"

    delay: 800 # 1.2 second delay on mouseout
    autoArrows: false
    speed: 100

  
  ###########################################
  # PROJECT SLIDER
  ###########################################
  $(".project-slider").flexslider
    animation: "fade"
    controlNav: true
    directionNav: false
    keyboardNav: true

  
  ###########################################
  # Filter - Isotope 
  ###########################################
  $container = $("#filter-container")
  $container.imagesLoaded ->
    $container.isotope
      itemSelector: "figure"
      filter: "*"
      resizable: false
      animationEngine: "jquery"


  
  # filter buttons
  $("#filter-buttons a").click ->
    
    # select current
    $optionSet = $(this).parents("#filter-buttons")
    $optionSet.find(".selected").removeClass "selected"
    $(this).addClass "selected"
    selector = $(this).attr("data-filter")
    $container.isotope filter: selector
    false

  
  ###########################################
  # Tool tips
  ###########################################
  $(".poshytip").poshytip
    className: "tip-twitter"
    showTimeout: 1
    alignTo: "target"
    alignX: "center"
    offsetY: 5
    allowTipHover: false

  $(".form-poshytip").poshytip
    className: "tip-twitter"
    showOn: "focus"
    alignTo: "target"
    alignX: "right"
    alignY: "center"
    offsetX: 5

  
  ###########################################
  # Tweet feed
  ###########################################
  $("#tweets").tweet
    count: 3
    username: "ansimuz"

  
  ###########################################
  # PrettyPhoto
  ###########################################
  $("a[data-rel]").each ->
    $(this).attr "rel", $(this).data("rel")

  $("a[rel^='prettyPhoto']").prettyPhoto()
  
  ###########################################
  # Accordion box
  ###########################################
  $(".accordion-container").hide()
  $(".accordion-trigger:first").addClass("active").next().show()
  $(".accordion-trigger").click ->
    if $(this).next().is(":hidden")
      $(".accordion-trigger").removeClass("active").next().slideUp()
      $(this).toggleClass("active").next().slideDown()
    false

  
  ###########################################
  # Toggle box
  ###########################################
  $(".toggle-trigger").click(->
    $(this).next().toggle "slow"
    $(this).toggleClass "active"
    false
  ).next().hide()
  
  ###########################################
  # Tabs
  ###########################################
  $(".tabs").tabs "div.panes > div",
    effect: "fade"

  
  ###########################################
  # Create Combo Navi
  ###########################################	
  
  # Create the dropdown base
  $("<select id='comboNav' />").appendTo "#combo-holder"
  
  # Create default option "Go to..."
  $("<option />",
    selected: "selected"
    value: ""
    text: "Navigation"
  ).appendTo "#combo-holder select"
  
  # Populate dropdown with menu items
  $("#nav a").each ->
    el = $(this)
    label = $(this).parent().parent().attr("id")
    sub = (if (label is "nav") then "" else "- ")
    $("<option />",
      value: el.attr("href")
      text: sub + el.text()
    ).appendTo "#combo-holder select"

  
  ###########################################
  # Combo Navigation action
  ###########################################
  $("#comboNav").change ->
    location = @options[@selectedIndex].value

  
  ###########################################
  # Resize event
  ###########################################
  
  #console.log(w);
  $(window).resize(->
    w = $(window).width()
    $container.isotope "reLayout"
  ).trigger "resize"

#close	
