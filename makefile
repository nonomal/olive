SHELL := /bin/bash

# ==============================================================================
# Building containers

VERSION := 0.6.3

all: olivectl

olivectl:
	docker build \
		-f zarf/docker/dockerfile.olive \
		-t olive:latest \
		-t olive:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

push:
	# docker buildx create \
	# 	--name mybuilder \
	# 	--driver docker-container \
	# 	--bootstrap \
	# 	--use
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-f zarf/docker/dockerfile.olive \
		-t luxcgo/olive:latest \
		-t luxcgo/olive:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--push \
		.

# ==============================================================================
# Modules support

tidy:
	go mod tidy
	go mod vendor

build:
	go run -ldflags="-X github.com/go-olive/olive/command.build=${VERSION}" *.go

# ==============================================================================
# Running from within k8s/kind

KIND_CLUSTER := olive-cluster

# Upgrade to latest Kind: brew upgrade kind
# For full Kind v0.16 release notes: https://github.com/kubernetes-sigs/kind/releases/tag/v0.16.0
# The image used below was copied by the above link and supports both amd64 and arm64.

kind-up:
	kind create cluster \
		--image kindest/node:v1.25.2@sha256:9be91e9e9cdf116809841fc77ebdb8845443c4c72fe5218f3ae9eb57fdb4bace \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml
	kubectl config set-context --current --namespace=olive-system

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)
	
kind-load:
	cd zarf/k8s/kind/olive-pod; kustomize edit set image olive-api-image=olive-api-arm64:$(VERSION)
	kind load docker-image olive-api-arm64:$(VERSION) --name $(KIND_CLUSTER)
	# kind load docker-image postgres:14-alpine --name $(KIND_CLUSTER)

kind-apply:
	kustomize build zarf/k8s/kind/database-pod | kubectl apply -f -
	kubectl wait --namespace=database-system --timeout=120s --for=condition=Available deployment/database-pod
	kustomize build zarf/k8s/kind/olive-pod | kubectl apply -f -

kind-services-delete:
	kustomize build zarf/k8s/kind/olive-pod | kubectl delete -f -
	kustomize build zarf/k8s/kind/database-pod | kubectl delete -f -

kind-restart:
	kubectl rollout restart deployment olive-pod

kind-update: all kind-load kind-restart

kind-update-apply: all kind-load kind-apply

kind-logs:
	kubectl logs -l app=olive --all-containers=true -f --tail=100 | go run app/tooling/logfmt/main.go

kind-logs-olive:
	kubectl logs -l app=olive --all-containers=true -f --tail=100 | go run app/tooling/logfmt/main.go -service=OLIVE-API

kind-logs-db:
	kubectl logs -l app=database --namespace=database-system --all-containers=true -f --tail=100

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --all-namespaces

kind-status-olive:
	kubectl get pods -o wide --watch --namespace=olive-system

kind-status-db:
	kubectl get pods -o wide --watch --namespace=database-system
	
kind-describe:
	kubectl describe nodes
	kubectl describe svc
	kubectl describe pod -l app=olive

# ==============================================================================
# Administration

migrate:
	go run app/tooling/olive-admin/main.go migrate

seed: migrate
	go run app/tooling/olive-admin/main.go seed

# ==============================================================================
# Running tests within the local computer
# go install honnef.co/go/tools/cmd/staticcheck@latest
# go install golang.org/x/vuln/cmd/govulncheck@latest

test:
	go test -count=1 ./...
	staticcheck -checks=all ./...
	govulncheck ./...
