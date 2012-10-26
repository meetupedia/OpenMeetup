$ ->
  window.reloadPage = ->
    Turbolinks.visit(window.location)

  initPage = ->
    $('.dropdown-toggle').dropdown()
    $('a.fancybox').fancybox()
    $('a[rel*=modal], a.fancybox').attr('data-no-turbolink', true)

  initPage()

  $(document).bind 'modalbox.loaded', ->
    initPage()

  $(document).bind 'page:change', ->
    initPage()


  $('a[rel*=modal], a.modal').live 'click', ->
    modalbox.create $(this).attr('href')
    return false

  $('a.function').live 'click', ->
    $(this).toggleClass('expanded')
    false
