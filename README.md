# Fileonchain

![Fileonchain Home Page](/priv/static/images/preview-home.png)

Fileonchain is a secure file storage solution that allows anyone to upload small and large files to any substrate network, making them permanently available on-chain ⛓️.

## 🚀 Quick Links

- 🌐 Website: [https://fileonchain.org](https://fileonchain.org)
- 🐦 Twitter: [@fileonchain](https://twitter.com/fileonchain)
- 🖥️ Live Demo: [https://staging.fileonchain.org/](https://staging.fileonchain.org/)

## 🛠️ Getting Started

### Using Docker Compose

1. Ensure Docker and Docker Compose are installed on your system.
2. Clone the repository and navigate to the project directory.
3. Create a `.env` file in the root directory with the following:

   ```
   DB_PASSWORD=your_db_password
   DB_PORT=5432
   DB_USER=your_db_user
   HASURA_GRAPHQL_ADMIN_SECRET=your_hasura_admin_secret
   DATABASE_URL=postgres://your_db_user:your_db_password@db:5432/fileonchain
   SECRET_KEY_BASE=your_secret_key_base
   PHX_HOST=localhost
   ```

4. Start all services:
   ```
   docker compose up
   ```

5. Start Phoenix, in a new terminal:
   ```
   mix phx.server
   ```

5. Access the services:
   - Phoenix application: [http://localhost:4000](http://localhost:4000)
   - Hasura GraphQL engine: [http://localhost:8080](http://localhost:8080)

### Normal Setup for Phoenix @Web

1. Install dependencies:
   ```
   mix deps.get
   ```

2. Create and migrate your database:
   ```
   mix setup
   mix ecto.migrate
   ```

3. Start Phoenix server:
   ```
   mix phx.server
   ```

4. Access the application at [http://localhost:4000](http://localhost:4000)

### Manual Setup (for development)

1. Start Postgres and Hasura: `docker compose up db graphql-engine`
2. Install dependencies: `mix setup`
3. Start Phoenix endpoint: `mix phx.server` or `iex -S mix phx.server` (inside IEx)

Visit [localhost:4000](http://localhost:4000) in your browser.

## 📚 Learn More

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Documentation](https://hexdocs.pm/phoenix)
- [Elixir Forum](https://elixirforum.com/c/phoenix-forum)
- [Phoenix GitHub Repository](https://github.com/phoenixframework/phoenix)

## 🚀 Deployment

Ready for production? Check out the [Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the [MIT License](LICENSE.md).
