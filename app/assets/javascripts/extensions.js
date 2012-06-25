$(function(){
	var KEY = {
	  SHIFT: 16,
	  CTRL: 17,
	  ALT: 18,
	  LEFT: 37,
		UP: 38,
		RIGHT: 39,
		DOWN: 40,
		DEL: 46,
		TAB: 9,
		RETURN: 13,
		ESC: 27,
		COMMA: 188,
		HOME: 36,
		END: 35,
		PAGEUP: 33,
		PAGEDOWN: 34,
		BACKSPACE: 8,
		F5: 116
	}

  $('form#discovery input').bind('keyup', $.debounce(250, function(event){
    switch (event.keyCode){
      case KEY.ESC:
      case KEY.SHIFT:
      case KEY.CTRL:
      case KEY.ALT:
      case KEY.LEFT:
      case KEY.UP:
      case KEY.RIGHT:
      case KEY.DOWN:
      case KEY.HOME:
      case KEY.END:
      case KEY.PAGEUP:
      case KEY.PAGEDOWN:
      case KEY.ENTER:
      case KEY.F5:
        break
      default:
        var item = $(this)
        if (item.val().length < 3){
          $('#results').html('')
        } else {
          item.addClass('loading')
          $.ajax({
            url: '/discovery/search',
            data: {'q': item.val()},
            success: function(data){
              item.removeClass('loading')
              $('#results').html(data)
            }
          })
        }
    }
  }))
})
