$ ->
  $('.file_list li > ul').each (i) ->
    parent_li = $(this).parent('li')
    parent_li.addClass('folder')
    sub_ul = $(this).remove()
    parent_li.wrapInner('<a/>').find('a').click ->
      sub_ul.toggle();
    parent_li.append(sub_ul);
  $('ul ul').hide();
