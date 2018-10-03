module "ResourceGroup" {
    source = "<path module>"
    RGName              = "${var.env}-${var.Project}-rg"
    RGLocation          = "${var.AzureRegion}"
    tags                = "${merge(local.tags, var.tags)}"
}

module "key_vault" {
    source = "<path module>"    
    name                = "${var.env}-${var.Project}-key"
    location            = "${var.AzureRegion}"
    resource_group_name = "${module.ResourceGroup.Name}"
    tenant_id           = "${var.tenant_id}"
    object_id           = "${var.object_id}"
}

resource "azurerm_key_vault_secret" "values" {
    name      = "demo1"
    value     = "value1"
    vault_uri = "${module.key_vault.uri}"
}

data "azurerm_app_service_plan" "ServicePlan" {
    name                = "${var.PlanName}"
    resource_group_name = "${var.PlanRGName}"
}

resource "azurerm_app_service" "WebApp" {
    name                = "${var.Project}-webapp"
    location            = "${var.AzureRegion}"
    resource_group_name = "${module.ResourceGroup.Name}"
    app_service_plan_id = "${data.azurerm_app_service_plan.ServicePlan.id}"
    tags                = "${merge(local.tags, var.tags)}"

    site_config {
      java_version           = "1.8"
      java_container         = "Tomcat"
      java_container_version = "8.5.31"
    }

    app_settings {
      "azure.keyvault.uri"                     = "${module.key_vault.uri}"
    }
}

resource "azurerm_app_service_slot" "slotDev" {
    name                = "dev"
    app_service_name    = "${azurerm_app_service.WebApp.name}"
    location            = "${azurerm_app_service.WebApp.location}"
    resource_group_name = "${azurerm_app_service.WebApp.resource_group_name}"
    app_service_plan_id = "${data.azurerm_app_service_plan.ServicePlan.id}"
}

resource "azurerm_app_service_slot" "slotPre" {
    name                = "pre"
    app_service_name    = "${azurerm_app_service.WebApp.name}"
    location            = "${azurerm_app_service.WebApp.location}"
    resource_group_name = "${azurerm_app_service.WebApp.resource_group_name}"
    app_service_plan_id = "${data.azurerm_app_service_plan.ServicePlan.id}"
}