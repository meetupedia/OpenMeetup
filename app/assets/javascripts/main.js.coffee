$ ->
  window.reloadPage = ->
    window.location.reload()

  window.trackAction = ->
    if $.cookie('action')
      _gaq = _gaq || []
      _gaq.push(['_trackEvent', $.cookie('action')], '')

  initPage = ->
    $('.dropdown-toggle').dropdown()
    $('a.fancybox').fancybox
      titlePosition: 'inside'
    window.trackAction()

  initPage()

  $(document)
    .on 'click', 'a[rel*=modal], a.modal', ->
      modalbox.create $(this).attr('href')
      false
    .bind 'modalbox.loaded', ->
      initPage()

    .on 'click', 'a.function', ->
      $(this).toggleClass('expanded')
      false

    .on 'ajax:before', 'a.set_vote', ->
      $(this).parent().find('a').attr('disabled', 'disabled')
    .on 'ajax:success', 'a.set_vote', (event, data, status, xhr) ->
      $(this).parent().replaceWith(data)

    .on 'focus', '#new_feedback textarea', ->
      $(this).animate
        height: '120px'
      , ->
        $(this).closest('form').find('input').show()
