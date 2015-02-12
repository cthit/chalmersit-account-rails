# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('form').on 'focus', '.autocomplete-dn', ->
    unless $(this).autocomplete('instance')
      $(this).autocomplete
        source: '/users/autocomplete.json'
        minLength: 3
      .autocomplete('instance')._renderItem = render_item

render_item = (ul, item) ->
  $('<li>').append(item.name_and_nick).append('<br><small>' + item.value + '</small>').appendTo(ul)
