modalbox = {
  settings: {
    top: 65,
    speed: 250,
    distance: 20
  },

  build: function(){
    $('div.modal-window').last().find('input').blur()
    $('body').append('<div class="modal-background"></div><div class="modal-window"><div class="modal-content"><div class="modal-loading"><img src="/modal/loading.gif" alt=""/></div></div></div>')
    lastWindow = $('div.modal-window').last()
    lastWindow.css({
      top: $(window).scrollTop() + modalbox.settings.top,
      left: $(window).width() / 2 - lastWindow.outerWidth() / 2
    }).show().draggable({distance: modalbox.settings.distance})
    $(document).bind('keydown.modalbox', function(event) {
      if (event.keyCode == 27){
        modalbox.close()
      }
    })
    $('div.modal-close a').live('click', function(){
      $(this).remove()
      modalbox.close()
      return false
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

  close: function(){
    lastBackground = $('div.modal-background').last()
    lastBackground.fadeOut(modalbox.settings.speed, function(){
      lastBackground.remove()
    })
    lastWindow = $('div.modal-window').last()
    lastWindow.find('input').blur()
    lastWindow.fadeOut(modalbox.settings.speed, function(){
      lastWindow.trigger('modalbox.closed').remove()
    })
    if (!$('div.modal-window')){
      $(document).unbind('keydown.modalbox')
      $(document).trigger('modalbox.closed').unbind('modalbox.closed')
    }
  },

  afterClose: function(callback){
    $('div.modal-window').last().bind('modalbox.closed', callback)
  },

  content: function(html){
    $('div.modal-content').last().html('<div class="modal-close"><a href="#"><img src="/modal/closelabel.png" alt=""/></a></div>' + html)
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

  reloadParent: function(){
    parentWindow = $('div.modal-window').eq(-2)
    if (parentWindow.length){
      $('#overlay').fadeIn(1000)
      href = parentWindow.attr('rel')
      modalbox.load(href, function(){ $('#overlay').hide() })
    } else {
      window.reloadPage()
    }
  }
}
