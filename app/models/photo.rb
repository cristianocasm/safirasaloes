# == Schema Information
#
# Table name: photos
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  description            :text
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  customer_invitation_id :integer
#

class Photo < ActiveRecord::Base
  # belongs_to :customer
  # belongs_to :schedule

  belongs_to :professional
  belongs_to :customer_invitation
  has_one :reward

  # # validates_presence_of :customer
  # validates_presence_of :schedule

  has_attached_file :image, :styles => { :small => "80x80>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /(\.|\/)(gif|jpe?g|png|tiff)$/i

  # scope :not_posted, -> { 
  #                         joins(:schedule).
  #                         where(posted: false).
  #                         where("schedules.datahora_inicio >= ? AND schedules.datahora_inicio <= ?",
  #                           12.hours.ago,
  #                           Time.zone.now
  #                         )
  #                       }

  # scope :find_not_posted_by_ids_and_schedule, -> (ids, schedule_id) { where(id: ids, schedule_id: schedule_id, posted: false) }

  def to_jq_upload
    {
      "id" => self.id,
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "description" => read_attribute(:description),
      "thumbnail_url" => image.url(:small),
      "delete_url" =>  Rails.application.routes.url_helpers.photo_path(self),
      "delete_type" => "DELETE"
    }
  end

  # def submit_to_fb(prof)
  #   rst = self.customer.facebook.put_picture(image.path, :message => gen_msg(prof))
  #   self.tap { |o| o.update_attribute(:posted, true) } if rst.has_key?('post_id')
  # end

  # def gen_msg(prof)
  #   desc = self.description.present? ? "---\n#{self.description}" : ""
  #   prof.contact_info + desc
  # end
end
