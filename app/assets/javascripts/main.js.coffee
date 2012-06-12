$ ->
  $('a[rel*=facebox]').facebox()
  $('a.fancybox').fancybox()
  $('a:not([data-remote]):not([rel="facebox"])').pjax(container: '#pjax', timeout: false)
