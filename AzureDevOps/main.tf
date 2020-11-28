provider "azuredevops" {
  //version = ">= 0.1.0"
  org_service_url ="https://dev.azure.com/OlivierPotmans"
  personal_access_token="kbmetc5h7pxgtn7khndlfn6srhitcgcbla7dhgnwc5tfautveyyq"
}

resource "azuredevops_project" "project" {
  project_name       = "Test1"
  description        = "Ceci est un test2"
  visibility = "private"
  version_control = "Git"
  work_item_template = "Agile"
  features = {
      "boards" = "enabled"
      "repositories" = "enabled"
      "pipelines" = "enabled"
      "testplans" = "enabled"
      "artifacts" = "enabled"
  }
}
resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Sample GithHub Personal Access Token"

  auth_personal {
      personal_access_token = "f7ddf1f3456b5b7e8a3e432f6b62f0c9a052a58c"
  }
}



