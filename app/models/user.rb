class User < ApplicationRecord
   before_save { self.email = email.downcase }
   # email = email.comに書き換え可能
   # データベースに保存される直前にすべての文字列を小文字に変換
   # オブジェクトが保存される時点で処理を実行したいので、before_saveというコールバックを使う
   
   validates :name,  presence: true, length: { maximum: 50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
   has_secure_password
   validates :password, presence: true, length: { minimum: 6 }
   
end
