# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# We will use the seed data in development and production for this homework.

card = Author.create( name: "Orson Scott Card")
collins = Author.create( name: "Suzanne Collins")
orwell = Author.create( name: "George Orwell")
twain = Author.create( name: "Mark Twain")
christie = Author.create( name: "Agatha Christie")

enders_game = Book.new( title: "Ender's Game", year: 1985 )
enders_game.author = card
enders_game.save

hunger_games = Book.new( title: "The Hunger Games", year: 2008)
hunger_games.author = collins 
hunger_games.save

book_1984 = Book.new( title: "1984", year: 1949 )
book_1984.author = orwell
book_1984.save 

catching_fire = Book.new( title: "Catching Fire", year: 2009 )
catching_fire.author = collins 
catching_fire.save

five_pigs = Book.new( title:"Five Little Pigs", year:1942 )
five_pigs.author = christie
five_pigs.save

bob  = User.create( name: "Bob",  email: "bob@bob.com")
mary = User.create( name: "Mary", email: "mary@mary.com")
sue  = User.create( name: "Sue",  email: "sue@sue.com")
fred = User.create( name: "Fred", email: "fred@fred.com")

