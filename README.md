# OneBitChat

Create your team and fun it with slack clone.
Application designed in order to manage your teams.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You must have docker and docker-compose installed

```
For more information, please see https://docs.docker.com/install/ 
```

### Installing

Access the project folder in your terminal enter the following

```
$ docker-compose build
```

```
$ docker-compose run --rm website bundle install
```

```
$ docker-compose run --rm website bundle exec rails db:create
```

```
$ docker-compose run --rm website bundle exec rails db:migrate
```
After that for test the installation enter the following to up the server

```
$ docker-compose up
```

Open your browser and access localhost:3000 to see the home page

## Running the tests

To run the tests run the following in your terminal

```
$ docker-compose run --rm website bundle exec rspec
```

## Built With

* [Ruby on Rails](https://rubyonrails.org/) - The web framework used
* [Puma](https://github.com/puma/puma) - A Ruby Web Server Built For Concurrency
* [MaterializeCSS](https://github.com/Dogfalo/materialize) - Materialize, a CSS Framework based on material design.
* [Redis](https://github.com/redis/redis-rb) - A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface.
* [jQuery](https://github.com/jquery/jquery) - New Wave JavaScript.
* [PostgreSQL](https://www.postgresql.org/) - SGDB

## Authors

* **Ronaldo Carneiro da Silva Filho** - *Initial work* - [kikogamer](https://github.com/kikogamer)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* The bootcamp super full stack team.

