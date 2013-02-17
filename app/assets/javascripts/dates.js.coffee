$ ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "mm/dd/yy"
      altField: $(this).next()
      beforeShowDay: if $(this).hasClass('only_mondays') then (date) -> [date.getDay() == 1,""]