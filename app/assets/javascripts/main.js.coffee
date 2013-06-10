$ ->
  window.reloadPage = ->
    window.location.reload()

  initPage = ->
    $('.dropdown-toggle').dropdown()
    $('a.fancybox').fancybox
      titlePosition: 'inside'

  initPage()

  $(document).bind 'modalbox.loaded', ->
    initPage()

  $(document)
    .on 'click', 'a[rel*=modal], a.modal', ->
      modalbox.create $(this).attr('href')
      false

    .on 'click', 'a.function', ->
      $(this).toggleClass('expanded')
      false

    .on 'ajax:before', 'a.set_vote', ->
      $(this).parent().find('a').addClass('muted')
    .on 'ajax:success', 'a.set_vote', (event, data, status, xhr) ->
      $(this).parent().replaceWith(data)

    .on 'focus', '#new_feedback textarea', ->
      $(this).animate({height: '120px'}).parent().find('input').show()
