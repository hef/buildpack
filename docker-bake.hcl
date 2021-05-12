variable "OWNER" {
  default = "hef"
}

variable "FILE" {
  default = "buildpack"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["build_docker"]
}

group "push" {
  targets = ["push_ghcr", "push_hub", "push_cache"]
}

group "test" {
  targets = ["build_distro"]
}

target "settings" {
  context = "."

  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}",
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-${TAG}",
  ]
}

target "push_cache" {
  inherits = ["settings"]
  output   = ["type=registry"]

  tags = [
    "ghcr.io/${OWNER}/cache:${FILE}-${TAG}",
    "ghcr.io/${OWNER}/cache:${FILE}",
  ]

  cache-to = ["type=inline,mode=max"]
}

target "build_docker" {
  inherits  = ["settings"]
  output    = ["type=docker"]
  platforms = ["linux/amd64", "linux/arm64"]

  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
    "${OWNER}f/${FILE}:${TAG}",
    "${OWNER}f/${FILE}",
  ]
}

target "build_distro" {
  dockerfile = "Dockerfile.${TAG}"
  platforms  = ["linux/amd64", "linux/arm64"]

  tags = [
    "${OWNER}f/${FILE}:${TAG}",
  ]
}

target "push_ghcr" {
  inherits = ["settings"]
  output   = ["type=registry"]

  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
  ]
}

target "push_hub" {
  inherits = ["settings"]
  output   = ["type=registry"]
  tags     = ["${OWNER}f/${FILE}", "${OWNER}f/${FILE}:${TAG}"]
}
