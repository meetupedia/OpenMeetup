modalbox =
  settings:
    top: 65
    speed: 250

  loading: ->
    $('div.modal-content').last().html '<div class="modal-loading"><img src="/modal/loading.gif" alt=""/></div>'

  build: ->
    $('div.modal-window').last().find('input').blur()
    $('body').append '<div class="modal-background"></div><div class="modal-window"><div class="modal-content"></div></div>'
    modalbox.loading()
    lastWindow = $('div.modal-window').last()
    lastWindow.css(
      top: $(window).scrollTop() + modalbox.settings.top
      left: $(window).width() / 2 - lastWindow.outerWidth() / 2
    ).show()
    $(document).bind 'keydown.modalbox', (event) ->
      modalbox.close()  if event.keyCode is 27

  create: (href) ->
    modalbox.build()
    modalbox.load href

  show: (html) ->
    modalbox.build()
    modalbox.content html

  close: (callback) ->
    lastBackground = $('div.modal-background').last()
    lastBackground.fadeOut modalbox.settings.speed, ->
      lastBackground.remove()

    lastWindow = $('div.modal-window').last()
    lastWindow.find('input').blur()
    lastWindow.fadeOut modalbox.settings.speed, ->
      lastWindow.remove()
      callback.call this  if typeof (callback) is 'function'
      if $('div.modal-window').length
        $('div.modal-window').last().find('.pjax').attr 'id', 'pjax'
      else
        $(document).unbind 'keydown.modalbox'
        $('#content > div').attr 'id', 'pjax'

  content: (html) ->
    $('#pjax').attr 'id', null
    $('div.modal-content').last().html '<div class="modal-close"><a href="#"><img src="/modal/closelabel.png" alt=""/></a></div><div class="pjax" id="pjax">' + html + '</div>'
    $(document).on 'click', 'div.modal-close a', ->
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
        callback.call this  if typeof (callback) is 'function'
    $('div.modal-window').last().attr 'rel', href

  reload: ->
    lastWindow = $('div.modal-window').last()
    if lastWindow.length
      modalbox.loading()
      modalbox.load lastWindow.attr('rel')
    else
      window.reloadPage()

  reloadParent: ->
    modalbox.close ->
      modalbox.reload()
