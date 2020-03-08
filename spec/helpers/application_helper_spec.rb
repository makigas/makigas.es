require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#running_time' do
    it 'renders seconds' do
      expect(running_time 45).to eq '0:45'
    end

    it 'renders a minute' do
      expect(running_time 60).to eq '1:00'
    end

    it 'renders minutes' do
      expect(running_time 85).to eq '1:25'
    end

    it 'renders more than 10 minutes' do
      expect(running_time 685).to eq '11:25'
    end

    it 'renders an hour' do
      expect(running_time 3600). to eq '1:00:00'
    end

    it 'renders hours' do
      expect(running_time 4625).to eq '1:17:05'
    end
  end

  describe '#parsing_time' do
    it 'parses H:MM:SS' do
      expect(extract_time '1:17:05').to eq 4625
    end

    it 'parses HH:MM:SS' do
      expect(extract_time '01:17:05').to eq 4625
    end

    it 'parses M:SS' do
      expect(extract_time '1:25').to eq 85
    end

    it 'parses MM:SS' do
      expect(extract_time '01:25').to eq 85
    end

    it 'parses S' do
      expect(extract_time '9').to eq 9
    end

    it 'parses 0S' do
      expect(extract_time '09').to eq 9
    end

    it 'parses SS' do
      expect(extract_time '45').to eq 45
    end

    it 'allows non start by zero' do
      expect(extract_time '1:17:05').to eq 4625
      expect(extract_time '1:25').to eq 85
    end

    it 'does not allow non start by zero inside' do
      expect(extract_time '1:2:01').to eq nil
      expect(extract_time '1:02:1').to eq nil
      expect(extract_time '1:2').to eq nil
    end

    it 'does not allow invalid minutes' do
      expect(extract_time '78:59').to eq nil
      expect(extract_time '2:78:59').to eq nil
    end

    it 'does not allow invalid seconds' do
      expect(extract_time '1:81').to eq nil
      expect(extract_time '2:01:81').to eq nil
    end
  end
end
