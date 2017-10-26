require "spec_helper"

RSpec.describe FunctionalHash do
  it "has a version number" do
    expect(FunctionalHash::VERSION).not_to be nil
  end

  subject { described_class.new }

  context 'accessing a value with square brackets, []' do
    context 'when the value is a Proc with 0 arguments' do
      let(:rando) { rand }
      before do
        subject[:foo] = -> { rando }
      end

      it 'returns the value of the called Proc' do
        expect(subject[:foo]).to eq rando
      end
    end

    context 'when the value is a Proc with 1 argument' do
      before do
        subject[:foo] = -> (x) {  }
      end

      it 'is called with the FunctionalHash instance as the parameter, and returns the value' do
        expect(subject.fetch(:foo)).to receive(:call).with(subject).exactly(1).times
        subject[:foo]
      end
    end

    context 'when the value is a Proc with multiple arguments' do
      before do
        subject[:foo] = -> (s, x, y, z) {  }
      end

      it 'is called with the FunctionalHash instance as the first parameter,
      and subsequent parameters with in the squre brackets [] as the following
      parameters' do
        expect(subject.fetch(:foo)).to receive(:call).with(subject, 1, 2, 3).exactly(1).times
        subject[:foo, 1, 2, 3]
      end
    end
  end
end
