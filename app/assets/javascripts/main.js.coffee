$ ->
  initPage = ->
    $('a.fancybox').fancybox()

  initPage()

  $('.nav-tabs a:not([rel="modal"], .pagination a)').pjax(container: '#pjax', timeout: false)

  $('#pjax').live 'pjax:success', ->
    initPage()

  # if $.cookie('flash_notice')
  #   flash = $.parseJSON(decodeURIComponent($.cookie('flash_notice')))
  #   $('#flash_notice').show().find('span').html(flash)
  #   $.cookie('flash_notice', null, {path: '/'})

  # if $.cookie('flash_alert')
  #   flash = $.parseJSON(decodeURIComponent($.cookie('flash_alert')))
  #   $('#flash_alert').show().find('span').html(flash)
  #   $.cookie('flash_alert', null, {path: '/'})

  $(document).bind 'modalbox.loaded', ->
    initPage()

  $('a[rel*=modal], a.modal').live 'click', ->
    modalbox.create $(this).attr('href')
    return false

  $('a.function').live 'click', ->
    $(this).toggleClass('expanded')
    false
