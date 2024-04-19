class Device < ApplicationRecord
  self.primary_key = :uuid
  serialize :tags, coder: YAML
  belongs_to :user, optional: true
  has_many :reports, dependent: :destroy
end
