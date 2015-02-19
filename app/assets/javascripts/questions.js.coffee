# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $.getJSON '/questions', (data) ->
    $('.questions').html(HandlebarsTemplates['questions/questions'](data))

  if gon.total_pages > 1
    $('.paginator').bootpag {total: gon.total_pages, page: 1, maxVisible: 7}
      .on 'page', (event, num) ->
        $('window').scrollTop()
        $.getJSON "/questions/?page=#{num}", (data) ->
          $('.questions').html(HandlebarsTemplates['questions/questions'](data))

  PrivatePub.subscribe "/questions", (data, channel) ->
    console.log(data)
    json = $.parseJSON(data['question'])
    $('.questions').prepend(Handlebars.partials['questions/_question'](json))
