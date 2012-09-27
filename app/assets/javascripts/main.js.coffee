$ ->
  initPage = ->
    $('a.fancybox').fancybox()

  initPage()

  $(document).bind 'modalbox.loaded', ->
    initPage()

  $('a[rel*=modal], a.modal').live 'click', ->
    modalbox.create $(this).attr('href')
    return false

  $('a.function').live 'click', ->
    $(this).toggleClass('expanded')
    false
