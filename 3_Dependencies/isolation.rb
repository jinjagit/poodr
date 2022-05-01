# When Gear is part of an external interface
module SomeFramework
  class Gear
    attr_reader :chainring, :cog, :wheel

    # Note not using keyword args, and assume we have no control over this external code
    def initialize(chainring, cog, wheel)
      @chainring = chainring
      @cog       = cog
      @wheel     = wheel
    end

    def gear_inches
      ratio * wheel.diameter
    end

    def ratio
      chainring / cog.to_f
    end
  end
end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim       = rim
    @tire      = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end
end

# Wrap the interface to protect yourself from changes
#
# Using a module here lets you define a separate and distinct object to which you can send the gear message
# while simultaneously conveying the idea that you don’t expect to have instances of GearWrapper.
# Its sole purpose is to create instances of some other class.
# Object-oriented designers have a word for objects like this; they call them 'factories'.
module GearWrapper
  def self.gear(chainring:, cog:, wheel:)
    SomeFramework::Gear.new(chainring, cog, wheel)
  end
end

# Now you can create a new Gear using keyword arguments
puts GearWrapper.gear(
  chainring: 52,
  cog: 11,
  wheel: Wheel.new(26, 1.5)
).gear_inches
# => 137.0909090909091
