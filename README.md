# helm-kong

A Crossplane configuration that deploys Kong via Helm.

Kong is a cloud-native API gateway and ingress controller built on top of a lightweight proxy. It provides traffic management, security, and observability for microservices and APIs.

## Quick Start

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: Kong
metadata:
  name: kong
  namespace: my-namespace
spec:
  clusterName: my-cluster
```

## Configuration

| Field | Description | Default |
|-------|-------------|---------|
| `clusterName` | Name of the Kubernetes cluster | Required |
| `namespace` | Namespace to deploy Kong | `kong` |
| `releaseName` | Helm release name | XR name |
| `ingressController` | Enable Kong Ingress Controller | `true` |
| `labels` | Labels to apply to resources | See below |
| `values` | Helm values (merged with defaults) | `{}` |
| `overrideAllValues` | Replace all default values | `{}` |
| `providerConfigRef` | Provider config reference | `{name: clusterName, kind: ProviderConfig}` |
| `managementPolicies` | Crossplane management policies | `["*"]` |

### Default Labels

```yaml
hops.ops.com.ai/managed: "true"
hops.ops.com.ai/kong: "<name>"
```

### Default Helm Values

```yaml
ingressController:
  enabled: true
```

## Examples

### Minimal

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: Kong
metadata:
  name: kong
  namespace: example-env
spec:
  clusterName: example-cluster
```

### Production with LoadBalancer

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: Kong
metadata:
  name: kong
  namespace: example-env
spec:
  clusterName: example-cluster
  namespace: kong
  labels:
    team: platform
    environment: production
  values:
    proxy:
      type: LoadBalancer
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: nlb
    resources:
      requests:
        cpu: "1"
        memory: "1Gi"
```

### DB-less Mode (recommended)

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: Kong
metadata:
  name: kong
  namespace: example-env
spec:
  clusterName: example-cluster
  values:
    env:
      database: "off"
```

## Development

```bash
# Build the package
make build

# Render examples
make render

# Validate examples
make validate

# Run unit tests
make test

# Run E2E tests
make e2e
```

## Chart Information

- **Chart**: kong
- **Repository**: https://charts.konghq.com
- **Version**: 3.0.2
