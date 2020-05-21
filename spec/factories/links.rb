# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'Wikipedia' }
    description { 'Wikipedia es una página llena de recursos de aprendizaje' }
    url { 'https://es.wikipedia.org' }
    video
  end
end
