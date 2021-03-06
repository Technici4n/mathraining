#encoding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_base_chapter
    make_algebra_chapter
    make_geometry_chapter
    make_users_solve_exercises
  end
end

def make_users
  # Admin
  User.create!(first_name: 'Admin',
               last_name: 'Admin',
               email: 'admin@admin.com',
               password: 'foobar',
               password_confirmation: 'foobar',
               admin: true)
  # Root
  User.create!(first_name: 'Root',
               last_name: 'Root',
               email: 'root@root.com',
               password: 'foobar',
               password_confirmation: 'foobar',
               admin: true,
               root: true)
  # Student
  User.create!(first_name: 'Jean',
               last_name: 'Dupont',
               email: 'jean@dupont.com',
               password: 'foobar',
               password_confirmation: 'foobar')
  (1..20).each do |i|
    User.create!(first_name: "Etu",
                 last_name: "Diant#{i}",
                 email: "etu@diant#{i}.com",
                 password: "foobar",
                 password_confirmation: "foobar")
  end
end

def make_base_chapter
  base = Chapter.create!(name: 'Base de la base',
                         description: 'C\'est vraiment la base !',
                         level: 0,
                         online: true)
  base.theories << Theory.create!(title: 'Addition',
                                  content: 'L\'addition (e.g. $1 + 2$) est <i>associative</i> et <i>commutative</i>.',
                                  position: 1,
                                  online: true)
  base.theories << Theory.create!(title: 'Multiplication',
                                  content: 'La multiplication (e.g. $6 \times 7$) est <i>associative</i> et <i>commutative</i>.',
                                  position: 2,
                                  online: true)
  base.theories << Theory.create!(title: 'Division',
                                  content: 'La division (e.g. $12 / 3$) est considérée comme l\'opération opposée à la multiplication.',
                                  position: 3,
                                  online: true)
  base.exercises << Exercise.create!(statement: 'Que vaut $3 + 5$?',
                                     answer: 8,
                                     decimal: false,
                                     position: 1,
                                     explanation: "Il suffit d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  base.exercises << Exercise.create!(statement: 'Que vaut $3.24 \times 10$?',
                                     answer: 32.4,
                                     decimal: true,
                                     position: 2,
                                     explanation: "Il suffit encore une fois d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  base.exercises << Exercise.create!(statement: 'Que vaut $6 / 3$?',
                                     answer: 2,
                                     decimal: false,
                                     position: 3,
                                     explanation: "",
                                     online: false)
  base.qcms << Qcm.create!(statement: 'Lesquelles de ces opérations donnent $3$?',
                           many_answers: true,
                           position: 4,
                           online: true,
                           explanation: "C'est évident.")

  Choice.create!(ans: "$5-2$", ok: true, qcm_id: base.qcms.first.id)
  Choice.create!(ans: "$6/2$", ok: true, qcm_id: base.qcms.first.id)
  Choice.create!(ans: "$12/3$", ok: false, qcm_id: base.qcms.first.id)
  Choice.create!(ans: "$2+2$", ok: false, qcm_id: base.qcms.first.id)

  base.exercises << Exercise.create!(statement: 'Que vaut $5 - 2$?',
                                     answer: 3,
                                     decimal: false,
                                     position: 5,
                                     explanation: "",
                                     online: true)
  base.problems << Problem.create!(name: 'Neutre',
                                  statement: 'Prouver que $0$ est neutre pour l\'addition',
                                  position: 1,
                                  online: true,
                                  level: 1)
end

def make_algebra_chapter
  algebre = Chapter.create!(name: 'Base de l\'algèbre',
                         description: 'C\'est la base de l\'algèbre!',
                         level: 1,
                         online: true)
  sect = Section.where(:name => "Algèbre").first
  algebre.sections << sect
  algebre.theories << Theory.create!(title: 'Racine carrée',
                                  content: 'La racine carrée d\' un nombre réel positif est le nombre réel positif dont le carré vaut ce nombre. On la note $\sqrt{x}$',
                                  position: 1,
                                  online: true)
  algebre.theories << Theory.create!(title: 'Puissance',
                                  content: 'Lorsque l\'on écrit $a^b$, on veut dire que $a \times a \times \dots \times a$, où $a$ apparaît $b$ fois.',
                                  position: 2,
                                  online: true)
  algebre.exercises << Exercise.create!(statement: 'Que vaut $\sqrt{9}$?',
                                     answer: 3,
                                     decimal: false,
                                     position: 1,
                                     explanation: "Il suffit d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  algebre.exercises << Exercise.create!(statement: 'Que vaut $4^3$?',
                                     answer: 64,
                                     decimal: false,
                                     position: 2,
                                     explanation: "Il suffit encore une fois d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  algebre.qcms << (newqcm = Qcm.create!(statement: 'Que vaut $\sqrt{x^4}$ si $x \geq 0$?',
                           many_answers: false,
                           position: 3,
                           online: true,
                           explanation: "C'est évident."))

  Choice.create!(ans: "$x$", ok: false, qcm_id: algebre.qcms.first.id)
  Choice.create!(ans: "$x^2$", ok: true, qcm_id: algebre.qcms.first.id)
  Choice.create!(ans: "$x^4$", ok: false, qcm_id: algebre.qcms.first.id)
  Choice.create!(ans: "$x^8$", ok: false, qcm_id: algebre.qcms.first.id)

  algebre.problems << Problem.create!(name: 'Racine cubique',
                                  statement: 'Définir la racine cubique d\'un élément.',
                                  position: 1,
                                  online: true,
                                  level: 2)
