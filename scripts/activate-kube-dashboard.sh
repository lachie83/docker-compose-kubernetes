#!/bin/bash

echo "Activating Kube UI..."
kubectl --namespace=kube-system create -f - << EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: kubernetes-dashboard-v1.0.1
  namespace: kube-system
  labels:
    k8s-app: kubernetes-dashboard
    version: v1.0.1
    kubernetes.io/cluster-service: "true"
spec:
  replicas: 1
  selector:
    k8s-app: kubernetes-dashboard
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
        version: v1.0.1
        kubernetes.io/cluster-service: "true"
    spec:
      containers:
      - name: kubernetes-dashboard
        image: gcr.io/google_containers/kubernetes-dashboard-amd64:v1.0.1
        resources:
          limits:
            cpu: 100m
            memory: 50Mi
          requests:
            cpu: 100m
            memory: 50Mi
        ports:
        - containerPort: 9090
        livenessProbe:
          httpGet:
            path: /
            port: 9090
          initialDelaySeconds: 30
          timeoutSeconds: 30
EOF

kubectl --namespace=kube-system create -f - << EOF
apiVersion: v1
kind: Service
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
  labels:
    k8s-app: kubernetes-dashboard
    kubernetes.io/cluster-service: "true"
spec:
  selector:
    k8s-app: kubernetes-dashboard
  ports:
  - port: 80
    targetPort: 9090
EOF