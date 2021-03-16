terraform {
  backend "remote" {
    organization = "greg-test-org"

    workspaces {
      name = "tfecli-test-run"
    }
  }
}