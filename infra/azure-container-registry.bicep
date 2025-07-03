// ---------------------------- Init parameters ----------------------------

@description('Location of the container registry')
param location string

@description('The name of the container registry')
param containerRegistryName string

// ---------------------------- Container Registry Setup ----------------------------

@description('The Container Registry type')
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param sku string = 'Basic'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: true
  }
}
