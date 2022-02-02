# Data Lake for Cross-functional teams

# Approach 1 (Main)

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

# Shared access signature (SAS) token which is valid for certain period.

![image](https://user-images.githubusercontent.com/23280140/152232071-fb03f5bb-63af-4b73-83ba-6a2477c81981.png)


# Data lake - Access Keys

Access keys authenticate the applications requests to the storage account.





