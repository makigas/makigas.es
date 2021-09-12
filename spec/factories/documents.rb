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
end
