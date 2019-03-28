# frozen_string_literal: true

require 'rails_helper'

shared_examples_for "taggable" do
  it "has tags" do
    expect(subject.tags).to be_a(Array)
    expect(subject.tags).not_to be_empty
  end

  it "makes tags unique" do
    subject.tags = ["foo", "bar", "foo"]
    expect(subject.tags).to eql(["foo", "bar"])
  end

  it "handles tags passed as strings" do
    subject.tags = "foo, bar"
    expect(subject.tags).to eql(["foo", "bar"])
  end
end
