$ ->
  initSystem = ->
    $('a[rel*=facebox]').facebox()
    $('a.fancybox').fancybox()

  initSystem()

  # $('a:not([data-disable-pjax]):not([data-remote]):not([rel="facebox"]):not(.fancybox):not(.function)').pjax(container: '#pjax', timeout: false)
  $('.nav-tabs a').pjax(container: '#pjax', timeout: false)

  $('#pjax').live 'pjax:success', ->
    $.facebox.close()
    initSystem()

  # if $.cookie('flash_notice')
  #   flash = $.parseJSON(decodeURIComponent($.cookie('flash_notice')))
  #   $('#flash_notice').show().find('span').html(flash)
  #   $.cookie('flash_notice', null, {path: '/'})

  # if $.cookie('flash_alert')
  #   flash = $.parseJSON(decodeURIComponent($.cookie('flash_alert')))
  #   $('#flash_alert').show().find('span').html(flash)
  #   $.cookie('flash_alert', null, {path: '/'})

$('a.function').live 'click', ->
  $(this).toggleClass('expanded')
  false