set_chat = (name) ->
    $(".chat_name").html(name)

clean_messages = () ->
    $(".messages").html("")
    $(".chat_name").html("")

unread_messages = []

window.notify_message = (type, id, user_id) ->
  if type == 'channels'
    talk = $('.channel_'+ id) 
  else
    talk = $('.user_'+ user_id)

  tag_user_id = $('#user_id')
  current_user_id = tag_user_id.data('user-id')
  
  if (user_id != current_user_id && talk)
    talk.css('font-weight', 'bold')

window.add_message = (message, message_date, name, read) ->  
  class_notify = if read then "" else "notify_message"

  user_avatar = $('#user-avatar').html()
  
  $(".messages").append('<div class="message col s12">' +
                          '<div class="col m2 l1">' +
                            user_avatar +
                          '</div>'+
                          '<div class="col m10 s9">'+
                            '<div class="row">'+
                              '<b>' + name + '</b> <span class="date">' + message_date + '</span>'+
                            '</div>' +
                            '<div class="row card-panel blue-grey lighten-2 white-text">'+
                              "<span class='#{class_notify}'>"+ message + '</span>'+
                            '</div>'+
                          '</div>'+
                        '</div>')
  $(".messages").animate({ scrollTop: $('.messages').prop("scrollHeight")}, 100);

window.open = (id, type) ->
  clean_messages()
  $.ajax "/" + type + "/" + id,
      type: 'GET'
      contentType:'application/json',
      dataType: 'json'
      data: {team_id: $(".team_id").val()}
      success: (data, text, jqXHR) ->
        if type == "talks"
          set_chat(data['user']['name'])
        else
          set_chat(data['slug'])

        window.change_chat(id, type, $(".team_id").val())

        tag_user_id = $('#user_id')
        current_user_id = tag_user_id.data('user-id')

        if(data['messages'])
          for message in data['messages']
            do ->
              window.add_message(message['body'], message['date'], message['user']['name'], message['read'])
              unless message['read'] then unread_messages.push({ message_id: message['id'], user_id: current_user_id })          

          if (unread_messages.length > 0)    
            window.notify_message(type, id, 0)        
            App.notification.send({ unread_messages })
            unread_messages.length = 0;
        
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast('Problem to get ' + type + ' informations &nbsp;<b>:(</b>', 4000, 'red')

    return false

window.add = (slug, id, type) ->
  additional = if type == "channel" then "#" else ""
  $('.' + type + 's').prepend('<li class="' + type + '_' + id + '">' +
                              '  <div>' +
                                    '<a href="#" class="open_' + type + '">' +
                                        '<span id="' + id + '">' + additional + slug + '</span>' +
                                    '</a>' +
                                    '<a class="right remove_' + type + '" href="#" id="' + id + '">' +
                                        '<i class="material-icons" id="' + id + '">settings</i>' +
                                    '</a>' +
                                '</div>' +
                            '</li>')