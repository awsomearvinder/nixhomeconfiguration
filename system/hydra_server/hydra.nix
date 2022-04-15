{ pkgs, config, lib, ... }:
{
  age.secrets."hydra/cluster-join-token.key".file = ../../secrets/hydra/cluster-join-token.key;
  age.secrets."hydra/cluster-join-token.key".owner = "hercules-ci-agent";
  age.secrets."hydra/binary-caches.json".file = ../../secrets/hydra/binary-caches.json;
  age.secrets."hydra/binary-caches.json".owner = "hercules-ci-agent";
  age.secrets."hydra/pcparadise-cluster-join-token.key".file = ../../secrets/hydra/cluster-join-token.key;
  age.secrets."hydra/pcparadise-cluster-join-token.key".owner = "hercules-ci-agent";
  services.hercules-ci-agents = {
    personal = {
      settings = {
        clusterJoinTokenPath = config.age.secrets."hydra/cluster-join-token.key".path;
        binaryCachesPath = config.age.secrets."hydra/binary-caches.json".path;
        concurrentTasks = 4;
      };
    };
    pcparadisebot = {
      settings = {
        clusterJoinTokenPath = config.age.secrets."hydra/pcparadise-cluster-join-token.key".path;
        binaryCachesPath = config.age.secrets."hydra/binary-caches.json".path;
        concurrentTasks = 4;
      };
    };
  };
}
