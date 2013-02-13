$ ->
  $('select#invitations_role').on('change', ->
    if $(this).val() == "3"
      $('div#research-projects-list').show()
    else
      $('div#research-projects-list').hide())