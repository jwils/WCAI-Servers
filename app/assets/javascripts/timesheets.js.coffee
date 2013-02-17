# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$('.hour-num-field').change ->
  sum = parseInt(0, 10)
  for cell in $('.hour-num-field')
    sum += parseFloat($(cell).val()) unless $(cell).val() == ""

  $('#ts-total').val(sum)
