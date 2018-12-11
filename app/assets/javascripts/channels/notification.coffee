window.change_team = (team_id) ->
  if App.notification != undefined
    App.notification.unsubscribe()

  App.notification = App.cable.subscriptions.create { channel: "NotificationChannel", team_id: team_id },
    received: (data) ->
      window.notify_message(data.type, data.id, data.user_id)
