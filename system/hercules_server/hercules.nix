{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets."hercules/cluster-join-token.key".file = ../../secrets/hercules/cluster-join-token.key;
  age.secrets."hercules/cluster-join-token.key".owner = "hci-personal";
  age.secrets."hercules/binary-caches.json".file = ../../secrets/hercules/binary-caches.json;
  age.secrets."hercules/binary-caches.json".owner = "hci-personal";
  age.secrets."hercules/pcparadise-cluster-join-token.key".file = ../../secrets/hercules/pcparadise-cluster-join-token.key;
  age.secrets."hercules/pcparadise-cluster-join-token.key".owner = "hci-pcparadisebot";
  age.secrets."hercules/pcparadise-binary-caches.json".file = ../../secrets/hercules/binary-caches.json;
  age.secrets."hercules/pcparadise-binary-caches.json".owner = "hci-pcparadisebot";
  services.hercules-ci-agents = {
    personal = {
      settings = {
        clusterJoinTokenPath = config.age.secrets."hercules/cluster-join-token.key".path;
        binaryCachesPath = config.age.secrets."hercules/binary-caches.json".path;
        concurrentTasks = 4;
      };
    };
    pcparadisebot = {
      settings = {
        clusterJoinTokenPath = config.age.secrets."hercules/pcparadise-cluster-join-token.key".path;
        binaryCachesPath = config.age.secrets."hercules/pcparadise-binary-caches.json".path;
        concurrentTasks = 4;
      };
    };
  };
}
