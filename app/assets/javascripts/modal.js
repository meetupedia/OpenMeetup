modalbox = {
  settings: {
    top: 65,
    speed: 250
  },

  loading: function(){
    $('div.modal-content').last().html('<div class="modal-loading"><img src="/modal/loading.gif" alt=""/></div>')
  },

  build: function(){
    $('div.modal-window').last().find('input').blur()
    $('body').append('<div class="modal-background"></div><div class="modal-window"><div class="modal-content"></div></div>')
    modalbox.loading()
    lastWindow = $('div.modal-window').last()
    lastWindow.css({
      top: $(window).scrollTop() + modalbox.settings.top,
      left: $(window).width() / 2 - lastWindow.outerWidth() / 2
    }).show()
    $(document).bind('keydown.modalbox', function(event) {
      if (event.keyCode == 27){
        modalbox.close()
      }
    })
  },

  create: function(href){
    modalbox.build()
    modalbox.load(href)
  },

  show: function(html){
    modalbox.build()
    modalbox.content(html)
  },

  close: function(callback){
    lastBackground = $('div.modal-background').last()
    lastBackground.fadeOut(modalbox.settings.speed, function(){
      lastBackground.remove()
    })
    lastWindow = $('div.modal-window').last()
    lastWindow.find('input').blur()
    lastWindow.fadeOut(modalbox.settings.speed, function(){
      lastWindow.remove()
      if (typeof(callback) === 'function'){
        callback.call(this)
      }
      if ($('div.modal-window').length){
        $('div.modal-window').last().find('.pjax').attr('id', 'pjax')
      } else {
        $(document).unbind('keydown.modalbox')
        $('#content > div').attr('id', 'pjax')
      }
    })
  },

  content: function(html){
    $('#pjax').attr('id', null)
    $('div.modal-content').last().html('<div class="modal-close"><a href="#"><img src="/modal/closelabel.png" alt=""/></a></div><div class="pjax" id="pjax">' + html + '</div>')
    $(document).on('click', 'div.modal-close a', function(){
      $(this).remove()
      modalbox.close()
      return false
    })
  },

  load: function(href, callback){
    $.ajax({
      url: href,
      dataType: 'html',
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-MODAL', 'true')
      },
      success: function(html){
        modalbox.content(html)
        $(document).trigger('modalbox.loaded')
        if (typeof(callback) === 'function'){
          callback.call(this)
        }
      }
    })
    $('div.modal-window').last().attr('rel', href)
  },

  reload: function(){
    lastWindow = $('div.modal-window').last()
    if (lastWindow.length){
      modalbox.loading()
      modalbox.load(lastWindow.attr('rel'))
    } else {
      window.reloadPage()
    }
  },

  reloadParent: function(){
    modalbox.close(function(){ modalbox.reload() })
  }
}
