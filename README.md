# helm-chart

### chart 介绍
包括 fcp-ecs 应用 chart 和 offline-map 离线地图 chart，使用 github page 进行发布，可参考[链接](https://blog.csdn.net/u013360850/article/details/103440483)

##### offline-map
离线地图服务，地图下载方式，参考[链接](https://github.com/36node-fcp/roadmap/blob/main/v1/install-project.md#%E5%AE%89%E8%A3%85fcp)，采用挂载本地目录的方式加载地图，因此需要指定 pod 所在机器，默认本地地图放在`/opt/files`目录下。

##### fcp-ecs
包含 `web`、`api`、`auth`、`robot-hengtong`、`robot-xindian`、`robot-xindian2` 共 6 个应用，同时已将 `offline-map` 加入依赖项。

### 安装方法

`fcp-ecs` chart 已包含 `offline-map` chart，无需单独安装

##### 命令行安装
```shell
# 更新 repo
helm repo add 36node-fcp https://36node-fcp.github.io/helm-chart/
helm repo update
helm search repo 36node-fcp

# 安装服务
helm install fcp-ecs 36node-fcp/fcp-ecs -f values.yaml -n fcp-ecs
```

##### ansible 安装
```
tasks:
  - name: Add fcp chart repo
    community.kubernetes.helm_repository:
      state: present
      name: 36node-fcp
      repo_url: https://36node-fcp.github.io/helm-chart/
  - name: Deploy fcp 
    community.kubernetes.helm:
      state: present
      name: fcp-ecs
      namespace: fcp-ecs
      create_namespace: true
      chart_ref: 36node-fcp/fcp-ecs
      values:
        xxx: xxx
```

##### values 示例
```
values:
  host: fcp-ecs.local
  offline-map:
    filePath: /opt/map
    nodeSelector:
      kubernetes.io/hostname: worker-1
  adminWeb:
    enabled: true
```