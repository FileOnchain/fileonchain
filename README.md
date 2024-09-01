# Fileonchain

Fileonchain is a secure file storage solution that allows anyone to upload small and large files to any substrate network, making them permanently available on-chain ⛓️.

## Official Links

- Website: [https://fileonchain.org](https://fileonchain.org)
- Twitter/X: [@fileonchain](https://twitter.com/fileonchain)

## Getting Started

### Using Docker Compose

1. Ensure you have Docker and Docker Compose installed on your system.

2. Clone the repository and navigate to the project directory.

3. Create a `.env` file in the root directory with the following environment variables:
   ```
   DB_PASSWORD=your_db_password
   DB_PORT=5432
   DB_USER=your_db_user
   HASURA_GRAPHQL_ADMIN_SECRET=your_hasura_admin_secret
   DATABASE_URL=postgres://your_db_user:your_db_password@db:5432/fileonchain
   SECRET_KEY_BASE=your_secret_key_base
   PHX_HOST=localhost
   ```

4. Run the following command to start all services:
   ```
   docker compose up
   ```

5. Once all containers are up and running, you can access:
   - The Phoenix application at [`http://localhost:4000`](http://localhost:4000)
   - The Hasura GraphQL engine at [`http://localhost:8080`](http://localhost:8080)

### Manual Setup (for development)

If you prefer to run the services separately:

1. Run `docker compose up db graphql-engine` to start Postgres and Hasura.
2. Run `mix setup` to install and setup dependencies.
3. Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Live Demo

You can try out the live demo of Fileonchain at [https://staging.fileonchain.org/](https://staging.fileonchain.org/).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Deployment

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
