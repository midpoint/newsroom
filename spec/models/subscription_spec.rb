# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { FactoryBot.build(:subscription) }

  it_behaves_like "taggable"
end
