# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $.getJSON '/questions', (data) ->
    $('.questions').html(HandlebarsTemplates['questions'](data))

  PrivatePub.subscribe "/questions", (data, channel) ->
    console.log(data)
    json = $.parseJSON(data['question'])
    $('.questions').prepend(Handlebars.partials['_question'](json))
