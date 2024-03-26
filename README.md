# 🤑 Ex_Solomon

Solomon is a personal finance application designed to help you manage your finances effectively.

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### 🗒️ Prerequisites

- <img src="https://static-00.iconduck.com/assets.00/file-type-elixir-icon-329x512-ig4id7j1.png" alt="elixir-logo" width="12" /> Elixir 1.14 or higher
- 🐳 Docker / Docker Compose
- 🐘 PostgresSQL 12.1

### 🐳 Running the Project Locally with docker

1. Clone the repository:

```sh
git clone https://github.com/daniel-leal/ex_solomon
```

2. Naviagate to the project directory

```sh
cd ex_solomon
```

3. Build the docker

```sh
docker compose build
```

4. Run the docker application

```sh
docker compose up -d
```

The application will be available at (http://localhost:4000).

### ✅ Running the Tests

To run the tests, use the following command:

```sh
mix test
```


### ⚙️ Migrations

- Running migrations

```sh
mix ecto.migrate
```

- Seed database

```sh
mix run priv/repo/seeds.exs
```

- Rollback latest migration

```sh
mix ecto.rollback
```

### Contributing

Please read CONTRIBUTING.md for details on our code of conduct, and the process
of submitting pull requests to us.

### License

This project is licensed under the MIT License - see the LICENSE.md file for details
