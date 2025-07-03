param acrName string = 'testingazure'
param webAppName string = 'testingazurewebapp${uniqueString(resourceGroup().id)}'
param planName string = 'testingazurewebapp-free'
param dockerImageTag string = 'latest'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: resourceGroup().location
  sku: { name: 'Basic' }
  properties: { adminUserEnabled: true }
}

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: planName
  location: resourceGroup().location
  kind: 'linux'
  sku: { name: 'B1', tier: 'Basic' }
  properties: { reserved: true }
}

resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: resourceGroup().location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/${webAppName}:${dockerImageTag}'
      appSettings: [
        { name: 'WEBSITES_PORT', value: '80' }
        // { name: 'YOUR_SECRET', value: 'value' }    # add more as needed
      ]
      alwaysOn: true
    }
    httpsOnly: true
  }
}
