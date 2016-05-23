class Plan < ActiveRecord::Base
  extend Enumerize

  has_many    :subscriptions

  # Initialize the plan object
  @@plan ||= {
    ammount: 1500,
    currency: "usd",
    interval: "month",
    interval_count: 1,
    name: "basic",
    trial_period_days: nil
  }

  enumerize :name, in: [:basic], default: :basic, scope: :having_name, predicates: true
  enumerize :interval, in: [:week, :month, :year], default: :month, scope: :having_interval, predicates: true

  class << self
    def get_basic_plan
      find_or_create_by @@plan
    end
  end
end