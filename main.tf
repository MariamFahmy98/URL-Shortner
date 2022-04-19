terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "app_server_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2paBhfjEujNihgXCkqd+kbVEf9Jlnx3kn+mY2iPXxwx/p53b+XzXtJmrNfRaEH5Vci/+BKLkC9pHuVODTHvwppcJZMld2J8Y5C00GkFcKu/HB7n8c6WCQA7hyEJwUFOYe3EEZ1w6oYb9JHqprZypOKlgzR+2DpyIooHn2KoA+b2c5HjEbCG/IBPVNdZpWWhovhdxh14LPAGs+9GBWDm/PeqDiIy5KjTHBllrmh6HvZCVBOeZYvPxu8yVisDNpdeRAf/C7GasK1fKc6cDOXNBQE9VwAyfrbnTrx3oggjJ6Bl2BuFmBDhg8nduQ5QTNALqrfhWy9ijO+USX0gquQIrtDM048JqfeEexqsv+lkH3K0W+LbvCqh6vfRKVgm+z8OnSwrZeDTE9V9ZaFdakhwHyrQGZE9BQcTu4YcpyAAhGdDoybYhTUVvvhBmgaeh3phSADuUFYjBvOVoHW23tOdSNEu7dfvlmddYQ2eWlgiSo+AeGtzNCY6xOiHEqa9UlKOs= mariamfahmy2498@mariamfahmy2498-G3-3590"
}
