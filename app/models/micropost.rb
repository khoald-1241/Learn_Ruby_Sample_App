class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :content, presence: true, length: {maximum: Settings.db.lenght_256}
  validates :image, content_type: {in: Settings.post.img_format,
                                   message: I18n.t("mess_img_format")},
                    size:         {less_than: Settings.post.items_5.megabytes,
                                   message: I18n.t("mess_img_size")}

  # scope sắp xếp mới đến cũ
  scope :newest, ->{order(created_at: :desc)}
  # scope lấy post của người dùng và người mà người dùng follow
  scope :all_home_post, ->(ids){where user_id: ids}

  def display_image
    image.variant resize_to_limit: Settings.post.img_range_500
  end
end
