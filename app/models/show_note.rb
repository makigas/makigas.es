# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id                :bigint           not null, primary key
#  content           :text             default("")
#  documentable_type :string
#  language          :string           not null
#  type              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :bigint
#
# Indexes
#
#  index_documents_on_documentable  (documentable_type,documentable_id)
#  index_documents_on_type          (type)
#
class ShowNote < Document
  after_destroy :index_documentable
  after_save :index_documentable

  def index_documentable
    documentable.save
  end
end
