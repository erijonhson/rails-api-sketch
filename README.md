# Sketch

Steps are necessary to get the application up and running.

* Ruby 2.4.0 and Rails 5.0.6 version
* System dependencies
  + postgresql with pg 0.18
  + server with puma 3.0
  + CORS with rack-cors
  + Integration for windows infos with tzinfo-data
  + Authentication with devise and devise_token_auth
  + JSON serialization with active_model_serializers
* Configuration
  + To install all dependencies, run:
    ```
    bundle install
    ```
  + Configure /config/database.yml with correct username and password
  + For create the database, run:
    ```
    rake db:drop db:create db:migrate db:schema:load db:test:prepare db:test:load
    ``` 
* For the test suite, run:
  ```
  bundle exec spring rspec --format=d
  ```
* Models
  ```
    User
      should validate that :password_confirmation matches :password
      should allow :email to be ‹"example@email.com"›
      should validate that :auth_token is case-sensitively unique
      should validate that :email is case-insensitively unique
      should have many tasks dependent => destroy
      should validate that :email cannot be empty/falsy
      #info
        returns email, created_at and a Token
      #generate_authentication_token!
        generates a unique auth token
        generates another auth token when the current auth token already has been taken

    Task
      should validate that :user_id cannot be empty/falsy
      should respond to #user_id
      should respond to #done
      should belong to user
      should respond to #title
      should respond to #description
      should respond to #deadline
      should validate that :title cannot be empty/falsy
      when is new
        should not be done

    Authenticable # interface for User in API V1 
      #user_logged_in?
        when there is no user logged in
          should equal false
        when there is a user logged in
          should equal true
      #authenticate_with_token!
        when there is no user logged in
          return the json data for the errors
          return status code 401
      #current_user
        returns the user from the authorization header
  ```
* Services 
  ```
    # API V1

        Users API
          PUT /api/v1/users/:id
            when the request params are valid
              return status 200
              return json data for the updated user
            when the request params are invalid
              return json data for the errors
              return status 422
          GET /api/v1/users/:id
            when the user doesn't exists
              return status 404
            when the user exists
              return status 200
              returns the user
          DELETE /users/:id
            return status 204
            removes the user from database
          POST /api/v1/users
            when the request params are valid
              return json data for the created user
              return status 201
            when the request params are invalid
              return status 422
              return json data for the errors

        Task API
          GET /api/v1/tasks/:id
            returns the json for task
            returns status code 200
          POST /api/v1/tasks
            when the params are invalid
              doesn't saves the task in the database
              returns the json error for title
              returns status code 422
            when the params are valid
              returns status code 201
              returns the json for created task
              assigns the created task to the current user
              saves the task in the database
          DELETE /api/v1/tasks/:id
            returns status code 204
            removes the task from the database
          GET /api/v1/tasks
            returns status code 200
            returns 5 tasks from database
          PUT /api/v1/tasks/:id
            when the params are valid
              returns status code 200
              updates the task in the database
              returns the json for updated task
            when the params are invalid
              returns the json error for title
              returns status code 422
              doesn't updates the task in the database

        Sessions API
          DELETE /api/v1/sessions
            changes the user auth token
            returns status code 204
          POST /api/v1/sessions
            when the credentials are correct
              return status code 200
              returns the json data for the user with auth token
            when the credentials are incorrect
              returns the json data for the errors
              return status code 401

    # API V2

        Users API
          PUT /api/v2/auth
            when the request params are invalid
              return status 422
              return json data for the errors
            when the request params are valid
              return status 200
              return json data for the updated user
          DELETE /api/v2/auth
            return status 200
            removes the user from database
          GET /api/v2/auth/validate_token
            when the request headers are invalid
              return status 401
            when the request headers are valid
              return status 200
              returns the user id
          POST /api/v2/auth
            when the request params are invalid
              return status 422
              return json data for the errors
            when the request params are valid
              return status 200
              return json data for the created user

        Task API
          POST /api/v2/tasks
            when the params are valid
              saves the task in the database
              returns status code 201
              assigns the created task to the current user
              returns the json for created task
            when the params are invalid
              returns status code 422
              returns the json error for title
              doesn't saves the task in the database
          PUT /api/v2/tasks/:id
            when the params are invalid
              returns the json error for title
              returns status code 422
              doesn't updates the task in the database
            when the params are valid
              returns status code 200
              updates the task in the database
              returns the json for updated task
          GET /api/v2/tasks
            when no filter param is sent
              returns 5 tasks from database
              returns status code 200
            when filter and sorting params are sent
              returns only the tasks matching
          GET /api/v2/tasks/:id
            returns the json for task
            returns status code 200
          DELETE /api/v2/tasks/:id
            removes the task from the database
            returns status code 204

        Sessions API
          DELETE /api/v2/auth/sign_out
            returns status code 200
            changes the user auth token
          POST /api/v2/auth/sign_in
            when the credentials are incorrect
              returns the json data for the errors
              return status code 401
            when the credentials are correct
              return status code 200
              returns the authentication data in the headers
  ```
