$ ->
  $(document).on 'click', '#save-button', (e) ->
    $('#edit-form').submit()

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  $(document).on 'click', '.edit-comment', (e) ->
    id = $(this).parent().data('id')
    $.getJSON "/comments/#{id}", (data) ->
      $('.modal-body').empty()
      $('.modal-body').append(edit_comment_form_tmpl({id: data.id, resource: ''}))
      $('.modal-body').find('#comment_body').val(data.body)
      $('#myModal').modal();
      $("#edit-form").bind 'ajax:success', (e, data, status, xhr) ->
        comment = $.parseJSON(xhr.responseText)
        old = $(".comment[data-id=#{comment.id}]")
        $(".comment[data-id=#{comment.id}]").after(comment_tmpl(comment))
        old.detach()
        $('.modal-body').find('.comment-errors').empty()
        $('#myModal').hide()
      $("#edit-form").bind 'ajax:error', (e, xhr, status, error) ->
        errors = $.parseJSON(xhr.responseText)
        $.each errors, (index, value) ->
          $('.modal-body').find('.comment-errors').append(value)

  $(document).on 'click', '.remove-comment', (e) ->
    $(this).parent().hide()

  $(document).on 'click', '#add-comment', (e) ->
    e.preventDefault()
    res = $(this).data('resource')
    id = $(this).data('id')
    commentDiv = $(".comments[data-resource=#{res}][data-id=#{id}]")
    commentDiv.append(new_comment_form_tmpl({resource: res, id: id}))
    addLink = this
    $(this).hide()
    sel = "form##{res}-comment-form-#{id}";
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
    append_file_field($(this).data('resource'))


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


@comment_form_html = (isNew) ->
  if isNew
    url = "/<%= resource %>/<%= id %>/comments"
  else
    url = "/comments/<%= id %>"

  patch_field = "<input name=\'_method\' type=\'hidden\' value=\'patch\'>" unless isNew

  id = if isNew then "<%= resource %>-comment-form-<%= id %>" else "edit-form"

  comment_form_html = "<div class=\'comment-errors\'></div>" +
      "<form accept-charset=\'UTF-8\' action=\'#{url}\' class=\'simple_form comment\' " +
#     create form id using format: questions-comment-form-2 or answers-comment-form-3
      "id=\'#{id}\'" +
      "data-remote=\'true\' data-type=\'json\' method=\'post\' novalidate=\'novalidate\'>" +
      "<div style=\'display:none\'><input name=\'utf8\' type=\'hidden\' value=\'&#x2713;\' />#{patch_field}</div>" +
      "<div class=\'form-group string required comments_body\'>" +
      "<textarea class=\'text required form-control\' id=\'comment_body\' rows=\'2\' name=\'comment[body]\'" +
      "placeholder='Your comment' type=\'text\' />" +
      "<input class=\'btn btn-default\' name=\'commit\' type=\'submit\' value=\'Post\' />" +
      "</form>"

@edit_comment_form_tmpl = (data) ->
  html = "<div class=\'comment-errors\'></div>" +
      "<form accept-charset=\'UTF-8\' action=\'/comments/<%= id %>\' class=\'simple_form comment\' " +
      "id=\'edit-form\'" +
      "data-remote=\'true\' data-type=\'json\' method=\'post\' novalidate=\'novalidate\'>" +
      "<div style=\'display:none\'><input name=\'utf8\' type=\'hidden\' value=\'&#x2713;\' />" +
      "<input name=\'_method\' type=\'hidden\' value=\'patch\'></div>" +
      "<div class=\'form-group string required comments_body\'>" +
      "<textarea class=\'text required form-control\' id=\'comment_body\' rows=\'2\' name=\'comment[body]\'" +
      "placeholder='Your comment' type=\'text\' />" +
      "</form>"

  tmpl = _.template(html)
  tmpl(data)

@new_comment_form_tmpl = (data) ->
  tmpl = _.template(comment_form_html(true))
  tmpl(data)

@comment_tmpl = (data) ->
  comment_html = "<div class=\'comment\' data-id=\'<%= id %>\'>" +
      "<%= body %> |  " +
      "<a class=\'edit-comment\' href=\'#\'>edit</a> | " +
      "<a data-method=\'delete\' href=\'/comments/<%= id %>\' rel=\'nofollow\'>x</a>" +
      "</div>"
  comment_template = _.template(comment_html);
  comment_template(data)

@file_input_tmpl = (data) ->
  file_input_html = "<a class='btn btn-default btn-xs' href=\'#\'" +
      "id='sel-file-<%= id %>'>Select file...</a>" +
      "<input id=\'attachment-<%= id %>\'" +
      "name=\'<%= resource %>[attachments_attributes][<%= id %>][file]\' type=\'file\' />"
#      "<a href=\'#\' id=\'file-input-<%= id %>\'>remove file</a>"
  file_input_template = _.template(file_input_html)
  file_input_template(data)