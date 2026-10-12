# Gateway

独立的 Kong 网关。声明式配置从 `nexus-law/backend` 抽离，路由仍指向法律助手 API。限流使用本服务自带的 Redis，不再占用业务库。

## 启动

先让上游 API 可访问，再启动网关：

```bash
cd gateway
copy .env.example .env
docker compose up -d
```

- 代理：http://127.0.0.1:8000
- Admin：http://127.0.0.1:8001
- 健康检查：http://127.0.0.1:8000/api/v1/health

`JWT_SECRET` 必须和上游 API 一致。Docker 方式启动的 API 监听 `127.0.0.1:18000`，这是默认上游。本机 `uvicorn --port 8000` 时，把 `UPSTREAM_URL` 改成 `http://host.docker.internal:8000`，并把 `KONG_PROXY_PORT` 改成其他端口。

公开路由（健康检查、登录注册、管理端登录、支付回调、文档）不校验 JWT。其余 `/api` 需要 `Authorization: Bearer <jwt>`，`iss` 为 `nexus-law-normal` 或 `nexus-law-vip`。普通用户按 `KONG_NORMAL_RATE_LIMIT_PER_MINUTE` 限流。
