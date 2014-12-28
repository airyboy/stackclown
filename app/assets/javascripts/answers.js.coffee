$ ->
  $(document).on 'click', '#save-button', (e) ->
    $('#edit-form').submit()

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)