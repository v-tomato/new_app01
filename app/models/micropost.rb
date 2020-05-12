class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  default_scope { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :memo, length: { maximum: 255 }
  validates :only_user_id, presence: true
  
  
  def resize_picture
    return self.picture.variant(resize: '200x200').processed
  end

  private
    def only_user_id
      time.presence or memo.presence 
    end

    # def validate_picture
    #   if picture.attached?
    #     if !picture.content_type.in?(%('image/jpeg image/jpg image/png image/gif'))
    #       errors.add(:picture, 'はjpeg, jpg, png, gif以外の投稿ができません')
    #     elsif picture.blob.byte_size > 5.megabytes
    #       errors.add(:picture, "のサイズが5MBを超えています")
    #     end
    #   end
    # end
    
    # # アップロードされた画像のサイズをバリデーションする
    # def picture_size
    #   if picture.size > 5.megabytes
    #     errors.add(:picture, "のサイズが5MBを超えています")
    #   end
    # end
end
