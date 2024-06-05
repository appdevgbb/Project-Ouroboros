terraform {
    required_version = ">= 1.0.0"
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 3.102.0"
        }
        azuread = {
            source = "hashicorp/azuread"
            version = "2.48.0"
        }
        github = {
            source  = "integrations/github"
            version = ">= 6.2.1"
        }
    }
}

provider "azurerm" {
    features {
    }
}

provider "github" {
    owner    = "${var.github_org_name}"
}

locals {
    entity_type = "environment"
    project_name = "projectob"
    prefix = "${var.github_branch_name}${local.project_name}"
    subject = "repo:${var.github_org_name}/${var.github_repo_name}:${local.entity_type}:${var.github_branch_name}"
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
data "azuread_application_published_app_ids" "well_known" {}
