require File.join(LIB_ROOT, "session")
require File.join(LIB_ROOT, "steep")

RSpec.describe Session do
  context "Given a session with a plan" do
    subject { described_class.new(plan: plan) }

    let(:first_steep) { instance_double(Steep) }
    let(:second_steep) { instance_double(Steep) }


    describe "#next_steep" do
      context "with a single step of 20 seconds" do
        let(:plan) {[{
          length: 20
        }]}

        it "creates a steep of 20 seconds" do
          expect(Steep)
            .to receive(:new)
            .with(length: 20)
            .and_return(first_steep)

          expect(subject.next_steep)
            .to eq(first_steep)
        end

        context "when we run next_steep a second time" do

          it "uses the single step again" do
            expect(Steep)
              .to receive(:new)
              .with(length: 20)
              .once
              .ordered
              .and_return(first_steep)

            expect(Steep)
              .to receive(:new)
              .with(length: 20)
              .once
              .ordered
              .and_return(second_steep)

            expect(subject.next_steep)
              .to eq(first_steep)

            expect(subject.next_steep)
              .to eq(second_steep)
          end
        end
      end

      context "with two steps" do
        let(:plan) {[
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
            .with(length: 7)
            .once
            .ordered
            .and_return(first_steep)

          expect(Steep)
            .to receive(:new)
            .with(length: 3)
            .once
            .ordered
            .and_return(second_steep)

          subject.next_steep
          subject.next_steep
        end
      end

      context "with steps that have count and increment" do
        before do
          allow(Steep)
            .to receive(:new)
            .and_return(mock_steep)
        end

        let(:plan) {[
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
            .with(length: 3)
            .exactly(2).times
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 13)
            .once
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 23)
            .once
            .ordered

          expect(Steep)
            .to receive(:new)
            .with(length: 9)
            .once
            .ordered

          5.times { subject.next_steep }
        end
      end
    end
  end
end
