
# Getting started on Azure infrastructure as code
App link
 - https://infra-as-code-starter-ray-chunkit-chung.azurewebsites.net/

## Quick start
Install azure cli windows
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-powershell

Or install azure cli linux
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

Use
```
source .env
```
to source environment variables in .env file
```
export SUBSCRIPTION_ID=foo-bar-foo-foo-bar
export SUBSCRIPTION_NAME=foo-bar-foo-foo-bar
export RESOURCEGROUP_NAME=foo-bar-foo-foo-bar
export LOCATION=eastus
export WEB_APP_NAME=foo-bar-foo-foo-bar
```

Create
```
#!/bin/bash

# Create a resource group.
az group create --location $LOCATION --name $RESOURCEGROUP_NAME --subscription $SUBSCRIPTION_NAME

# Create serverfarm and web app from a single template.
az deployment group create --resource-group $RESOURCEGROUP_NAME \
--template-file ArmTemplate/AppService/template.json \
--parameters ArmTemplate/AppService/parameters.json

echo "You can now browse to http://$WEB_APP_NAME.azurewebsites.net"
```

Two Azure resources are defined in the above template:
 - Microsoft.Web/serverfarms: create an App Service plan.
 - Microsoft.Web/sites: create an App Service app.

More examples to deploy web apps
 - https://docs.microsoft.com/en-us/azure/app-service/quickstart-arm-template?pivots=platform-linux

Delete a resource group
```
az group delete --name $RESOURCEGROUP_NAME
```

Export existing templates
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/export-template-cli
```
# To export all resources in a resource group, use az group export and provide the resource group name
az group export --name demoGroup

az group export --name demoGroup > exportedtemplate.json

# To export one resource, pass that resource ID
storageAccountID=$(az resource show --resource-group demoGroup --name demostg --resource-type Microsoft.Storage/storageAccounts --query id --output tsv)
az group export --resource-group demoGroup --resource-ids $storageAccountID

# To export more than one resource
az group export --resource-group <resource-group-name> --resource-ids $storageAccountID1 $storageAccountID2

# To get application-scope credentials
az webapp deployment list-publishing-profiles --resource-group <group-name> --name <app-name>
```


# Getting start docs
 - https://devblogs.microsoft.com/devops/what-is-infrastructure-as-code/
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/?WT.mc_id=azuredevops-azuredevops-jagord
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax?WT.mc_id=azuredevops-azuredevops-jagord
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameters
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/variables
 - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-cloud-consistency
 - https://docs.microsoft.com/en-us/learn/paths/deploy-manage-resource-manager-templates/
 - https://docs.microsoft.com/en-us/azure/app-service/deploy-configure-credentials?tabs=cli

# Best practices
 - Limit the size of your template to 4 MB. 
 - 256 parameters
 - 256 variables
 - 800 resources (including copy count)
 - 64 output values
 - 24,576 characters in a template expression
 - Minimize your use of parameters. Instead, use variables or literal values
 - Use camel case for parameter names
 - Use parameters for settings that vary according to the environment, like SKU, size, or capacity
 - Use parameters for resource names that you want to specify for easy identification
 - Provide a description of every parameter in the metadata
 - Define default values for parameters that aren't sensitive
 - Always use parameters for user names and passwords (or secrets). Use securestring for all passwords and secrets
 - Use parameter location resourceGroup().location
 - Use camel case for variable names.
 - Don't use variables/parameters for the API version.
 - If the storage account is deployed in the same template that you're creating and the name of the storage account isn't shared with another resource in the template, you don't need to specify the provider namespace or the apiVersion when you reference the resource

```
"diagnosticsProfile": {
  "bootDiagnostics": {
    "enabled": "true",
    "storageUri": "[reference(variables('storageAccountName')).primaryEndpoints.blob]"
  }
}
```

 - or an existing storage account that's in a different resource group

