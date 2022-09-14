kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.8/deploy/gatekeeper.yaml

cat <<EOF | kubectl apply -f -
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: ModifySet
metadata:
  name: remove-node-taints
  namespace: gatekeeper
spec:
  location: "spec.taints"
  applyTo:
  - groups: [""]
    kinds: ["Node"]
    versions: ["v1"]
  parameters:
    operation: prune
    values:
      fromList:
        - effect: NoSchedule
          key: kubernetes.azure.com/scalesetpriority
          value: spot
EOF