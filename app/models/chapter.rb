#encoding: utf-8
# == Schema Information
#
# Table name: chapters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  level       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  online      :boolean          default(FALSE)
#  section_id  :integer
#

class Chapter < ActiveRecord::Base
  attr_accessible :description, :level, :name, :online
  
  # BELONGS_TO, HAS_MANY
  
  belongs_to :section # Chaque chapitre appartient à une unique section
  has_and_belongs_to_many :users, -> { uniq } # Pour retenir quel utilisateur a débloqué quel chapitre
  has_and_belongs_to_many :problems, -> { uniq } # Pour savoir les prérequis de tel problème
  
  # Un chapitre a des théories, exercices et qcms
  has_many :theories, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :qcms, dependent: :destroy
  
  # Prérequis des chapitres
  has_many :prerequisites_associations, class_name: "Prerequisite", dependent: :destroy
  has_many :prerequisites, through: :prerequisites_associations

  has_many :backwards_associations, class_name: "Prerequisite", dependent: :destroy, foreign_key: :prerequisite_id
  has_many :backwards, through: :backwards_associations, source: :chapter
    
  # VALIDATIONS
    
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :description, length: { maximum: 8000 }
  validates :level, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  # Nombre de prérequis (avec récursion) sans compter les fondements
  def real_number_prerequisites
    liste = recursive_prerequisites
    Chapter.all.each do |c|
      if c.section.fondation
        liste.delete(c.id)
      end
    end
    return liste.size
  end
  
  # Nombre de prérequis (avec récursion)
  def number_prerequisites
    return recursive_prerequisites.size
  end
  
  # Rend les chapitres qui ne sont pas déjà prérequis de celui-ci
  def available_prerequisites
    exceptions = self.recursive_prerequisites + [self.id]
    # exceptions is never empty so the following line works
    Chapter.where("id NOT IN(?)", exceptions)
  end
  
  # Calcule tous les prérequis (avec récursion) du chapitre
  def recursive_prerequisites
    visited = Set.new
    recursive_prerequisites_aux(self, visited)
    visited.delete(self.id)
    visited.to_a
  end
  
  # Met le chapitre en LaTeX (beta)
  def to_tex
    content = "\\section{#{name}}\n"
    content << theories.order(:position).inject("") do |sum, theory|
      "#{sum}\n#{theory.to_tex}"
    end
    content
  end

  private
  
  # Auxiliaire à recursive_prerequisites
  def recursive_prerequisites_aux(current, visited)
    unless visited.include?(current.id)
      # this should always happen since it shouldn't have loop or be redundant
      visited.add(current.id)
      current.prerequisites.each do |next_chapter|
        recursive_prerequisites_aux(next_chapter, visited)
      end
    end
  end
end
