class Device < ApplicationRecord
  serialize :tags, coder: YAML
  belongs_to :user
  has_many :reports, dependent: :destroy
end
