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
  targets = ["push_ghcr", "push_hub"]
}

group "test" {
  targets = ["build_distro"]
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

  tags = [
    "${OWNER}f/${FILE}:${TAG}",
  ]
}

target "push_ghcr" {
  output = ["type=registry"]

  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
  ]
}

target "push_hub" {
  output = ["type=registry"]
  tags   = ["${OWNER}f/${FILE}", "${OWNER}f/${FILE}:${TAG}"]
}
