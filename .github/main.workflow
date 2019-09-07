workflow "Build and push to docker hub" {
  on = "push"
  resolves = [ "Push docker image to docker hub" ]
}

action "Build docker image" {
  uses = "docker://docker:stable"
  args = [ "build", "-t", "hitian/ss-v2ray-plugin:latest", "."]
}

action "Login docker hub" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Push docker image to docker hub" {
  uses = "docker://docker:stable"
  needs = [ "Build docker image", "Login docker hub" ]
  args = "push hitian/ss-v2ray-plugin"
}

