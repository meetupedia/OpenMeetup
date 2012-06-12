$ ->
  initSystem = ->
    $('a[rel*=facebox]').facebox()
    $('a.fancybox').fancybox()
  initSystem()

  $('a:not([data-remote]):not([rel="facebox"]):not(.fancybox)').pjax(container: '#pjax', timeout: false)

  $('#pjax').live 'pjax:success', ->
    initSystem()
