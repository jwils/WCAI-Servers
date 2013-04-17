$ ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "mm/dd/yy"
      altField: $(this).next()
      beforeShowDay: if $(this).hasClass('only_mondays') then (date) ->
        [date.getDay() == 1, ""]
    #HACK to fix datetime issue in hidden field
    ht_val = $(this).next().val().split('/')
    $(this).next().val(ht_val[2] + '-' + ht_val[0] + '-' + ht_val[1]) if ht_val.length == 3