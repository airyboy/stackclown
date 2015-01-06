$ ->
  $(document).on 'click', '#save-button', (e) ->
    $('#edit-form').submit()

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  $(document).on 'click', '.remove-comment', (e) ->
    $(this).parent().hide()

  $(document).on 'click', '#add-comment', (e) ->
    e.preventDefault()
    res = $(this).data('resource')
    id = $(this).data('id')
    commentDiv = $(".comments[data-resource=#{res}][data-id=#{id}]")
    commentDiv.append(comment_form_tmpl({resource: res, id: id}))
    addLink = this
    $(this).hide()

    sel = "form##{res}-comment-form-#{id}";

    console.log(sel)

    $(sel).bind 'ajax:success', (e, data, status, xhr) ->
      comment = $.parseJSON(xhr.responseText)
      commentDiv.append(comment_tmpl(comment))
      commentDiv.find('.comment-errors').empty()
      $(sel).hide()
      $(addLink).show()


    $(sel).bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        commentDiv.find('.comment-errors').append(value)

  $(document).on 'click', '.attach-link', (e) ->
    e.preventDefault()
    $('.attachment-fields').show()
    $(this).hide()
    append_file_field()

#  $(document).on 'click', '#add-file-link', (e) ->
#    e.preventDefault()
#    id = Date.now()
#    html = file_input_tmpl({id:id, resource: 'answer'})
#    $(html).insertBefore($('.attachment-fields').find('#add-file-link'))
#    $("#attachment-#{id}").css('opacity','0');
#
#    $("#sel-file-#{id}").click (e) ->
#      e.preventDefault()
#      $("#attachment-#{id}").trigger('click').change ->
#        $('.attachment-fields').append($(this).val())
#
#    $(document).on 'click', "#file-input-#{id}", (e) ->
#      e.preventDefault()
#      alert('ok')

@append_file_field = () ->
  id = Date.now()
  html = file_input_tmpl({id:id, resource: 'answer'})
  $('.attachment-fields').append(html)
# hide file input
  $("#attachment-#{id}").hide()

  $("#sel-file-#{id}").click (e) ->
    e.preventDefault()
    $("#attachment-#{id}").trigger('click')
    .change ->
#     add field for the new file
      append_file_field()

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


@comment_form_tmpl = (data) ->
  comment_form_html = "<div class=\'comment-errors\'></div>" +
      "<form accept-charset=\'UTF-8\' action=\'/<%= resource %>/<%= id %>/comments\' class=\'simple_form comment\' " +
#     create form id using format: questions-comment-form-2 or answers-comment-form-3
      "id=\'<%= resource %>-comment-form-<%= id %>\'" +
      "data-remote=\'true\' data-type=\'json\' method=\'post\' novalidate=\'novalidate\'>" +
      "<div style=\'display:none\'><input name=\'utf8\' type=\'hidden\' value=\'&#x2713;\' /></div>" +
      "<div class=\'form-group string required comments_body\'>" +
      "<textarea class=\'text required form-control\' id=\'comment_body\' rows=\'2\' name=\'comment[body]\'" +
      "placeholder='Your comment' type=\'text\' />" +
      "<input class=\'btn btn-default\' name=\'commit\' type=\'submit\' value=\'Post\' />"
      "</form>";
  comment_form_template = _.template(comment_form_html);
  comment_form_template(data)

@comment_tmpl = (data) ->
  comment_html = "<div class=\'comment\'>" +
      "<%= body %> |  " +
      "<a data-method=\'delete\' href=\'comments/<%= id %>\' rel=\'nofollow\'>x</a>" +
      "</div>"
  comment_template = _.template(comment_html);
  comment_template(data)

@file_input_tmpl = (data) ->
  file_input_html = "<a class='btn btn-default btn-xs' href=\'#\' id='sel-file-<%= id %>'>Select file...</a><input id=\'attachment-<%= id %>\'" + "" +
      "name=\'<%= resource %>[attachments_attributes][<%= id %>][file]\' type=\'file\' />"
#      "<a href=\'#\' id=\'file-input-<%= id %>\'>remove file</a>"
  file_input_template = _.template(file_input_html)
  file_input_template(data)