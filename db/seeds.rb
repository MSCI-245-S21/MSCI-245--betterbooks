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
enders_game.is_fiction= true
enders_game.save

hunger_games = Book.new( title: "The Hunger Games", year: 2008)
hunger_games.author = collins 
hunger_games.is_fiction= true
hunger_games.save

book_1984 = Book.new( title: "1984", year: 1949 )
book_1984.author = orwell
book_1984.is_fiction=true
book_1984.save 

catching_fire = Book.new( title: "Catching Fire", year: 2009 )
catching_fire.author = collins 
catching_fire.is_fiction= true
catching_fire.save

five_pigs = Book.new( title:"Five Little Pigs", year:1942 )
five_pigs.author = christie
five_pigs.is_fiction= true
five_pigs.save

bob  = User.create( name: "Bob",  email: "bob@bob.com")
mary = User.create( name: "Mary", email: "mary@mary.com")
sue  = User.create( name: "Sue",  email: "sue@sue.com")
fred = User.create( name: "Fred", email: "fred@fred.com")

tom = Author.create( name: "Tom Wolfe")
jon = Author.create( name: "Jon Krakauer")
gary = Author.create( name: "Gary Kinder")

right_stuff = Book.new( title: "The Right Stuff", year: 1979 )
right_stuff.author = tom 
right_stuff.is_fiction= false
right_stuff.save

wild = Book.new( title: "Into the Wild", year: 1996 )
wild.author = jon
wild.is_fiction= false
wild.save

thin_air = Book.new( title: "Into Thin Air", year: 1997)
thin_air.author = jon
thin_air.is_fiction= false
thin_air.save

blue_sea = Book.new( title: "Ship of Gold in the Deep Blue Sea", year: 2009)
blue_sea.author = gary
blue_sea.is_fiction= false
blue_sea.save


