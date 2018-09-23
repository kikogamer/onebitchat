$(document).on 'turbolinks:load', ->
  $(".add_user").on 'click', (e) =>
    $('#add_user_modal').modal('open')
    $('#invitation_team_id').val(e.target.id)
    return false

  $('.add_user_form').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: {
          invitation: {
            name: $('#invitation_name').val()
            email: $('#invitation_email').val()
            team_id: $('#invitation_team_id').val()
          }
        }
        success: (data, text, jqXHR) ->
          Materialize.toast('User was invited to join the team &nbsp;<b>:)</b>', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problem in add User &nbsp;<b>:(</b>', 4000, 'red')


    $('#add_user_modal').modal('close')
    return false