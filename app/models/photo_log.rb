# == Schema Information
#
# Table name: photo_logs
#
#  id              :integer          not null, primary key
#  customer_id     :integer
#  professional_id :integer
#  schedule_id     :integer
#  service_id      :integer
#  safiras         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class PhotoLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :schedule

  validates_presence_of :customer_id
  validates_presence_of :schedule_id

  has_attached_file :image, :styles => { :small => "150x150>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 4.megabytes
  validates_attachment_content_type :image, :content_type => /(\.|\/)(gif|jpe?g|png|tiff)$/i

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "delete_url" => photo_log_path(self),
      "delete_type" => "DELETE" 
    }
  end
end
