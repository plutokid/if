require "spec_helper"

describe IF::EntityContext do
  it_behaves_like "context"
  
  include ContextHelper
  
  before :each do
    new_story
  end
  
  describe "#children" do
    it "returns all objects" do
      envelope = object_context :envelope
      envelope.children.count.should eq 2
      envelope.children.should eq [object_context(:letter), object_context(:key)]
    end
  end
  
  describe "#objects" do
    it "returns empty array" do
      picture = object_context :picture
      picture.objects.should be_empty
    end
  end
  
  describe "#child_objects" do
    before do
      @story = IF::Story.new do
        room :room, "Rooms" do
          object :foo, "Foo" do
            object :bar, "Bar"
            object :baz, "Baz" do
              object :fizz, "Fizz"
              object :buzz, "Buzz"
              
              actions do
                def objects
                  children
                end
              end
            end
          end
        end
      end
    end
    
    it "returns all objects and their visible objects" do
      foo = object_context :foo
      foo.child_objects.count.should eq 4
      foo.child_objects[0].should eq object_context :bar
      foo.child_objects[1].should eq object_context :baz
      foo.child_objects[2].should eq object_context :fizz
      foo.child_objects[3].should eq object_context :buzz
    end
  end
  
  it "can get id" do
    key = object_context :key
    key.id.should eq :key
  end
  
  it "can get name" do
    envelope = object_context :envelope
    envelope.name.should eq "Envelope"
  end
  
  it "can get description" do
    key = object_context :key
    key.description.should eq "A safe key"
  end
  
  it "can check for contained object by id" do
    bin = object_context :trash_bin
    
    bin.contains?(:trash).should be_true
  end
  
  it "can check for contained object by context" do
    bin = object_context :trash_bin
    trash = object_context :trash
    
    bin.contains?(trash).should be_true
  end
end