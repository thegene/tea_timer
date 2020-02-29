require File.join(LIB_ROOT, "step")

require "logger"

RSpec.describe Step do
  context "Given a step with length of 30 and a logger" do
    subject { described_class.new(length: 30, logger: mock_logger) }

    let(:mock_logger) { instance_double(Logger, info: nil) }

    describe "#run" do
      before do
        allow(subject)
          .to receive(:sleep)
      end

      it "sleeps for 1 second three times" do
        expect(subject)
          .to receive(:sleep)
          .with(1)
          .exactly(30).times

        subject.run
      end

      it "logs every ten seconds" do
        expect(mock_logger)
          .to receive(:info)
          .with("30")
          .once
          .ordered

        expect(mock_logger)
          .to receive(:info)
          .with("20")
          .once
          .ordered

        expect(mock_logger)
          .to receive(:info)
          .with("10")
          .once
          .ordered

        expect(mock_logger)
          .to receive(:info)
          .with("done")
          .once
          .ordered

        subject.run
      end
    end
  end
end
