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

require 'test_helper'

class PhotoLogTest < ActiveSupport::TestCase
  should validate_presence_of(:customer_id)
  should validate_presence_of(:schedule_id)
  should belong_to(:customer)
  should belong_to(:schedule)
  should have_db_column(:safiras)

  setup do
    @pl = PhotoLog.create
  end
  test "na criação, define 'posted' como false" do
    assert_equal false, @pl.posted
  end

  test "na criação, define 'prof_info_allowed' como false" do
    assert_equal false, @pl.prof_info_allowed
  end
end
