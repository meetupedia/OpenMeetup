# encoding: UTF-8

class WaveNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :wave
end
