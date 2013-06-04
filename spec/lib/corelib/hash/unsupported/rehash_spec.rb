require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Hash#rehash", ->
  it "reorganizes the hash by recomputing all key hash codes", ->
    k1 = [1]
    k2 = [2]
    h = new_hash
    h[k1] = 0
    h[k2] = 1

    k1 << 2
    h.key?(k1).should == false
    h.keys.include?(k1).should == true

    h.rehash.should equal(h)
    h.key?(k1).should == true
    h[k1].should == 0

    k1 = mock('k1')
    k2 = mock('k2')
    v1 = mock('v1')
    v2 = mock('v2')

    v1.should_not_receive(:hash)
    v2.should_not_receive(:hash)

    h = new_hash(k1 => v1, k2 => v2)

    k1.should_receive(:hash).twice.and_return(0)
    k2.should_receive(:hash).twice.and_return(0)

    h.rehash
    h[k1].should == v1
    h[k2].should == v2

  ruby_version_is ""..."1.9", ->
    it "raises a TypeError if called on a frozen instance", ->
      lambda { HashSpecs.frozen_hash.rehash  }.should raise_error(TypeError)
      lambda { HashSpecs.empty_frozen_hash.rehash }.should raise_error(TypeError)

  ruby_version_is "1.9", ->
    it "raises a RuntimeError if called on a frozen instance", ->
      lambda { HashSpecs.frozen_hash.rehash  }.should raise_error(RuntimeError)
      lambda { HashSpecs.empty_frozen_hash.rehash }.should raise_error(RuntimeError)
  end
