class DefaultRuleRoom < ApplicationRecord
	belongs_to :room
	belongs_to :default_rule
end
