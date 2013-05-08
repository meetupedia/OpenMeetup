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

  $(document)
    .on 'click', 'a[rel*=modal], a.modal', ->
      modalbox.create $(this).attr('href')
      false

    .on 'click', 'a.function', ->
      $(this).toggleClass('expanded')
      false

    .on 'ajax:before', 'a.set_vote', ->
      $(this).parent().find('a').addClass('disabled')
    .on 'ajax:success', 'a.set_vote', (event, data, status, xhr) ->
      $(this).parent().replaceWith(data)

    .on 'focus', '#new_feedback textarea', ->
      $(this).css(
        height: '120px'
      ).parent().find('input').show()
