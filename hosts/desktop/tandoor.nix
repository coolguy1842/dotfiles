{ config, pkgs, ... }: {
    services.postgresql = {
        enable = true;
        ensureUsers = [
            {
                name = "tandoor_recipes";
                ensureDBOwnership = true;
            }
        ];

        ensureDatabases = [
            "tandoor_recipes"
        ];

        initialScript = pkgs.writeText "postgres-init.sql" ''
            CREATE EXTENSION IF NOT EXISTS unaccent;
            CREATE EXTENSION IF NOT EXISTS pg_trgm;
        '';
    };

    systemd.services.nginx.serviceConfig.SupplimentaryGroups = [ "tandoor_recipes" ];

    services.nginx = {
        enable = true;
        virtualHosts."tandoor.recipes" = {
            locations."/" = {
                proxyPass = "http://${config.services.tandoor-recipes.address}:${toString config.services.tandoor-recipes.port}";
                recommendedProxySettings = true;
            };

            locations."/media/".alias = "/var/lib/tandoor-recipes/";
        };
    };

    services.tandoor-recipes = {
        enable = true;
        port = 8888;
        address = "192.168.1.4";
        extraConfig = {
            SOCIAL_PROVIDERS = "allauth.socialaccount.providers.openid_connect";
            SOCIALACCOUNT_ONLY = true;

            DB_ENGINE = "django.db.backends.postgresql";
            POSTGRES_DB = "tandoor_recipes";

            SORT_TREE_BY_NAME = true;

            SOCIAL_DEFAULT_ACCESS = 1;
            SOCIAL_DEFAULT_GROUP = "user";

            # not very secret here but who cares, not public anyway
            SECRET_KEY = "yXdv0i3c77RfCpkRb5tZtRVTkvE1PRb3V7lVGE51jj4O1XWOYa";
        };
    };

    users.users.tandoor_recipes = {
        isSystemUser = true;
        group = "tandoor_recipes";
    };

    users.groups.tandoor_recipes.members = [ "nginx" ];
}