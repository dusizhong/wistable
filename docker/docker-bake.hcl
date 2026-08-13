group "default" {
  targets = ["backend-server", "room-server", "web-server", "init-db", "gateway"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io"
}

variable "SEMVER_FULL" {
  default = "v0.0.0-alpha"
}

variable "IMAGE_TAG" {
  default = "latest"
}

target "backend-server" {
  context = "."
  dockerfile = "docker/Dockerfile.backend-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/wistable/backend-server:latest", "${IMAGE_REGISTRY}/wistable/backend-server:${IMAGE_TAG}"]
}

target "room-server" {
  context = "."
  dockerfile = "docker/Dockerfile.room-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/wistable/room-server:latest", "${IMAGE_REGISTRY}/wistable/room-server:${IMAGE_TAG}"]
}

target "web-server" {
  context = "."
  dockerfile = "docker/Dockerfile.web-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}/wistable/web-server:latest", "${IMAGE_REGISTRY}/wistable/web-server:${IMAGE_TAG}"]
}

target "web-server-experimental" {
  context = "."
  dockerfile = "docker/Dockerfile.web-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/wistable/web-server:latest", "${IMAGE_REGISTRY}/wistable/web-server:${IMAGE_TAG}"]
}

target "init-db" {
  context = "./init-db"
  dockerfile = "Dockerfile"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/wistable/init-db:latest", "${IMAGE_REGISTRY}/wistable/init-db:${IMAGE_TAG}"]
}

target "gateway" {
  context = "./gateway"
  dockerfile = "../docker/Dockerfile.gateway"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/wistable/gateway:latest", "${IMAGE_REGISTRY}/wistable/gateway:${IMAGE_TAG}"]
}
