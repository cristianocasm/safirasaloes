# == Schema Information
#
# Table name: statuses
#
#  id            :integer          not null, primary key
#  nome          :string(255)
#  descricao     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  dias_vigencia :integer
#

class Status < ActiveRecord::Base
end
