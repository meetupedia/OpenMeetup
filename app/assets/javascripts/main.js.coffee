$ ->
  window.reloadPage = ->
    # Turbolinks.visit(window.location)
    window.location.reload()

  initPage = ->
    $('.dropdown-toggle').dropdown()
    $('a.fancybox').fancybox
      titlePosition: 'inside'
      onComplete: ->
        $('#fancybox-title-inside').append '<br /><iframe src="//www.facebook.com/plugins/like.php?href=' + this.href + '&amp;layout=button_count&amp;show_faces=true&amp;width=500&amp;action=like&amp;font&amp;colorscheme=light&amp;height=23" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:110px; height:23px;" allowTransparency="true"></iframe>'
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
