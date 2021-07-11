# hw-betterbooks

+ Author: Mark D. Smucker
+ Version history: Updated July 2021 to work with Rails 6.1 and Ruby 3 and improve material and tasks.

## Introduction

In this assignment, you are going to add some features to an existing web app.  The web app, BetterBooks, uses a subset of the tables you worked with in GoodBooks.  

First, I'm going to show you how I made the web app, and then I'll explain the tasks for you to complete.

## Background Reading

While the web and the textbook have basic coverage of Rails, I found the following chapters from [Learning Rails 5](https://ocul-wtl.primo.exlibrisgroup.com/permalink/01OCUL_WTL/5ob3ju/alma999986583426005162) to be the most helpful to understand what was going on (first visit the book via the library link to gain access):
1. Chapter 5: Accelerating Development with Scaffolding

1. Chapter 6: Presenting Models with Forms

1. Chapter 7: Strengthening Models with Validation

I will not cover the material in this homework at the same level of detail as this book or various reference manuals.  

### Rails 5 vs 6

While we are using Rails 6, the book above covers Rails 5.  Chapter 6, uses form_for rather than form_with, but other than their names, there is very little different between them.  Rails combined the functionality of form_tag and form_for into one new form helper called form_with.  Certainly there are some other differences, but they are not significant to the concepts explained in the book, which are the important things to learn. 

## Getting up and running

You are reading these instructions having cloned your GitHub repository to a directory named `betterbooks`.  

**Warning:** If you do not have a directory named betterbooks, **stop!**  Go back to the instructions in Learn and correctly clone your repository.

To get up and going, do the following:
```
cd betterbooks
bundle install --without production
rails db:create db:migrate db:seed
rails server -b 0.0.0.0
```
You should now be able to go to your "Box URL" in Codio and see the web app.

## How I built BetterBooks 

### Basic empty app

After cloning an empty repository to a directory named betterbooks, I followed the setup directions for a new rails app from the [GoodBooks homework](https://github.com/MSCI-245-342/hw-goodbooks/blob/master/hw-instructions.md).

### Scaffolding

We've learned in previous homework about using Rails to generate models, controllers, and migrations.  We can also get Rails to generate all these for RESTful resources in one command using what is called "scaffolding".

I generated three models: Author, User, Book, and their associated controllers and migrations and routes using these commands:
```
rails generate scaffold User name:string email:string --no-fixture
rails generate scaffold Author name:string --no-fixture
rails generate scaffold Book title:string{255} year:integer author:references --no-fixture
```
As you can see, these generate commands are effectively the same as I used for generating the models and migrations in the last homework, except instead of asking for a migration or model, I ask for a scaffold.  

The scaffolding gives a lot of working code, but it also has issues that need to be fixed.  The code in BetterBooks represents what I think is a simplified conversion of the scaffolding, where I simplified code to make it easier to understand.  

When it comes to your final project, should you generate scaffolding?  You could give it a try, and then compare what you get to what you have in this project and decide what to keep and what to change.  Or, you can just generate the models and controllers as we did in the previous homework.  Most professional projects do not bother with scaffolding, but instead generate more specific components and hand edit them.  Either way, you always have to edit the generated code to get it the way you want.  I used the scaffolding to get a working example put together faster.

## Order of Work

After you have the basics of models and controllers generated for you, what order should you work on the parts of a project, e.g. your final project in MSCI 245?

1. Get your migrations correct.  You should not work on anything until your migrations are built to match your desired database design.  Make sure:  
   + You have all primary key and foreign keys correctly setup.
   + You have placed the correct "NOT NULL" and size limits on attributes.

1. Get your model associations correct.  

1. Add validations to your models (see below).

1. Create your seed data and load it.  

1. Determine what your routes are going to be, and make sure `rails routes` reports the correct routes.

1. Work on your controllers and views.  As you need functionality, put most of it in your models.  Your controllers and views should be as sparse and lightweight as possible.

Missing from this list is testing.  As you do work, remember to constantly test it to make sure it is working correctly.  In MSCI 342, we will cover how to systematically test, but for now, you have to do your best to check and verify your work with your own test cases.

## 1. Migrations

To get my migrations right, I copied them from the last homework.

## 2. Model Associations

Again, I copied my associations from the last homework.

## 3. Validations

With our proper database design, we have a strong first line of defense against our database having bad data in it.  For example, our foreign keys make sure we don't reference items that don't exist.  Preventing null values makes sure we always have a value where we need one.  Never let your database go unprotected at the database level!

We cannot easily do all of our data control at the database level.  Certainly we can write check constraints, but lots of these will be easier to implement in our models.  For example, we can check email addresses for a correct format much easier in our User model than in the database.

Rails has lots of support for validating user input and making sure that we don't save garbage to our database.  

### Validations added to models

The Author model is the simplest with only a name attribute.  I decided that I wanted `name` to never be blank (either the empty string or nil) and I wanted the model to enforce the same length limit we used on the database: 70 characters.  If we don't catch a nil or a too long string at the model level, when we try to save the data in the database, it will raise an exception and our app will just not work.  

To make sure `name` is not blank, I added the following to the Author model:
```
validates_presence_of :name
```
Manual: [validates_presence_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_presence_of)

To limit the length of `name`, I added:
```ruby
validates_length_of :name, maximum: 70
```
Manual: [validates_length_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_length_of)

If we do a Author.create() or make a new Author and then try to save it, and `name` violates these validations, the save will fail.  

In addition, on our author object that we tried to save, there will be a method named `errors` that return an array that contains an explanation about each failed validation.

The beauty of this is that we use validations as follows in the web app:

1. Display a form for creating a new Author.

1. User fills out the form and submits it.

1. We grab the inputs from the user, and initialize a new Author object with them.

1. We then try to save the new Author object to the database, but if it fails, then messages are made available via the `errors` method.  

1. When a save fails, we render the `new` form again, but this time display the error messages to the user so that they know what to fix.  Plus, we use the values the user gave us to populate the form so that the user doesn't have to retype everything.

1. If the save succeeds, we redirect to the show author page for the new author.

We'll look at the form later in more detail.

#### Rails console

If you haven't noticed yet, I think the rails console is an awesome tool for rails development.

Let's see another reason why.  Do the following:
```
rails console --sandbox
```
This starts up the console in sandbox mode.  In sandbox mode, any changes you make to the database while using the console are rolled back when you exit.  Keep in mind that the rails console in regular mode is also great if you do want to change your development database and add or change data.

Okay, so we've got some cool new validations on our Author model.  Let's see what they can do.  First, let's make a new Author:
```
a = Author.new
```
When you do this, the console prints out the value returned by the expression.  In this case, it is the value of the variable `a`.  You'll see that you have an Author object with all of its attributes set to nil.  Let's try to save this author to the database:
```
a.save
```
What did the console say was returned?  For me, and hopefully for you, it was `false`.  Why false?  Well, the save did not succeed.  We did not save the author to the database.  You didn't even see it try and run any SQL.  What happened?  Well, to see that, we should look at the errors:
```
a.errors
```
You'll see that the `errors` object tells us that something was wrong with the value we supplied for the `name` attribute.  To see the errors messages, we do:
```
a.errors.messages
```
And we see that there is a hash that maps from `:name` to the value `"can't be blank"`. 

What is going on?

We added a `validates_presence_of :name` validation to the Author model.  When we ask to save the author object, the validations are checked.  If any of the valdiations fail, then the model is not saved to the database and appropriate error messages are created and stored in `errors`.  For the failing attributes, we can look up in `errors.messages` a message to explain the issue.  The `errors` and `errors.messages` will be used by Rails to give feedback to users about their input if it fails to pass our validations.

When you develop your own app, and you create validations for models, you should go into the rails console and check that the validations actually work.  So far, we've seen that we cannot have `nil` for the `name` attribute, which is one thing that the `validates_presence_of` validations checks for, and so that part seems to be working.

Okay, let's set the name attribute to the empty string and try to save it:
```
a.name = ""
a.save
```
This also returns false.  If you look at `a.errors.messages`, you'll see it telling us that `name` cannot be blank.  So, yes, `validate_presence_of` protects against `nil` and an empty string.

Let's try again:
```
a.name = "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
a.save
```
We get false.  If we look at `a.errors.messages`, we see:
```
3.0.1 :004 > a.errors.messages
 => {:name=>["is too long (maximum is 70 characters)"]} 
```

Okay, again:
```
a.name = "Bob"
a.save
```

Yea!  Now it ran the SQL needed to insert "Bob" into the authors table.  Look at `a.errors` now:
```
a.errors
```
and you'll see that it is an empty array.  Right.  No errors.  That is why it was saved.

To exit the console, type `quit`.

#### User model validations:

To the User model, I added the following validations:

```ruby
  validates_presence_of :name
  validates_length_of :name, maximum: 70    
  validates_presence_of :email
  validates_length_of :email, maximum: 255
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 
```

The new one here is [validates_format_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_format_of) to make sure the email is the correct format.

#### Book model validations:

For the Book model:

```ruby
  validates_presence_of :title
  validates_length_of :title, maximum: 255
  validates_presence_of :year
  validates_numericality_of :year, only_integer: true, greater_than: 0, less_than: 2500  
```

The [validates_numericality_of](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_numericality_of) can be used to make sure we get a number.  I also used it to only accept years greater than 0 and less than 2500.

### Try out the web app

Go, use the web app now and try adding invalid data into the app.  

### Other Validations of Use 

There are lots of other validations possible, and you can write custom validations, but these are two important ones:

#### Uniqueness

We can make sure an entry is unique in the database.  For example, many authentication systems want each user to have a unique email:

```ruby
validates :email, uniqueness: true
```

If we have a uniqueness validation on a field, we should also always enforce this
in the database with a unique index.

We would use this in a migration:

```ruby
add_index :table_name, :column_name, unique: true
```

For more info:

https://guides.rubyonrails.org/active_record_validations.html#uniqueness

https://api.rubyonrails.org/classes/ActiveRecord/Migration.html


#### Inclusion in a set

If we only want certain values entered in a field, for example:

```ruby
validates :color, inclusion: { in: %w(red gold),
    message: "must be red or gold" }
```

More info:

https://guides.rubyonrails.org/active_record_validations.html#inclusion

## 4. Seed Data

I copied the seed data I used in the last homework.

## 5. Routes 

The scaffolding made most of the routes needed with 3 statements:

```ruby
  resources :books
  resources :users
  resources :authors
```

I also want a root (home page at `/`), and so I'll need a controller for this page.  I'll call it the static_pages controller, and so I added this route:

```ruby
root to: 'static_pages#home'
```

This says that '/' should go to the static_pages controller and run the `home` action.  

I also wanted to add pages to the app for the confirmation of a request to delete users and authors, and so I needed a route for these pages.  I modeled the routes after the `edit` routes:

```ruby
  get 'users/:id/confirm_delete', to: 'users#confirm_delete', as: 'confirm_delete_user'

  get 'authors/:id/confirm_delete', to: 'authors#confirm_delete', as: 'confirm_delete_author'
```

So, for example, when a user goes to `authors/5/confirm_delete`, I will show them a form asking them if they really want to delete the author with id=5, and if so, they submit that form to the delete/destroy route.  The `as:` option sets up helper methods: `confirm_delete_user_path` and `confirm_delete_user_url` (likewise for Author).

To make sure my routes are correct, I run `rails routes` until I get them written correctly.

## 6. Controllers and Views

At this point, I was ready to start working on the controllers and views. 

### Home Page

First up, I made the controller for the home page:

```
rails generate controller StaticPages home --skip-routes
```

Since want the controller to simply render the home.html.erb view, I don't need to change the controller.  In `app/views/static_pages/home.html.erb` I added:

```
<h1>BetterBooks</h1>
<p><%= link_to "Authors", authors_path %></p>
<p><%= link_to "Books", books_path %></p>
<p><%= link_to "Users", users_path %></p>
```

These are simply links to the authors, books, and users index pages.  I use the helper methods for the paths.  

## Users

The work for Users is the easiest because in the current app, users don't interact with anything.  In a future version of the app, I can add in the reading lists and ratings, but not now.

Open up `app/controllers/users_controller.rb` and follow along as I draw your attention to some interesting parts of it.

Many of the actions require us to first fetch from the database a particular user given an id in the route.  For example, in the show action:

```ruby
  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end
```

The instance variable `@user` is made available to use in our view.  In Rails, views are tied to the controller and have the same name as the action and are automatically rendered at the end of the action unless there has been another call to `render` or `redirect_to`.  Note that execution of the action method [does not stop after a call to render or redirect_to](https://guides.rubyonrails.org/layouts_and_rendering.html#using-render).  These methods merely work on building the response to the browser. 

When we do a redirect, we should supply a full url, e.g. http://www.example.com/users and not merely a relative path such as /users.  This is why you see `redirect_to users_url` rather than `redirect_to users_path`.  

In `create` and `update` you will see that on success we `redirect_to` another page, and in when failure occurs, we use `render` to display a template.  For `destroy` we always `redirect_to` another page.   All of these actions (create, update, destroy) are designed to modify the database and change the state of the app.  If successful and we stay on the same page, the user could hit refresh in their browser and be prompted to submit the POST request again.  This could cause problems, especially for situations such as placing orders in a commerce app, or debiting an account in an banking app.  With the `redirect_to`, the user will already have done a new request to a benign read only route, and a refresh causes no harm.  This [stackoverflow post about render vs. redirect](https://stackoverflow.com/questions/7493767/are-redirect-to-and-render-exchangeable) is a good read to highlight this issue.

This code: 

```ruby
redirect_to @user
```

seems mysterious.  How in the world does `redirect_to` know what to do?  Short answer is that with RESTful routes and following the naming conventions, rails can figure out that is @user has an id of 6, that it should redirect to a url with /users/6 .  If this bothers you (it kinda bothers me), you can always call `user_url(@user)`, which at least shows that we're using a method that we know should produce a url to /user/id where the id will come from the User object we pass in to it.

Ruby allows us to have private methods, and in the UsersController we have this code:

```ruby
  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      # params is a hashtable.  It should have in it a key of :user.
      # The value for the :user key is another hash.
      # If params does not contain the key :user, an exception is raised.  
      # Only the "user" hash is returned and only with the permitted key(s).
      # So we get back { :name => someName, :email => someEmail}
      params.require(:user).permit(:name, :email)
    end
```

My comment explains what this method does.  This allows us to extract only what we expect from the params hash.  Keep in mind that malicious users (hackers) can send any sort of request to our webserver.  This way, we at least only use the parameter values that we expect and no more.

The hash returned by this method can we used as input to User.new to set the attribute values for a User object:

```ruby
    @user = User.new(user_params)
```

A great question is how do we get the params hash set up to have inside it a hash at the `:user` key?

To understand this, we have to look at the HTML FORM that we're using for both creating and editing User objects.  We keep this form in a "partial" view `app/views/users/_form.html.erb`.  All partial views have a name that starts with an underscore.  Even though the name starts with an underscore, when we ask to render the partial, we do not use the underscore (see [guide](https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials) for details).

The idea of partials is: rather than copy and paste the same code into lots of views, write it in one file and include it via a render statement in another view.

So, when we want to render this form in the `new` view (`app/views/users/new.html.erb`), we do:

```ruby
<%= render 'form', user: @user %>
```

`render` finds the partial in the file `_form.html.erb` and creates a local variable for the partial named `user` that it initializes to the value of `@user`, which is a variable we created in our controller.

Open up `app/views/users/_form.html.erb` to follow along.

The first line is our call to the `form_with` method that builds the HTML FORM for us:

```
<%= form_with(model: user, local: true) do |form| %>
```

The `form_with` method knows how to work with models, and can take a model as an argument via the `model:` parameter. We pass into `form_with` via `model:` the user object (this variable, `user`, was set to @user in our call to `render` for this partial).

Because we are not using javascript, we set `local:` to `true`.  Then, `form_with` is going to execute the block and make available to the block the variable `form`.  We could have used any variable name inside of the vertical bars  `| |` , and you'll see `|f|` used as well as `|form|` in code examples.

Next in the form is the code to print out the error messages from the validations:

```html
  <% if user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(user.errors.count, "error") %> prevented this user from being saved:</h2>

      <ul>
        <% user.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
```

So, if we try to save or update a User object, and it fails because of a validation, we render this form again, and the error messages will be displayed explaining what was wrong with the input.  Very handy!

Next in the form, we have our two input fields for name and email:

```html
  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div class="field">
    <%= form.label :email %>
    <%= form.text_field :email %>
  </div>
```

Recall that `<div>` tags are just divisions, much like a paragraph `<p>` tag.  They have a class to allow for CSS styling.

The `form.label` is a call on the `form` object created by `form_with(model: user, local: true) do |form|` to produce an HTML label.  We specify the model's attribute that this label is for: `:name` and `:email`.  Details in [manual](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-label). 

Likewise, `form.text_field` calls [text_field](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-text_field).  

If you view the HTML source produced at `/users/new` you'll see the following:

```html
  <div class="field">
    <label for="user_name">Name</label>
    <input type="text" name="user[name]" id="user_name" />
  </div>

  <div class="field">
    <label for="user_email">Email</label>
    <input type="text" name="user[email]" id="user_email" />
  </div>
```
For the text fields, their `name` are set to `user[name]` and `user[email]`.  When Rails gets a form submission that has key values of the form `alpha[beta]`, in the params hash, it create a key of `:alpha` that has a hash as its value and then sets `params[:alpha][:beta]` to the value submitted in the FORM.  Thus, for the FORM above, we get the user's submitted values via `params[:user][:name]` and `params[:user][:email]`.  So, we finally see why the UsersController method `user_parms` is fetching a hash from `params` keyed to `:user`!

Also, when we look at the HTML, we see that `form_with` know where to submit the form:

```html
<form action="/users" accept-charset="UTF-8" method="post">
```
it knows this again from our RESTful use of models.  In the `new` action handler of the UsersController, we created an empty User object and stored it in `@user`, which eventually is handed to `form_with` via the `user` variable that got its value via the `render` call.  Anyways, **because the user object 
has not been persisted to the database, `form_with` knows that this FORM should POST to "/users" because that is how we create new users!**  

If `form_with` gets a model object that has been persisted, then it "knows" that this needs to be a FORM that submits a PATCH to "/users/", for that is how we update a model.  Details in [manual](https://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_with).

And, for the last great trick of `form_with`, when we supply a model object, the values of the attributes of the model object are used to populate the input fields in the FORM.  

For example, if I go to edit the User with name='Bob', I'll get the following HTML:

```html
  <div class="field">
    <label for="user_name">Name</label>
    <input type="text" value="Bob" name="user[name]" id="user_name" />
  </div>
```
Whoa.  So, if you can master the use of `form_with` and validations, you get a lot of functionality provided for you to easily handle the user interface of the FORMs needed for creating and updating the underlying resources.

How in the world did I get all of this to work?  This is where starting with the scaffolding can be helpful.  It will give you mostly working code, but you need to understand it well enough to get it actually working.  Blindly using scaffolding will just get you a mess that you cannot fix.  If in doubt, code what you understand using the examples in this project.

## Delete

The scaffolding did not produce working delete methods with javascript turned off.  

In the BetterBooks app, I show two ways of getting the web app to produce the correct POST request to delete a resource.

For Users and Authors, I added new "confirm_delete" routes and actions to the UsersController and AuthorsController.  When the user follows a link to /users/7/confirm_delete , the UsersController runs the confirm_delete action handler and passes in 7 via params[:id].  My confirm_delete.html.erb view displays the user associated with the given user and sets up a form to send a DELETE request in for this user:

```html
<%= form_with model: @user, local: true, method: 'delete' do |f| %>
  <%= f.submit "Confirm Delete" %>
<% end %>
```

I have to specify the `method:` to be `delete` for this to work.  If we POST, we'll show the user rather than destroy/delete them.

For the Books resource, in the `index` view, I simply put a "Delete" button next to each book:

```html
<%= form_with model: book, method: :delete, local: true do |f| %>
    <%= f.submit 'Delete' %>
<% end %>
```

here, the variable `book` holds a Book object.

Clicking the button deletes the book without asking for any confirmation.

## New Book - Author dropdown

The scaffolding could not add a book unless you as a user knew the book's id!  

To fix this, I modified the `app/views/books/_form.html.erb` partial to provide a dropdown via a FORM SELECT:

```html
<%= form.select(:author_id, Author.to_nested_array_for_select) %>      
```

As the [guide](https://guides.rubyonrails.org/form_helpers.html#select-boxes-for-dealing-with-model-objects) explains, I needed to provide an array of arrays to the select method.  As usual, the place to put this code is in the Author model.  So, I wrote the following in the Author model:

```ruby
  # Creates and array of arrays to use in dropdown selects for author. For more info:  
  # https://guides.rubyonrails.org/form_helpers.html#select-boxes-for-dealing-with-model-objects
  def self.to_nested_array_for_select
     nested = []  
     Author.order(:name).each do |author|
         nested.push [author.name, author.id]
     end
     return nested 
  end
```

Again, the method is `self.to_nested_array_for_select` because I just want to use the Author model to tell me about authors, and I'm not writing a method for an individual author.  

Note that I put a link in the comment for more info.  There is no way I'd remember why I wrote this method in this way without a reference to the document.  

I was careful to order the authors by name to make the dropdown sensible to use.

Long term, my user interface will be unwieldy.  Who wants to select an author from a dropdown with thousands of author names?  Not me.  Nevertheless, the functionality is better than it was, and it lets us get a first version of the system up and running.  We can always improve it in the future.  Plus, my real goal was to demo a dropdown for you.

## Query Parameters

Go to the Books' index page: "/books" in the web app.

If you click on "Year", "Author", and "Title", the table of books is sorted by year, author, and title.  

Look at the URL in your browser as you click on these links.  You still navigate to `/books` but now it has a query parameter added to it, for example `?order_by=author`.

If you look at `app/views/books/index.html.erb` you can see that I make these links as follows:

```html
      <th><%= link_to 'Title', books_path(order_by: 'title') %></th>
      <th><%= link_to 'Year', books_path(order_by: 'year') %></th>
      <th><%= link_to 'Author', books_path(order_by: 'author') %></th>
```

The `books_path` method will take arguments and convert them to query parameters.  For example, if I did:

```ruby
books_path( hello: 'mark', alpha: 'beta')
```

it would output: `"/books?alpha=beta&hello=mark"`

When a user click on this link, a GET request is sent to the server, and Rails takes everything before the question mark and uses that for routing, and everything after the question mark is added as key value pairs to the `params` hash.  So for `"/books?alpha=beta&hello=mark"`, we would get `params[:alpha]='beta'` and `params[:hello]='mark'` in the books index action handler.

If you've ever used Google (ha ha), when you search you'll see lots of these query parameters in the url.  For example, [https://www.google.com/search?q=uwaterloo+management+engineering](https://www.google.com/search?q=uwaterloo+management+engineering).  

In the BooksController index method, we have:

```ruby
  def index
    # We've added a method, self.order_by, to the Book model, 
    # see models/book.rb
    @books = Book.order_by params[:order_by]
  end
```

So, all we do is call `Book.order_by` and pass in the `params[:order_by]`, which may be `nil` if no query parameter was provided.

This is an example of passing functionality down to the model.  I could write a bunch of code in the controller to manage sorting of the books, but the controller shouldn't be doing that sort of work.  That is model sort of work.  So, in the Book model we have:

```ruby
  # Order books by year, author.name, or title
  def self.order_by field
    if field == 'year'
      return Book.order(:year, :title)
    elsif field == 'author'
      return Book.joins(:author).order(:name, :year)
    else
      return Book.order(:title)
    end
  end
```

Thankfully, string comparison to `nil` is okay and returns `false`, and so even if the `field` parameter is `nil`, this code works without raising any exceptions.  

Some things to notice:

1. The method is `self.order_by` and not just `order_by`.  When we precede our method name with `self.`, this makes a method on the class Book and not on book objects.  Thus, we call this method as `Book.order_by` without a book object in hand.  This makes sense, for a regular method `order_by` would be respect to a particular Book object, but we want to do something with Books, and so we make a method for the Book class.

1. When I sort by year and author, I have a secondary sort on title and year.  So, when sorting by year, within each year we sort by title.  When sorting by author, we order by the author's name, and then by year of book.

1. To sort by author name, I needed to join Book with the authors table.  (To figure this out, I worked in rails console until I got the query right. Think of the rails console as a workshop to try out code until you figure it out.)

1. Default sort is by title. So, our books will always be at least sorted by title even if no request is made to sort them.  Users almost never want unsorted lists of material.  It makes sense to sort a table by default on the first, leftmost column that is displayed to the user.

## Tasks: Feature Improvements

Now that you've seen how BetterBooks works, you need to add some feature improvements to it.  This is a scenario that is common to co-op jobs, and daily software engineering.  The company will have an existing system, and you need to go into it and modify the code to add new functionality.  For my first job as a software developer, I was tasked with fixing a bug in the system.  This was a web app with probably more than 100K lines of C++ code, and hundreds of classes. To fix the bug, I had to spend about two weeks reading and learning how the system worked before making the few changes needed to fix the bug.

#### Writing Test Cases

For each change you make, you are required to write a suitable test case to verify the functioning of the change.  If a change needs more than one test case to verify its functionality, you should write multiple test cases.

+ In the directory named `test/manual` there is a file named `test-cases.txt`.  We will store manual test cases in this file.  A manual test is one that a person has to execute by hand.  An automated test case is run by the computer.  In MSCI 342 we will throughly cover automated testing.

+ In this file, using clear formatting, write your test cases to explain to someone how to test that your changes work.  A test case should explain how to set it up, how to input data, and what the expected results are.  The file contains an example to follow.

#### Changes to make

Make the following changes to the BetterBooks app and commit and push them and your test cases to GitHub when you have them working.

##### Task: Downcased email

Change the app so that user input of email addresses is always downcased before saving in the database. Your change should be made in the User model.  As you can read in [Active Record Callbacks](https://guides.rubyonrails.org/active_record_callbacks.html) we can instruct our models to run code before and after certain actions.  For example, we can run code to downcase the email whenever the model is told to save itself.  Add a `before_save` callback to the User model that downcases the email.

##### Task: Unique email

Change the app such that no two users may have the same email address.  Make sure the database disallows users with the same email address, and make sure the User model does a uniqueness validation so that web users are given the correct feedback when they enter an email that has already been used.  For the database, write and run a **new** migration that adds an index to the users table such that the email attribute must be unique.  See [Active Record migrations](https://guides.rubyonrails.org/active_record_migrations.html) and [add_index](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_index).

##### Task: Deleting authors

Currently, the confirm_delete page for Authors, tells the user that they first have to delete all books by an author before the author can be deleted.  Change the functionality so that the user is presented with a message explaining that if the author has any books, they must confirm they also want all books deleted.  If the author has any books in the database, provide a listing of the books. When the user confirms the delete, the author and all of the author's books are deleted and the user is informed that the "Author and author's book(s) were successfully deleted." on the authors index page (/authors).  You may not use a "cascade on delete" in the database, nor may you use Rails features to automatically delete all books on the destruction of an author.  Do not change the authors table in the database.  We want the deletion of books to never be accidentally done with the deletion of an author.

##### Task: Fiction or Nonfiction (Book Genre)

Currently, we only store fiction books in our database.  We'd like to be able to list non-fiction titles, too. When we create or edit a book, we'd like to record if it is fiction or not.  

+ First clean out your database to be empty:
  + `rails db:drop`
  + `rails db:create`
  + `rails db:migrate`

+ Create and run a **new** migration to [add_column](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_column) of a Boolean attribute `is_fiction` to the books table.  Be sure the column is NOT NULL.  Remember to check the database with psql to see that the column was added as expected.  Add a validation to the Book model to make sure the attribute is always set on creating a new book:
```ruby
validates :is_fiction, inclusion: [true, false]
```
+ Update your dev-data in db/seeds.rb to work with the new attribute on the Book model.  Add these non-fiction books:
  + The Right Stuff, by Tom Wolfe, 1979.
  + Into the Wild, by Jon Krakauer, 1996.
  + Into Thin Air, by Jon Krakauer, 1997.
  + Ship of Gold in the Deep Blue Sea, by Gary Kinder, 2009. 

+ Load the seed data: `rails db:seed` and verify the data is in the database.
If you run into problems, debug (use `byebug` and your `rails console`) and go through this sequence to reset:
  + `rails db:drop`
  + `rails db:create`
  + `rails db:migrate`
  + `rails db:seed`

+ Modify your Book views to show the new attribute in the /books page.  The column should be to the right of Author and be labeled "Genre" and fiction books should have a genre of "fiction" and nonfiction books should have a genre of "nonfiction".  Suggestion: write a method named `genre` on the Book model to return "fiction" or "nonfiction" as appropriate for that book.  Then use the `genre` method in your view.  

+ Update your books_controller to allow a `:is_fiction` parameter to be passed in via params.

 + Modify your app to allow the input and editing of Book genre (fiction/nonfiction).  For creating a new book and editing an existing book, use a checkbox for the field:
```erb
<div class="field">
      <%= form.check_box :is_fiction %>
      <%= form.label :is_fiction, style: "display: inline" %>
</div>
```

+ Modify the app to allow books to be sorted by genre (fiction/non-fiction) in the same manner that we can sort books by author, title, and year by clicking on the table header for that column in the /books page.  The default order should be that fiction books are listed first, and then non-fiction books.  Within each genre, the sort order should be by title (primary key is genre, the secondary key is title).

##### Task: Deploy to Heroku

Once you have a working app, deploy your app to Heroku with an app name of betterbooks-watiamUsername.  Replace "watiamUsername" with your WatIAM username.  Follow the directions for deploying to Heroku from the [BasicBooks](https://github.com/MSCI-245-342/lab-hw-basicbooks/blob/main/instructions.md) assignment.  Be sure to also load the seed data.  For this homework, we'll load the seed data into production for demo purposes.

##### Task: Complete the README.md

Edit the README.md file and properly acknowledge people and resources and record assistance given.

### Submitting your work

Commit and push all work to GitHub.  The time of your last commit is the time of your submission.  If you fail to push your work to GitHub, you will only get credit for the work actually in GitHub!  We cannot check your work unless you have pushed it to GitHub.  






