# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
      Models and migrations inherit from ActiveRecord.
- [x] Use ActiveRecord for storing information in a database
      Using #create and #save.
- [x] Include more than one model class (list of model class names e.g. User, Post, Category)
      Using 5 models: category, item, purchase, purchase_item, and user.
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Posts)
      A user has many purchases. A purchase has_many purchase_items.
- [x] Include user accounts
      Sessions and secure passwords being used.
- [x] Ensure that users can't modify content created by other users
      Access to purchases is limited to those made by session user_id.
- [ ] Include user input validations
- [ ] Display validation failures to user with error message (example form URL e.g. /posts/new)
- [ ] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [ ] You have a large number of small Git commits
- [ ] Your commit messages are meaningful
- [ ] You made the changes in a commit that relate to the commit message
- [ ] You don't include changes in a commit that aren't related to the commit message
