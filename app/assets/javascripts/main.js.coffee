$ ->
  window.reloadPage = ->
    # Turbolinks.visit(window.location)
    window.location.reload()

  initPage = ->
    $('.dropdown-toggle').dropdown()
    $('a.fancybox').fancybox
      titlePosition: 'inside'
#    $('a[rel*=modal], a.fancybox').attr('data-no-turbolink', true)

  initPage()

  $(document).bind 'modalbox.loaded', ->
    initPage()

#  $(document).bind 'page:change', ->
#    initPage()


  $('a[rel*=modal], a.modal').live 'click', ->
    modalbox.create $(this).attr('href')
    return false

  $('a.function').live 'click', ->
    $(this).toggleClass('expanded')
    false

  $('#new_feedback textarea').on 'focus', ->
    $(this).css(
      height: '120px'
    ).parent().find('input').show()
