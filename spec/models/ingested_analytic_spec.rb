# == Schema Information
#
# Table name: ingested_analytics
#
#  id         :bigint           not null, primary key
#  day        :date             not null
#  document   :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ingested_analytics_on_day  (day)
#
require 'rails_helper'

RSpec.describe IngestedAnalytic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
