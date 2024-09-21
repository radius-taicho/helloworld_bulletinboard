# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = find_user_from_cookies
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def find_user_from_cookies
      # クッキーからユーザーを特定するロジックをここに記述
      # 例えば、クッキーからユーザーIDを取得し、Userモデルで検索するなど
      if cookies.signed[:user_id]
        User.find_by(id: cookies.signed[:user_id])
      end
    end
  end
end
