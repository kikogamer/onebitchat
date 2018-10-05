$(document).on 'turbolinks:load', ->
  $(".add_user").on 'click', (e) =>
    $('#add_user_modal').modal('open')
    $('#team_invitation_team_id').val(e.target.id)
    return false

  $('.add_user_form').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: {
          team_invitation: {
            name: $('#team_invitation_name').val()
            email: $('#team_invitation_email').val()
            team_id: $('#team_invitation_team_id').val()
          }
        }
        success: (data, text, jqXHR) ->
          Materialize.toast('User was invited to join the team &nbsp;<b>:)</b>', 4000, 'green')
          $('#team_invitation_name').val('')
          $('#team_invitation_email').val('')
        error: (jqXHR, textStatus, errorThrown) ->
          if jqXHR.status == 422
            Materialize.toast(jqXHR.responseText, 4000, 'red')
          else
            Materialize.toast('Problem in add User &nbsp;<b>:(</b>', 4000, 'red')

    $('#add_user_modal').modal('close')
    return false