$ ->
  $('select#invitations_role').on('change', ->
    if $(this).val() == "3" or $(this).val() == "4"
      $('div#research-projects-list').show()
    else
      $('div#research-projects-list').hide())