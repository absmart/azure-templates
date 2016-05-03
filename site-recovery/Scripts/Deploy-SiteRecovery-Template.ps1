param(
    $AzureRmProfilePath
)

$NetworkRgName = "Network-01-EastUS2"
$VmRgName = "SiteRecovery-01-EastUS2"
$Location = "eastus2"

Get-AzureRmContext -ErrorAction Stop

try{ Get-AzureRMResourceGroup -Name $ResourceGroup -Location $Location }
catch{ New-AzureRMResourceGroup -Name $ResourceGroup -Location $Location }

$DeploymentName = $ResourceGroup + "-" + (Get-Date -Format yyyyMMdd)

# Site to site VPN setup

$VpnParameters = @{
    DeploymentName = $NetworkRgName + "-" + (Get-Date -Format yyyyMMdd)
    ResourceGroupName = $NetworkRgName
    TemplateUri = "https://raw.githubusercontent.com/absmart/azure-templates/master/site-recovery/vpn-site-to-site.json"

    location = $Location
    vpnType = "RouteBased"
    localGatewayName = "OnPrem-Gateway"
    localGatewayIpAddress = "111.222.333.444"
    localAddressPrefix = "192.168.0.0/16"
    virtualNetworkName = "ASR-01-EastUS2"
    azureVnetAddressPrefix = "10.0.0.0/16"
    subnetName = "ASR-Subnet-01"
    subnetPrefix = "10.0.1.0/24"
    gatewaySubnetPrefix = "10.0.5.0/29"
    gatewayPublicIpName = "azureGatewayIp"
    gatewayName = "azureGateway"
    gatewaySku = "Basic"
    connectionName = ""
    sharedKey = ""
}

Start-Job -Name $DeploymentName -ArgumentList @VpnParameters -ScriptBlock{
    param(
        $AzureRmProfilePath,
        $location,
		$vpnType,
		$localGatewayName,
		$localGatewayIpAddress,
		$localAddressPrefix,
		$virtualNetworkName,
		$azureVnetAddressPrefix,
		$subnetName,
		$SubnetPrefix,
		$gatewaySubnetPrefix,
		$gatewayPublicIpName,
		$gatewayName,
		$gatewaySku,
		$connectionName,
		$sharedKey
    )

    Select-AzureRmProfile -Profile $AzureRmProfilePath
    New-AzureRmResouceGroupDeployment @vpnparameters
}


# Process Server to write failback data from Azure to on-premises through VPN

$DeploymentName = $ResourceGroup + "-" + (Get-Date -Format yyyyMMdd)

$ProcessServerResourceGroup = $NetworkResourceGroupName
$ProcessServerUri = "https://raw.githubusercontent.com/absmart/azure-templates/master/site-recovery/process-server.json"

$ProcServerParameters = @{
    DeploymentName = $ResourceGroup + "-" + (Get-Date -Format yyyyMMdd)
    ResourceGroupName = $NetworkResourceGroupName
    TemplateUri = "https://raw.githubusercontent.com/absmart/azure-templates/master/site-recovery/vpn-site-to-site.json"

    vmName = ""
    availabilitySetName = ""
    storageAccountName = ""
    adminUsername = ""
    adminPassword = ""
    vmSize = ""
    virtualNetworkResourceGroup = ""
    virtualNetworkName = ""
    subnetName = ""
}

New-AzureRmResouceGroupDeployment -Name $DeploymentName -ResourceGroupName $ProcessServerResourceGroup -TemplateUri $ProcessServerUri