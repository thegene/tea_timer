require File.join(LIB_ROOT, "session")
require File.join(LIB_ROOT, "steep")

require "logger"

RSpec.describe Session do
  context "Given a session with a logger and a plan" do
    subject { described_class.new(plan: plan, logger: mock_logger) }

    let(:mock_logger) { instance_double(Logger, info: nil) }
    let(:plan) { double(:plan, config: config) }

    let(:first_steep) { instance_double(Steep) }
    let(:second_steep) { instance_double(Steep) }


    describe "#next" do
      context "with a single step of 20 seconds" do
        let(:config) {[{
          length: 20
        }]}

        it "creates a steep of 20 seconds" do
          expect(Steep)
            .to receive(:new)
            .with(length: 20, logger: mock_logger)
            .and_return(first_steep)

          expect(first_steep)
            .to receive(:start)
            .once

          subject.next

        end

        context "when we run next a second time" do

          it "uses the single step again" do
            expect(Steep)
              .to receive(:new)
              .with(length: 20, logger: mock_logger)
              .once
              .ordered
              .and_return(first_steep)

            expect(first_steep)
              .to receive(:start)
              .once
              .ordered

            expect(Steep)
              .to receive(:new)
              .with(length: 20, logger: mock_logger)
              .once
              .ordered
              .and_return(second_steep)

            expect(second_steep)
              .to receive(:start)
              .once
              .ordered

            subject.next
            subject.next
          end
        end
      end

      context "with two steps" do
        let(:config) {[
          {
            length: 7
          },
          {
            length: 3
          }
        ]}

        it "runs through them in order" do
          expect(Steep)
            .to receive(:new)
            .with(length: 7, logger: mock_logger)
            .once
            .ordered
            .and_return(first_steep)

          expect(first_steep)
            .to receive(:start)
            .once
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 3, logger: mock_logger)
            .once
            .ordered
            .and_return(second_steep)

          expect(second_steep)
            .to receive(:start)
            .once
            .ordered

          subject.next
          subject.next
        end
      end

      context "with steps that have count and increment" do
        before do
          allow(Steep)
            .to receive(:new)
            .and_return(mock_steep)
        end

        let(:config) {[
          {
            length: 3,
            count: 2,
          },
          {
            increment: 10,
            count: 2
          },
          {
            length: 9
          }
        ]}

        let(:mock_steep) { instance_double(Steep, start: nil) }

        it "increments the last step by increment amount count times" do
          expect(Steep)
            .to receive(:new)
            .with(length: 3, logger: mock_logger)
            .exactly(2).times
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 13, logger: mock_logger)
            .once
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 23, logger: mock_logger)
            .once
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 9, logger: mock_logger)
            .once
            .ordered

          5.times { subject.next }
        end
      end
    end
  end
end
