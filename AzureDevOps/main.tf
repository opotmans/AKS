provider "azuredevops" {
  //version = ">= 0.1.0"
  org_service_url ="https://dev.azure.com/OlivierPotmans"
  personal_access_token="kbmetc5h7pxgtn7khndlfn6srhitcgcbla7dhgnwc5tfautveyyq"
}

resource "azuredevops_project" "project" {
  project_name       = "Test1"
  description        = "Ceci est un test2"
}


