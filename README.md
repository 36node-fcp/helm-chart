# helm-chart

- fcp 应用 chart
- offline-map 离线地图 chart
- roadmap 产品文档 chart

offline-map

离线地图服务，地图下载方式，参考[链接](https://github.com/36node-fcp/roadmap/blob/main/v1/install-project.md#%E5%AE%89%E8%A3%85fcp)，采用挂载本地目录的方式加载地图，因此需要指定 pod 所在机器，默认本地地图放在`/opt/files`目录下。

fcp

包含 `admin-web`、`core`、`auth` 及 多个 robot 和 mock 共 6 个应用。

## development

```shell
# 创建，helm-chart 目录下
helm create chart1

# 调试，helm-chart 目录下
helm template --release-name chart1 --debug chart1

# 校验，chart1 目录下
helm lint

# 打包，helm-chart 目录下
helm package chart1

# 当需要依赖其他 chart 时，chart1 目录下，且需要注意移除 chart1 目录下的 .helmignore 文件中的 charts/，在提交代码前还原
helm dependency update

# 索引，helm-chart 目录下，将打包的文件都放入 docs 目录下
# docs 目录下执行
helm repo index .

# 推送方法
helm registry login harbor.36node.com --username xxx --password xxx
helm push fcp-chart-6.0.0.tgz oci://harbor.36node.com/fcp
```

参考[链接](https://blog.csdn.net/u013360850/article/details/103440483)

## 安装方法

需要分别安装 `fcp`、`offline-map`、`roadmap`

### 命令行安装

```shell
# 更新 repo
helm repo add 36node-fcp https://36node-fcp.github.io/helm-chart/
helm repo update
helm search repo 36node-fcp

# 安装服务
helm install fcp-ecs 36node-fcp/fcp -f values.yaml -n fcp
helm install map 36node-fcp/offline-map -f values.yaml -n fcp
helm install roadmap 36node-fcp/roadmap -f values.yaml -n fcp
```

### ansible 安装

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
      name: fcp
      namespace: fcp
      create_namespace: true
      chart_ref: 36node-fcp/fcp
      values:
        xxx: xxx
  - name: Deploy map 
    community.kubernetes.helm:
      state: present
      name: map
      namespace: fcp
      create_namespace: true
      chart_ref: 36node-fcp/offline-map
      values:
        xxx: xxx
  - name: Deploy roadmap 
    community.kubernetes.helm:
      state: present
      name: roadmap
      namespace: fcp
      create_namespace: true
      chart_ref: 36node-fcp/roadmap
      values:
        xxx: xxx
```

## values 示例

```
global:
  imagePullPolicy: Always
adminWeb:
  enabled: true
  hostname: fcp.36node.com
  image:
    tag: main
  env:
    MQTT_URL: ws://fcp.36node.com:8083/mqtt
```

## roadmap 账号

- fcp-developer: 36node@Fcp
- fcp-xwb: xwb@Fcp34

## 相关资料

- busybox 的 nslookup 会有bug，要用 1.28 版本 https://kb.novaordis.com/index.php/Kubernetes_Init_Containers
