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
FactoryBot.define do
  factory :document do
    documentable { build(:video) }
    language { 'es' }
    content { 'This is a document' }
  end

  factory :transcription do
    documentable { build(:video) }
    language { 'es' }
    content { 'This is the transcription of a video' }
  end

  factory :show_note do
    documentable { build(:video) }
    language { 'es' }
    content { 'These are the shownotes of a video' }
  end
end
