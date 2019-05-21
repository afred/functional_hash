require "spec_helper"

RSpec.describe FunctionalHash do
  it "has a version number" do
    expect(FunctionalHash::VERSION).not_to be nil
  end

  subject { described_class.new }

  context 'accessing a value with square brackets, []' do

    it 'returns nil if not set yet, just like a regular hash' do
      expect(subject[:does_not_exist]).to eq nil
    end

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

  describe '.enable!' do
    before { FunctionalHash.enable! }
    it 'monkey patches Hash to add Hash#fn instance method' do
      expect({}).to respond_to :fn
    end
    after { FunctionalHash.disable! }
  end

  describe 'Hash#fn (after calling FunctionalHash.enable!)' do
    let(:regular_hash) { { a: -> { "hey there!" } } }
    before { FunctionalHash.enable! }
    it 'returns a FunctionalHash copy of the hash' do
      expect(regular_hash.fn[:a]).to eq "hey there!"
    end
    after { FunctionalHash.disable! }
  end

  describe '.from_hash' do
    let(:not_hash) { double('Not Hash').tap { |d| allow(d).to receive(:is_a?).with(Hash).and_return(false) } }
    let(:hash) { { scalar: "foo", obj: Struct.new(:bar).new('value of bar') } }
    let(:fhash) { FunctionalHash.from_hash(hash) }

    it 'raises an error if the param is not Hash-like' do
      expect { FunctionalHash.from_hash(not_hash) }.to raise_error ArgumentError
    end

    it 'creates a FunctionalHash from a Hash' do
      expect(fhash).to be_a FunctionalHash
    end

    it 'copies all values from Hash to FunctionalHash' do
      expect(fhash.to_hash).to eq hash
    end

    it 'does not contain references to original Hash values' do
      expect(fhash[:obj].bar).to eq hash[:obj].bar
      hash[:obj].bar = "new value"
      expect(fhash[:obj].bar).to_not eq hash[:obj].bar
    end
  end
end
