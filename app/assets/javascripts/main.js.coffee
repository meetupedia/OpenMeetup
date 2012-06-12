$ ->
  $('a:not([data-remote]):not([rel="facebox"])').pjax(container: '#pjax', timeout: false)
  $('a[rel*=facebox]').facebox()
  $('a.fancybox').fancybox()
