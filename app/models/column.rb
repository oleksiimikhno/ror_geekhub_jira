# == Schema Information
#
# Table name: columns
#
#  id             :bigint           not null, primary key
#  name           :text
#  ordinal_number :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  desk_id        :bigint           not null
#
# Indexes
#
#  index_columns_on_desk_id  (desk_id)
#
# Foreign Keys
#
#  fk_rails_...  (desk_id => desks.id)
#
class Column < ApplicationRecord
  belongs_to :desk
  has_many :tasks # https://github.com/rubysherpas/paranoia

  validates :name, presence: true, length: { in: 3..14 }
  # presence: true, allow_blank: true
  validates :ordinal_number, presence: true, numericality: { only_integer: true }, allow_blank: true
end
