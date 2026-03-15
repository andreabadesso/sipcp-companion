{
  description = "SIPCP Companion - Agentic AI for collaborative book editing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pg = pkgs.postgresql_16;
        pgWithExtensions = pg.withPackages (ps: [ ps.pgvector ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Elixir / Erlang
            elixir_1_17
            erlang_26
            rebar3

            # Database (PostgreSQL + pgvector)
            pgWithExtensions

            # Node (for Phoenix assets)
            nodejs_22

            # System deps for NIFs
            openssl
            libyaml
            libffi

            # Dev tools
            git
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            pkgs.inotify-tools # Phoenix live reload on Linux
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.apple-sdk_15
          ];

          shellHook = ''
            # PostgreSQL local setup
            export PGDATA="$PWD/.nix-postgres"
            export PGHOST="$PWD/.nix-postgres"
            export PGPORT="5433"
            export DATABASE_URL="postgres://postgres:postgres@localhost:$PGPORT/sipcp_companion_dev"

            if [ ! -d "$PGDATA" ]; then
              echo "🗄️  Initializing PostgreSQL..."
              initdb -D "$PGDATA" --auth=trust --no-locale --encoding=UTF8
              echo "unix_socket_directories = '$PGDATA'" >> "$PGDATA/postgresql.conf"
              echo "port = $PGPORT" >> "$PGDATA/postgresql.conf"
            fi

            # Start PostgreSQL if not running
            if ! pg_isready -h "$PGHOST" -p "$PGPORT" -q 2>/dev/null; then
              echo "🚀 Starting PostgreSQL on port $PGPORT..."
              pg_ctl -D "$PGDATA" -l "$PGDATA/postgres.log" start -o "-k $PGDATA"
              sleep 1
              createuser -h "$PGHOST" -p "$PGPORT" -s postgres 2>/dev/null || true
            fi

            echo ""
            echo "╔══════════════════════════════════════════╗"
            echo "║   SIPCP Companion - Dev Environment      ║"
            echo "╠══════════════════════════════════════════╣"
            echo "║  Elixir:     $(elixir --short-version)                       ║"
            echo "║  PostgreSQL: $(psql --version | head -1 | awk '{print $3}')                    ║"
            echo "║  Node:       $(node --version)                     ║"
            echo "║  DB Port:    $PGPORT                          ║"
            echo "╚══════════════════════════════════════════╝"
            echo ""
            echo "Commands:"
            echo "  mix phx.server    → Start the app"
            echo "  mix ecto.setup    → Setup database"
            echo "  pg_stop           → Stop PostgreSQL"
            echo ""
          '';

          # Convenience alias
          PG_STOP = "pg_ctl -D $PGDATA stop";
        };
      });
}
