# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email: "jose@gmail.com", uid: "123456623sda", provider: "google")

poll = MyPoll.create(title: "Qué lenguaje de programación es el mejor para ti?",
											description: "Queremos saber cual es el leguaje que prefiere la mayoría de la gente",
											expires_at: DateTime.now + 1.year,
											user: user)

question = Question.create(description: "Te importa la eficiencia de ejecucion?",
														my_poll: poll)

answer = Answer.create(description: "a. Sí, me importa mucho", question: question)