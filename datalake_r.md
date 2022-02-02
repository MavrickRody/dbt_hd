# Data Lake for Cross-functional teams

## We can manage this access with Access control (IAM) and role assignement in Azure

![image](https://user-images.githubusercontent.com/23280140/152230829-068c3cb4-9d18-45d1-ac29-2ac6c68ac511.png)

Access Control with Role Assignment

![image](https://user-images.githubusercontent.com/23280140/152231036-4954966e-4c77-4468-b04a-58b93e36393b.png)

## Managing this role assigment with terraform 

azurerm_role_assignment
Assigns a given Principal (User or Group) to a given Role.

Example Usage (using a built-in Role)


```
data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "example" {
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

```
