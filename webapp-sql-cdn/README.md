# Azure Web App with Deployment Slots

This template deploys an Azure Web App with options to setup a Service Plan, autoscaling for the Service Plan, deployment slots and a storage account for logging.

The template completes the following steps:
 - Creates a storage account that can be used to capture IIS and Application logs from the Web App. Not used explicitly.
 - Create or modify an existing Service Plan for Azure Web App.
 - Create or modify an existing Azure Web App and define AppSettings, ConnectionStrings.
 - Create or modify Deployment Slots and specify slot specific AppSettings and ConnectionStrings.
 - Create or modify an Application Insights resource.
 - Create or modify an Azure SQL Server and Database.
 - Create or modify a CDN profile and endpoint.