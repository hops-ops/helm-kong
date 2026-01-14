import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# E2E test for Kong XRD
# ==============================================================================

_items = [
    metav1alpha1.CompositionTest {
        metadata.name = "e2e-kong"
        spec = {
            compositionPath = "apis/kongs/composition.yaml"
            xrdPath = "apis/kongs/definition.yaml"
            timeoutSeconds = 600
            validate = True
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "Kong"
                metadata.name = "e2e-kong"
                spec = {
                    clusterName = "e2e-cluster"
                    namespace = "kong"
                }
            }
        }
    }
]

items = _items
