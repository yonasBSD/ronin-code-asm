require 'spec_helper'

require 'ronin/asm/instruction'
require 'ronin/asm/register'
require 'ronin/asm/literal'

describe Instruction do
  let(:register) { Register.new(:eax, 4) }
  let(:literal)  { Literal.new(0xff, 1)  }

  describe "#initialize" do
    let(:name)     { :mov }
    let(:operands) { [literal, register] }

    subject { described_class.new(name,operands) }

    it "should set the name" do
      subject.name.should == :mov
    end

    it "should set the operands" do
      subject.operands.should == operands
    end

    context "when given an Integer operand" do
      let(:integer) { 0xff }

      subject { described_class.new(name, [integer, register]) }

      it "should wrap the operand to in a Literal" do
        subject.operands[0].should be_kind_of(Literal)
        subject.operands[0].value.should == integer
      end
    end

    context "when given a nil operand" do
      subject { described_class.new(name, [nil, register]) }

      it "should wrap the operand to in a Literal" do
        subject.operands[0].should be_kind_of(Literal)
        subject.operands[0].value.should == 0
      end
    end
  end

  describe "#width" do
    subject { described_class.new(:mov, [literal, register]) }

    it "should return the maximum width of the operands" do
      subject.width.should == register.width
    end

    context "when one of the operands does not define #width" do
      subject { described_class.new(:mov, [:label, register]) }

      it "should ignore them" do
        subject.width.should == register.width
      end
    end
  end
end
