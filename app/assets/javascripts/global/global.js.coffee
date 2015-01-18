$ ->
  $(document).on 'click', '.attach-link', (e) ->
    e.preventDefault()
    $('.attachment-fields').show()
    $(this).hide()
    append_file_field($(this).data('resource'))

  #for acceptance tests
  $(".bootstrap-tagsinput").find('input').attr("id", "tags_comma_separated")

@append_file_field = (res) ->
  id = _.uniqueId()
  html = file_input_tmpl({id:id, resource: res})
  $('.attachment-fields').append(html)
  # hide file input
  $("#attachment-#{id}").hide()

  $("#sel-file-#{id}").click (e) ->
    e.preventDefault()
    $("#attachment-#{id}").trigger('click')
    .change ->
#     add field for the new file
      append_file_field(res)

      sel_file = $("#sel-file-#{id}")
      #     set filename for adding link
      sel_file.text($(this).val().split('/').pop().split('\\').pop())
      #     add delete button
      sel_file.wrap ->
        "<div class=\'input-group\'><div class=\'input-group-btn\'>#{$(this).html()}" +
          "<a class=\'btn btn-xs btn-default\' id=\'del-file-#{id}\' href=\'#\'>x</a></div></div>"
      sel_file.attr('disabled', 'disabled')

      #     handler for delete link
      $("#del-file-#{id}").click (e) ->
        e.preventDefault()
        $(this).parent().parent().remove()

@file_input_tmpl = (data) ->
  file_input_html = "<a class='btn btn-default btn-xs' href=\'#\'" +
      "id='sel-file-<%= id %>'>Select file...</a>" +
      "<input id=\'attachment-<%= id %>\'" +
      "name=\'<%= resource %>[attachments_attributes][<%= id %>][file]\' type=\'file\' />"
  #      "<a href=\'#\' id=\'file-input-<%= id %>\'>remove file</a>"
  file_input_template = _.template(file_input_html)
  file_input_template(data)