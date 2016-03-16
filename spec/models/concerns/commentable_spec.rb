require 'rails_helper'

shared_examples_for "commentable" do
  let(:model) { described_class }

  it { should have_many(:comments).dependent(:destroy) }
end
