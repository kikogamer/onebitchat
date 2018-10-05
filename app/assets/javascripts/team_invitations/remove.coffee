$(document).on 'turbolinks:load', ->
    $('.reject_team_invitation_form').on 'submit', (e) ->
        
        $.ajax e.target.action,
            type: 'DELETE'
            dataType: 'json'
            success: (data, text, jqXHR) ->
                Materialize.toast('Invitation rejected successfully &nbsp;<b>:)</b>', 4000, 'green')
            error: (jqXHR, textStatus, errorThrown) ->
                Materialize.toast('Problem in rejected invitation &nbsp;<b>:(</b>', 4000, 'red')
        
        e.target.parentElement.parentElement.remove()
        
        return false