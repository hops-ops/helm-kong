import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for Kong XRD
#
# Philosophy: Test YOUR API, not the provider's API.
# - render/validate already checks provider schema correctness
# - Tests should verify XRD spec fields produce expected behavior
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm release with name defaulting to XR name
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/kongs/composition.yaml"
            xrdPath = "apis/kongs/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "Kong"
                metadata.name = "test-kong"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-kong"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom labels are applied and merged with defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged-with-defaults"
        spec = {
            compositionPath = "apis/kongs/composition.yaml"
            xrdPath = "apis/kongs/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "Kong"
                metadata.name = "labeled-kong"
                spec = {
                    clusterName = "test-cluster"
                    labels = {
                        team = "platform"
                        environment = "staging"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-kong"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/kong" = "labeled-kong"
                            team = "platform"
                            environment = "staging"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 3: Ingress controller enabled by default
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "ingress-controller-enabled-default"
        spec = {
            compositionPath = "apis/kongs/composition.yaml"
            xrdPath = "apis/kongs/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "Kong"
                metadata.name = "ingress-test"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "ingress-test"
                    spec.forProvider.values = {
                        ingressController.enabled = True
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 4: Traditional helm repository is used
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "helm-repository"
        spec = {
            compositionPath = "apis/kongs/composition.yaml"
            xrdPath = "apis/kongs/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "Kong"
                metadata.name = "repo-test"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "repo-test"
                    spec.forProvider.chart = {
                        name = "kong"
                        repository = "https://charts.konghq.com"
                        version = "3.0.2"
                    }
                }
            ]
        }
    }
]

items = _items
