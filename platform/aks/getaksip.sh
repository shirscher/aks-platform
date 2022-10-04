resource_group="rg-omni-aks-p01"
cluster_name="aks-omni-p01"

$aks_cluster = az aks show -g $resource_group -n $cluster_name 2>&1

if ($aks_cluster -Match "ResourceNotFoundError*") {
    Write-Host "Could not find AKS cluster"
}

# Find resource group that contains load balancer
$node_resource_group = ($aks_cluster | ConvertFrom-Json).nodeResourceGroup

$lb = az network lb show --n kubernetes -g $node_resource_group | ConvertFrom-Json

# Find load balancing rule that serves port 443. Could also use port 80
$rule = $lb.loadBalancingRules | Where-Object { $_.frontendPort -eq 443 }

# Find front-end IP config that uses this load balancing rule
$front_end_config = $lb.frontendIpConfigurations | Where-Object { ($_.loadBalancingRules | Where-Object { $_.id -eq $rule.id }) -ne $null }

$public_ip = az network public-ip show --ids $front_end_config.publicIpAddress.id | ConvertFrom-Json

$public_ip_address = $public_ip.ipAddress