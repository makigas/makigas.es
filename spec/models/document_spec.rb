# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'factory' do
    it 'is valid' do
      expect(build(:document)).to be_valid
    end
  end

  describe 'validation' do
    it 'is not valid without a language' do
      expect(build(:document, language: nil)).not_to be_valid
    end

    it 'is not valid without a documentable' do
      expect(build(:document, documentable: nil)).not_to be_valid
    end
  end

  describe 'relationship' do
    it 'belongs to a documentable' do
      expect(build(:document)).to respond_to(:documentable)
    end
  end

  describe 'transcription' do
    it 'is a type of document' do
      expect(build(:transcription).type).to eq('Transcription')
    end
  end
end
