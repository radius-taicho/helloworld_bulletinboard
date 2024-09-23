# config/importmap.rb

# Pin npm packages by running ./bin/importmap
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "post", to: "post.js"
pin "edit-delete-modal", to: "edit-delete-modal.js"
pin "comment", to: "comment.js"
pin "edit-delete-comment", to: "edit-delete-comment.js"
pin "file-upload", to: "file-upload.js"
pin "display", to: "display.js"
pin "direct-message-request", to: "direct-message-request.js"
pin "notification", to: "notification.js"
pin "direct-message", to: "direct-message.js"
pin "profile-edit", to: "profile-edit.js"
pin "animation", to: "animation.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "room_channel", to: "channels/room_channel.js"
pin "level_up_notification_channel", to: "channels/level_up_notification_channel.js"
pin_all_from "app/javascript/channels", under: "channels"