end


def make_geometry_chapter
  geometrie = Chapter.create!(name: 'Angles',
                         description: 'C\'est la base de la géométrie!',
                         level: 1,
                         online: true)
  sect = Section.where(:name => "Géométrie").first
  geometrie.sections << sect
  geometrie.theories << Theory.create!(title: 'Angles inscrits',
                                  content: 'Deux angles inscrits interceptant le même arc ont la même amplitude.',
                                  position: 1,
                                  online: true)
  geometrie.theories << Theory.create!(title: 'Angle inscrit et angle au centre',
                                  content: 'L\'amplitude d\'un angle au centre est égale au double de l\'amplitude d\'un angle inscrit interceptant le même arc.',
                                  position: 2,
                                  online: true)
  geometrie.exercises << Exercise.create!(statement: 'Si un angle inscrit a une amplitude de $30^\circ$, quelle est l\'amplitude en degré de l\'angle au centre interceptant le même arc?',
                                     answer: 60,
                                     decimal: false,
                                     position: 1,
                                     explanation: "Il suffit d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  geometrie.exercises << Exercise.create!(statement: 'Si un angle au centre a une amplitude de $29^\circ$, quelle est l\'amplitude en degré de l\'angle inscrit interceptant le même arc??',
                                     answer: 14.5,
                                     decimal: true,
                                     position: 2,
                                     explanation: "Il suffit encore une fois d'utiliser les règles expliquées dans la théorie.",
                                     online: true)
  geometrie.qcms << (newqcm = Qcm.create!(statement: 'Que peut-on dire de deux angles inscrits interceptant le même arc?',
                           many_answers: false,
                           position: 3,
                           online: true,
                           explanation: "C'est évident."))

  Choice.create!(ans: 'La somme de leur amplitude vaut $180^\circ$', ok: false, qcm_id: geometrie.qcms.first.id)
  Choice.create!(ans: "Ils ont la même amplitude", ok: true, qcm_id: geometrie.qcms.first.id)

  geometrie.problems << Problem.create!(name: 'Angle au centre',
                                  statement: 'Prouver que l\'amplitude d\'un angle au centre est égale au double de l\'amplitude d\'un angle inscrit interceptant le même arc.',
                                  position: 1,
                                  online: true,
                                  level: 1)


end

def make_users_solve_exercises
  (1..20).each do |i|
    user = User.where(:last_name => "Diant#{i}").first
    Exercise.all.each do |e|
      r = rand(1..25)
      if r > i # Solve the exercise
        link = Solvedexercise.new
        link.user = user
        link.exercise = e
        link.nb_guess = rand(1..5)
        link.guess = e.answer
        link.correct = true
        link.created_at = Date.new(2013,3,rand(1..31)).to_time
        link.updated_at = link.created_at
        point_attribution_ex(user, e)
        link.save
      end
    end
    Qcm.all.each do |q|
      r = rand(1..25)
      if r > i # Solve the qcm
        link = Solvedqcm.new
        link.user = user
        link.qcm = q
        link.nb_guess = rand(1..5)
        link.correct = true
        link.created_at = Date.new(2013,3,rand(1..31)).to_time
        link.updated_at = link.created_at
        point_attribution_qcm(user, q)
        link.save
      end
    end
  end

end


def point_attribution_ex(user, exo)
  if exo.decimal
    pt = 10
  else
    pt = 6
  end
    
  partials = user.pointspersections
    
  if !exo.chapter.sections.empty? # Pas un fondement
    user.point.rating = user.point.rating + pt
    user.point.save
  else # Fondement
    if partials.where(:section_id => 0).size == 0
      newpoint = Pointspersection.new
      newpoint.section_id = 0
      newpoint.points = pt
      user.pointspersections << newpoint
    else
      partial = partials.where(:section_id => 0).first
      partial.points = partial.points + pt
      partial.save
    end
  end
    
  exo.chapter.sections.each do |s| # Section s
    if partials.where(:section_id => s.id).size == 0
      newpoint = Pointspersection.new
      newpoint.section_id = s.id
      newpoint.points = pt
      user.pointspersections << newpoint
    else
      partial = partials.where(:section_id => s.id).first
      partial.points = partial.points + pt
      partial.save
    end
  end
end


def point_attribution_qcm(user, qcm)
  poss = qcm.choices.count
  if qcm.many_answers
    pt = 2*(poss-1)
  else
    pt = poss
  end
    
  partials = user.pointspersections
  
  if !qcm.chapter.sections.empty? # Pas un fondement
    user.point.rating = user.point.rating + pt
    user.point.save
  else # Fondement
    if partials.where(:section_id => 0).size == 0
      newpoint = Pointspersection.new
      newpoint.section_id = 0
      newpoint.points = pt
      user.pointspersections << newpoint
    else
      partial = partials.where(:section_id => 0).first
      partial.points = partial.points + pt
      partial.save
    end
  end
    
  qcm.chapter.sections.each do |s| # Section s
    if partials.where(:section_id => s.id).size == 0
      newpoint = Pointspersection.new
      newpoint.section_id = s.id
      newpoint.points = pt
      user.pointspersections << newpoint
    else
      partial = partials.where(:section_id => s.id).first
      partial.points = partial.points + pt
      partial.save
    end
  end
end
