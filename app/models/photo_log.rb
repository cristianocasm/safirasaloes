# == Schema Information
#
# Table name: photo_logs
#
#  id                 :integer          not null, primary key
#  customer_id        :integer
#  schedule_id        :integer
#  safiras            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  description        :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  posted             :boolean          default(FALSE)
#

class PhotoLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :schedule

  validates_presence_of :customer_id
  validates_presence_of :schedule_id

  has_attached_file :image, :styles => { :small => "80x80>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /(\.|\/)(gif|jpe?g|png|tiff)$/i

  scope :not_posted, -> { 
                          includes(schedule: [:professional]).
                          joins(:schedule).
                          where(posted: false).
                          where("schedules.datahora_inicio >= ? AND schedules.datahora_inicio <= ?",
                            12.hours.ago,
                            Time.zone.now
                          )
                        }

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "description" => read_attribute(:description),
      "thumbnail_url" => image.url(:small),
      "posted" => read_attribute(:posted),
      "delete_url" => photo_log_path(self),
      "delete_type" => "DELETE" 
    }
  end

  def submit_to_fb
    self.
      customer.
      facebook.
      put_picture(
        self.image.path,
        # { :message => self.schedule.professional.append_professional_info + self.get_description }
        { :message => Professional.first.append_professional_info + self.get_description }
      )
    self.update_attribute(:posted, true)
    self
  end

  def get_description
    self.description.present? ? "---\n#{self.description}" : ""
  end
end