```
"diagnosticsProfile": {
  "bootDiagnostics": {
    "enabled": "true",
    "storageUri": "[reference(resourceId(parameters('existingResourceGroup'), 'Microsoft.Storage/storageAccounts', parameters('existingStorageAccountName')), '2019-06-01').primaryEndpoints.blob]"
  }
}
```

 - Assign public IP addresses to a virtual machine only when an application requires it
 - To connect to a virtual machine (VM) for debugging, or for management or administrative purposes, use inbound NAT rules, a virtual network gateway, or a jumpbox
 - The domainNameLabel property for public IP addresses must be unique
 - When you add a password to a custom script extension, use the commandToExecute property in the protectedSettings property
 - Specify explicit values for properties that have default values that could change over time
 - Use ARM template test toolkit, a script that checks whether your template uses recommended practice
 - Ensure template functions work
 - Use nested templates across regions Working with linked artifacts
 - Make linked templates accessible across clouds
 - Use \_artifactsLocation instead of hardcoding links
 - Factor in differing regional capabilities. Regions can differ in availability of Azure services or updates
 - Verify the version of all resource types: A set of properties is common for all resource types, but each resource also has its own specific properties. New features and related properties are added to existing resource types at times through a new API version
 - Refer to resource locations with a parameter
 - Track versions using API profiles
 - Check endpoint references
 - Refer to existing resources by unique ID
 - Ensure VM images are available
 - Check local VM sizes
 - Check use of Azure Managed Disks in Azure Stack
 - Check that VM extensions are available
 - Ensure that versions are available
 - Do make use of testing tools
 - Perform static code analysis with unit tests and integration tests
 - Tests should only warn when an issue is found
 - 


# Connecting to virtual machines for debug
 - https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/n-tier-sql-server
 - https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm
 - https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nsg-quickstart-portal
 - https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nsg-quickstart-powershell
 - https://docs.microsoft.com/en-us/azure/virtual-machines/linux/nsg-quickstart


# DataDog

Get stuck on the first line. Datadog cannot get the message from my local agent.
```
docker run -d --name dd-agent -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e DD_API_KEY=foo-bar-foo-foo-bar -e DD_SITE="us3.datadoghq.com" gcr.io/datadoghq/agent:7
```


# Docker Desktop
Docker Desktop x VSCode is very good. Successfully encapsulate all the things I need.

If you have unix socket issue, which prevent you from building or pulling dockerhub images, see this Fix Docker VS Code Error: connect EACCES /var/run/docker.sock

 - https://www.davidhayden.me/blog/fix-docker-vs-code-error-connect-eacces-var-run-docker-sock
 - https://code.visualstudio.com/docs/containers/troubleshooting
 - https://docs.docker.com/engine/install/linux-postinstall/

If you still get the error, see this

 - https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket

```
sudo chmod 666 /var/run/docker.sock
```

# Web server

Good exmaples to setup production servers 

 - https://testdriven.io/blog/dockerizing-flask-with-postgres-gunicorn-and-nginx/
 - https://testdriven.io/blog/dockerizing-django-with-postgres-gunicorn-and-nginx/
 - https://docs.gunicorn.org/en/stable/deploy.html

## Reverse proxy
 - https://www.nginx.com/resources/glossary/reverse-proxy-server/

## WSGI
 - https://vsupalov.com/what-is-gunicorn/#:~:text=Gunicorns%20takes%20care%20of%20running,pretty%20darn%20fast%20about%20it.
 - https://towardsdatascience.com/my-favorite-python-servers-to-deploy-into-production-d92289764fbe

## ASGI
 - https://learn.vonage.com/blog/2021/11/19/how-wsgi-vs-asgi-is-like-baking-a-cake/

# Modified from

## Tutorial link
https://docs.microsoft.com/en-us/azure/app-service/quickstart-python?tabs=flask%2Cwindows%2Cazure-portal%2Cterminal-bash%2Cvscode-deploy%2Cdeploy-instructions-azportal%2Cdeploy-instructions-zip-azcli

## Deploy a Python (Flask) web app to Azure App Service - Sample Application

This is the sample Flask application for the Azure Quickstart [Deploy a Python (Django or Flask) web app to Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/quickstart-python).  For instructions on how to create the Azure resources and deploy the application to Azure, refer to the Quickstart article.

A Django sample application is also available for the article at [https://github.com/Azure-Samples/msdocs-python-django-webapp-quickstart](https://github.com/Azure-Samples/msdocs-python-django-webapp-quickstart).

If you need an Azure account, you can [create on for free](https://azure.microsoft.com/en-us/free/).
