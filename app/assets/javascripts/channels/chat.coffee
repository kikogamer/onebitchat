window.change_chat = (id, type, team_id) ->
  if App.chat != undefined
    App.chat.unsubscribe()

  App.chat = App.cable.subscriptions.create { channel: "ChatChannel", id: id , type: type, team_id: team_id},
    received: (data) ->
      tag_user_id = $('#user_id')
      current_user_id = tag_user_id.data('user-id')
      read = current_user_id == data.user_id
      window.add_message(data.message, data.date, data.name, read)