---
title: RSpec and RSpec::Expectations
date: '2012-08-05'
description: RSpec 笔记和索引
categories: 我的程序
tags: [ruby, rspec]

---

## Describe
`describe` and `context` is **alias**

    describe User, "with no roles assigned" { ... } 
    => User with no roles assigned

## It
`specify()` is alias of `it()`

    describe "A new chess board" do
      before(:each) { @board = Chess::Board.new }
      specify { @board.should have(32).pieces }
    end

## Pending

There are three method to pending test

1. pending with no block

        describe Newspaper do
        it "should be read all over" # pending here
        end

1. pending in example

        describe "onion rings" do
        it "should not be mixed with french fries" do
            pending "cleaning out the fryer"
            fryer_with(:onion_rings).should_not include(:french_fry)
        end end

1. pending in block and fail (mark for bug)

        describe "an empty array" do
            it "should be empty" do
                pending("bug report 18976") do
                  [].should be_empty
                end
            end
        end

## Hooks

1. `before(:each)`, `before(:all)`
1. `after(:each)`, `after(:all)`
1. `around(:each)`

        around do |example|
            DB.transaction &example
        end

    > rollback database each time

        around do |example|
            DB.transaction do
                example.run
                raise Sequel::Rollback
            end
        end

## Helper Methods

    describe Thing do
      def given_thing_with(options)
        yield Thing.new do |thing|
          thing.set_status(options[:status])
        end
      end

      it "should do something when ok" do
        given_thing_with(:status => 'ok') do |thing|
          thing.do_fancy_stuff(1, true, :move => 'left', :obstacles => nil)
          ...
        end
      end

      it "should do something else when not so good" do
        given_thing_with(:status => 'not so good') do |thing|
          thing.do_fancy_stuff(1, true, :move => 'left', :obstacles => nil)
          ...
        end
      end
    end

## Shared Example

1. Set up shared example with the `shared_examples_for()` method

        shared_examples_for "any pizza" do
          it "tastes really good" do
            @pizza.should taste_really_good
          end

          it "is available by the slice" do
            @pizza.should be_available_by_the_slice
          end
        end

1. Used in other example group with the `it_behaves_like()` method

        describe "New York style thin crust pizza" do
          before(:each) do
            @pizza = Pizza.new(:region => 'New York', :style => 'thin crust')
          end

          it_behaves_like "any pizza"

          it "has a really great sauce" do
            @pizza.should have_a_really_great_sauce
          end
        end

        describe "Chicago style stuffed pizza" do
          before(:each) do
            @pizza = Pizza.new(:region => 'Chicago', :style => 'stuffed')
          end

          it_behaves_like "any pizza"

          it "has a ton of cheese" do
            @pizza.should have_a_ton_of_cheese
          end
        end

1. That produces this

        New York style thin crust pizza
          has a really great sauce
          behaves like any pizza
            tastes really good
            is available by the slice
        Chicago style stuffed pizza
          has a ton of cheese
          behaves like any pizza
            tastes really good
            is available by the slice

## Matchers

    prime_numbers.should_not include(8)
    list.should respond_to(:length)
    lambda { Object.new.explode! }.should raise_error(NameError)
    a.should == b
    a.should === b
    a.should eql(b)
    a.should equal(b)

> Do not use `should !=`, use `should_not ==`

### Floating-Point Calc

    result.should be_close(5.25, 0.005)

### Changes

    expect { User.create!(:role => "admin") }.to change{ User.admins.count }
    expect { User.create!(:role => "admin") }.to change{ User.admins.count }.by(1)
    expect { User.create!(:role => "admin") }.to change{ User.admins.count }.to(1)
    expect { User.create!(:role => "admin") }.to change{ User.admins.count }.from(0).to(1)

### Expect Errors

#### with Error Type and Message Match(in String or RegEx)

    account = Account.new 50, :dollars
    expect {
      account.withdraw 75, :dollars
    }.to raise_error(
      InsufficientFundsError,
      /attempted to withdraw 75 dollars from an account with 50 dollars/
    )

#### Or with No Args

    expect { do_something_risky }.to raise_error

### Expect a Throw

    course = Course.new(:seats => 20)
    20.times { course.register Student.new }
    lambda {
      course.register Student.new
    }.should throw_symbol(:course_full)

### Predicate Matchers

    array.empty?.should == true
    # is equivalent of
    array.should be_empty

#### Can Receive Args

     user.should be_in_role("admin")

### Collections

    collection.should have(37).items
    "this string".should have(11).characters
    day.should have_exactly(24).hours
    dozen_bagels.should have_at_least(12).bagels
    internet.should have_at_most(2037).killer_social_networking_apps

> `have_exactly()` is alias of `have()`

### Subjectivity

    describe Person do
      subject { Person.new(:birthdate => 19.years.ago) }
      specify { subject.should be_eligible_to_vote }
    end
