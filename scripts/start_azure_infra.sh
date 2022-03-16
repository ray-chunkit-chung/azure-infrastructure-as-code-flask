#!/bin/bash

# Create a resource group.
az group create --location $LOCATION --name $RESOURCEGROUP_NAME --subscription $SUBSCRIPTION_NAME

# Create serverfarm and web app from a single template.
az deployment group create --resource-group $RESOURCEGROUP_NAME \
--template-file ArmTemplate/AppService/template.json \
--parameters ArmTemplate/AppService/parameters.json

echo "You can now browse to http://$WEB_APP_NAME.azurewebsites.net"


############################################################################################
# Before continuing, go to your DNS configuration UI for your custom domain and follow the 
# instructions at https://aka.ms/appservicecustomdns to configure a CNAME record for the 
# hostname "www" and point it your web app's default domain name.
############################################################################################

# fqdn=<Replace with www.{yourdomain}>

# echo "Configure a CNAME record that maps $fqdn to $WEBAPPNAME.azurewebsites.net"
# read -p "Press [Enter] key when ready ..."

# # Map your prepared custom domain name to the web app.
# az webapp config hostname add --webapp-name $WEBAPPNAME --resource-group $RESOURCEGROUPNAME --hostname $fqdn

# echo "You can now browse to http://$fqdn"


############################################################################################
# Other deploy options
############################################################################################

# Create an App Service plan in SHARED tier (minimum required by custom domains).
# az appservice plan create --name $webappname --resource-group myResourceGroup --sku SHARED

# Create a web app.
# az webapp create --name $WEBAPPNAME --resource-group $RESOURCEGROUPNAME --plan $WEBAPPNAME


azure-infrastructure-as-code-flask

