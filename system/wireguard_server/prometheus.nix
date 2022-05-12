{
  config,
  pkgs,
  ...
}: {
  services.zabbixServer.enable = true;
  services.zabbixWeb = {
    enable = true;
    server = {
      port = 10051;
      address = "10.100.0.1";
    };
    virtualHost = {
      hostName = "wireguard.internal.arvinderd.com";
      adminAddr = "tmp@tmp.org";
    };
  };
  services.zabbixAgent = {
    enable = true;
    server = "localhost";
  };
  services.promtail = {
    enable = true;
    configuration = {
      server.http_listen_port = 9080;
      server.grpc_listen_port = 0;
      clients = [{url = "http://localhost:3100/loki/api/v1/push";}];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              server = "wireguard";
            };
          };
          #relable_configs = [{source_label = "__journal__systemd_unit"; target_label = "unit";}];
        }
      ];
    };
  };
  services.grafana = {
    enable = true;
    addr = "";
    domain = "wireguard.internal.arvinderd.com";
    port = 3000;
    protocol = "http";
  };
  services.loki = {
    enable = true;
    configFile = pkgs.writeText "config.yaml" ''
      auth_enabled: false

      server:
        http_listen_port: 3100
        grpc_listen_port: 9096

      ingester:
        wal:
          enabled: true
          dir: /tmp/wal
        lifecycler:
          address: 127.0.0.1
          ring:
            kvstore:
              store: inmemory
            replication_factor: 1
          final_sleep: 0s
        chunk_idle_period: 1h       # Any chunk not receiving new logs in this time will be flushed
        max_chunk_age: 1h           # All chunks will be flushed when they hit this age, default is 1h
        chunk_target_size: 1048576  # Loki will attempt to build chunks up to 1.5MB, flushing first if chunk_idle_period or max_chunk_age is reached first
        chunk_retain_period: 30s    # Must be greater than index read cache TTL if using an index cache (Default index read cache TTL is 5m)
        max_transfer_retries: 0     # Chunk transfers disabled

      schema_config:
        configs:
          - from: 2020-10-24
            store: boltdb-shipper
            object_store: filesystem
            schema: v11
            index:
              prefix: index_
              period: 24h

      storage_config:
        boltdb_shipper:
          active_index_directory: /tmp/loki/boltdb-shipper-active
          cache_location: /tmp/loki/boltdb-shipper-cache
          cache_ttl: 24h         # Can be increased for faster performance over longer query periods, uses more disk space
          shared_store: filesystem
        filesystem:
          directory: /tmp/loki/chunks

      compactor:
        working_directory: /tmp/loki/boltdb-shipper-compactor
        shared_store: filesystem

      limits_config:
        reject_old_samples: true
        reject_old_samples_max_age: 168h

      chunk_store_config:
        max_look_back_period: 0s

      table_manager:
        retention_deletes_enabled: false
        retention_period: 0s

      ruler:
        storage:
          type: local
          local:
            directory: /tmp/loki/rules
        rule_path: /tmp/loki/rules-temp
        alertmanager_url: http://localhost:9093
        ring:
          kvstore:
            store: inmemory
        enable_api: true'';
    #configuration = {
    #  auth_enabled = false;
    #  server = {
    #    http_listen_port = 3100;
    #    grpc_listen_port = 9096;
    #  };
    #  common = {
    #    path_prefix = "/tmp/loki";
    #    storage = {
    #      filesystem = {
    #        chunks_directory = "/tmp/loki/chunks";
    #        rules_directory = "/tmp/loki/rules";
    #      };
    #      replication_factor = 1;
    #      ring = {
    #        instance_addr = "127.0.0.1";
    #        kv_store = {
    #          store = "inmemory";
    #        };
    #      };
    #    };
    #  };
    #  schema_config = {
    #    configs = [{
    #      from = "2021-12-15";
    #      store = "boltdb-shipper";
    #      object_store = "filesystem";
    #      schema = "v11";
    #      index = {
    #        prefix = "index_";
    #        period = "24h";
    #      };
    #    }];
    #  };
    #  ruler = {
    #    alertmanager_url = "http://localhost:9093";
    #  };
    #};
  };
  networking.firewall.allowedTCPPorts = [80 3000 9002 9000 10051];
  services.prometheus = let
    servers = ["fedora" "wireguard"];
  in {
    enable = true;
    scrapeConfigs =
      builtins.map (server: {
        job_name = "${server}";
        static_configs = [
          {
            labels = {
              server = "${server}";
            };
            targets = ["${server}.internal.arvinderd.com:9002"];
          }
        ];
      })
      servers;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
  };
}
