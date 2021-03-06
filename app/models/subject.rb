#encoding: utf-8
# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  content     :text
#  user_id     :integer
#  chapter_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lastcomment :datetime
#  admin       :boolean
#  important   :boolean
#  section_id  :integer
#  wepion      :boolean
#  category_id :integer
#  exercise_id :integer
#

class Subject < ActiveRecord::Base
  attr_accessible :content, :title, :lastcomment, :admin, :important, :wepion

  # BELONGS_TO, HAS_MANY

  has_many :messages, dependent: :destroy
  belongs_to :user
  belongs_to :chapter
  belongs_to :section
  belongs_to :category
  belongs_to :exercise
  belongs_to :qcm
  has_many :followingsubjects, dependent: :destroy
  has_many :following_users, through: :followingsubjects, source: :user
  has_many :subjectfiles, dependent: :destroy
  has_many :fakesubjectfiles, dependent: :destroy

  # VALIDATIONS

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 8000 }
  validates :user_id, presence: true
  validates :lastcomment, presence: true
end
