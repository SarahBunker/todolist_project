# todolist_project

This project was built as part of the Launch School Curriculum. It combines knowledge from several sections.

Within the section on OOP we learned how to use classes to represent types of object. This project has two classes: `TodoList` and `Todo`. The `Todo` class represents a todo item and its associated data: name and description. There is also a `done` flag to show whether the todo item is done. The todo item can also have a `due_date`. The `TodoList` class represents a collection of `Todo` objects. You can perform typical collection-oriented actions on a `TodoList` object, including iteration and selection.

In order to implement collection actions within the `Todolist` class I also used knowledge from the section on closures. The method `#each` uses the keyword `yield` in order to be called with a block.

Another major feature upgrade since the last project is implementing testing. I am using `minitest` because it comes installed with Ruby and has a similar syntax if you use the assertion style. We learned about the SEAT approach to testing but only use the first three steps for most steps because we don’t have any databases or files to close.

This project uses several gems. The source code needs access to the ‘stamp’ gem for easy implementation of the date functionality. The test file needs access to ‘minitest/autorun’, ‘date’, and ‘minitest/reporters’. To manage the dependencies of the gems, while using a specific version of Ruby, and documenting the source of the rubygems, I used another gem called bundler. I created a Gemfile that bundler uses to know which gems and versions to use, as well as the source for the ruby gems.

Cloud9 currently runs `ruby 2.6.3`, but to practice using older versions of Ruby this project uses ruby 2.5.0. Using multiple versions of Ruby for different projects can be managed using `rvm`.

Rakefile is another gem used in the project to automate tasks. The `Rakefile` for this project has a simple `hello` task as well as a task to list most files in the project (excludes hidden files). The task to run tests creates a list of all test files to run and then runs them, as long as new test files are created in the `test` directory. The `default` task is set to run the `test` task.
