# n8n

https://n8n.io/

## Authentication

n8n's auth is patched to use the Home Assistant auth system so you do not need to log in again.

## Configuration

Set env vars in the config like this:

```
env:
  - WEBHOOK_URL=http://example.com/
  - N8N_SMTP_HOST=smtp.example.com
```

See https://docs.n8n.io/hosting/configuration/environment-variables/ for available variables

## External/Public Routes (Webhooks, etc.)

Set up a separate reverse proxy addon like caddy or nginx and forward to `bd95bdb9_n8n:5678`.

Config for caddy:

```
{
  handle {
    @n8n {
      path /webhook/*
      path /webhook-test/*
      path /webhook-waiting/*
      path /n8n-api/*
      path /form/*
      path /rest/*
      path /mcp/*
    }
  }

  route @n8n {
    reverse_proxy bd95bdb9_n8n:5678
  }
}
```

Config for nginx (from https://github.com/Rbillon59/hass-n8n):

```
location ~ ^/(webhook|webhook-test|webhook-waiting|api|form|rest|mcp)(/.*)?$ {
    # $1 captures the base part (e.g. "webhook") and $2 captures any additional subpath (e.g. "/subpath")
    proxy_pass http://bd95bdb9_n8n:5678/$1$2$is_args$args;

    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_set_header Origin $scheme://$host;
    proxy_cache off;
    proxy_buffering off;
}
```

## Private Nodes

Private nodes can be placed in `/addon_configs/bd95bdb9_n8n/` instead of `~/.n8n/custom/` noted by the n8n documentation.

See https://docs.n8n.io/integrations/creating-nodes/deploy/install-private-nodes/
