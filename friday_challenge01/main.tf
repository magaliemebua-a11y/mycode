/* main.tf
   Alta3 Research - rzfeeser@alta3.com */
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0.0"
    }
  }
}

# interact with docker
provider "docker" {
# Explicitly points to the standard Ubuntu Docker socket
  host = "unix:///var/run/docker.sock"
}

# create random_ resources
provider "random" {}

# interact with time data
provider "time" {}

resource "docker_image" "nginx" {
  name         = "nginx:1.28"
  keep_locally = true
}

# available from random.random_pet
resource "random_pet" "nginx" {
  length = 3
}

resource "docker_container" "nginx" {
  count = 3
  image = docker_image.nginx.image_id
  network_mode = "bridge"
  name  = "nginx${random_pet.nginx.id}-${count.index}"
  # name = "nginx-hoppy-frog-0"

  ports {
    internal = 80
    # 8000, 8001, 8002
    external = 8000 + count.index
  }
}
