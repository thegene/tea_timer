require File.join(LIB_ROOT, "steep")

RSpec.describe Steep do
  context "Given a steep with length of 30" do
    subject { described_class.new(length: 30) }

    describe "#start" do
      before do
        allow(subject)
          .to receive(:sleep)
      end

      it "sleeps for 1 second three times" do
        expect(subject)
          .to receive(:sleep)
          .with(1)
          .exactly(30).times

        subject.start
      end
    end
  end
end
