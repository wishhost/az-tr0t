#Create new add_new.tf

resource "azurerm_resource_group" "test" {
name = "${var.prefix}-resources"
location = "${var.location}"
}

resource "azurerm_servicebus_namespace" "example" {
name = "xyzsevicebusn01s"
location = "${azurerm_resource_group.test.location}"
resource_group_name = "${azurerm_resource_group.test.name}"
sku = "Standard"
tags = {
source = "terraform"
}

}

resource "azurerm_servicebus_topic" "example" {
name = "events"
resource_group_name = "${azurerm_resource_group.test.name}"
namespace_name = "${azurerm_servicebus_namespace.test.name}"
enable_partitioning = true
}

resource "azurerm_storage_account" "test" {
name = "xyzstorageaccount09"
resource_group_name = "${azurerm_resource_group.test.name}"
location = "${azurerm_resource_group.test.location}"
account_tier = "Standard"
account_replication_type = "LRS"

}

resource "azurerm_app_service_plan" "test" {
name = "azure-functions-test-service-plan"
location = "${azurerm_resource_group.test.location}"
resource_group_name = "${azurerm_resource_group.test.name}"
kind = "FunctionApp"
sku {
tier = "Dynamic"
size = "Y1"
}

}

resource "azurerm_function_app" "test" {
name = "test-xyzcompany-functions"
location = "${azurerm_resource_group.test.location}"
resource_group_name = "${azurerm_resource_group.test.name}"
app_service_plan_id = "${azurerm_app_service_plan.test.id}"
storage_connection_string = "${azurerm_storage_account.test.primary_connection_string}"
app_settings = {
"ServiceBusConnectionString" = "some-value"

}

}
