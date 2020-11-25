provider "azuredevops" {
  version = ">= 0.0.1"
}

resource "azuredevops_project" "project" {
  project_name       = "Test1"
  description        = "Ceci est un test"
}


