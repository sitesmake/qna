shared_examples_for "private_pub" do
	it "publishing to channel" do
		expect(PrivatePub).to receive(:publish_to).with(channel, kind_of(Hash))
		req
	end
end