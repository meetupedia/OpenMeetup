modalbox =
  settings:
    top: 65
    speed: 250

  loading: ->
    $('div.modalbox-content').last().html '<div class="modalbox-loading"><img src="/modal/loading.gif" alt=""/></div>'

  build: ->
    $('div.modalbox-window').last().find('input').blur()
    $('body').append '<div class="modalbox-background"></div><div class="modalbox-window"><div class="modalbox-content"></div></div>'
    modalbox.loading()
    lastWindow = $('div.modalbox-window').last()
    lastWindow.css(
      top: $(window).scrollTop() + modalbox.settings.top
      left: $(window).width() / 2 - lastWindow.outerWidth() / 2
    ).show()
    $(document).bind 'keydown.modalbox', (event) ->
      modalbox.close() if event.keyCode is 27

  create: (href) ->
    modalbox.build()
    modalbox.load href

  show: (html) ->
    modalbox.build()
    modalbox.content html

  close: (callback) ->
    lastBackground = $('div.modalbox-background').last()
    lastBackground.fadeOut modalbox.settings.speed, ->
      lastBackground.remove()

    lastWindow = $('div.modalbox-window').last()
    lastWindow.find('input').blur()
    lastWindow.fadeOut modalbox.settings.speed, ->
      lastWindow.remove()
      $(document).trigger('modalbox.closed')
      callback.call this if typeof(callback) == 'function'
      unless $('div.modalbox-window').length
        $(document).unbind 'keydown.modalbox'

  afterClose: (callback) ->
    $(document).last().bind('modalbox.closed', callback)

  content: (html) ->
    $('div.modalbox-content').last().html '<div class="modalbox-close"><a href="#"><img src="/modal/closelabel.png" alt=""/></a></div>' + html
    $(document).on 'click', 'div.modalbox-close a', ->
      $(this).remove()
      modalbox.close()
      false

  load: (href, callback) ->
    $.ajax
      url: href
      dataType: 'html'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-MODAL', 'true'
      success: (html) ->
        modalbox.content html
        $(document).trigger 'modalbox.loaded'
        callback.call this if typeof(callback) == 'function'
    $('div.modalbox-window').last().attr 'rel', href

  reload: ->
    lastWindow = $('div.modalbox-window').last()
    if lastWindow.length
      modalbox.loading()
      modalbox.load lastWindow.attr('rel')
    else
      window.reloadPage()

  reloadParent: ->
    modalbox.close ->
      modalbox.reload()


window.modalbox = modalbox
