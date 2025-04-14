{ flake, ... }: {
  imports = map (user: "${flake.conf.users}/${user}") flake.conf.lusers;
}