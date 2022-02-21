terraform {
  cloud {
    organization = "DBTek"

    workspaces {
      name = "Civo"
    }
  }
}