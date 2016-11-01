$ServiceName= "das-$env:environmentname-$env:type-ai"

$Location= "North Europe"

$ResourceGroupName = "das-$env:environmentname-$env:type-rg"

##Login to Subscription##
$uid = "e8d34963-8a5c-4d62-8778-0d47ee0f22fa"
$pwd = $env:spipwd
$tenantId = "1a92889b-8ea1-4a16-8132-347814051567"
$secPwd = ConvertTo-SecureString $pwd -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($uid, $secPwd)

Add-AzurermAccount -ServicePrincipal -Tenant $tenantId -Credential $credentials
#Set-AzureSubscription –SubscriptionName $env:subscription
Select-AzureSubscription -Default -SubscriptionName $env:subscription
    
$Default= Get-AzureSubscription -SubscriptionName $env:subscription
write-host $Default.IsCurrent



If($env:ApplicationInsights -eq 'True'){
If($Default.IsCurrent -eq 'True'){

Write-Host "Preparing Application Insights '$ServiceName' in resource group '$ResourceGroupName'"
           
 Select-AzureRmSubscription -SubscriptionName $env:subscription

$Default= Get-AzureRmSubscription -SubscriptionName $env:subscription
Write-Host $Default.SubscriptionName           
          
try{            
    $service = Get-AzureRmResource -ResourceGroupName $ResourceGroupName -ResourceName $ServiceName -ResourceType microsoft.insights/components
} 
catch{}

if($service)
{
	Write-Host -ForegroundColor Yellow "Application Insights Already Exists'$ServiceName'";

}
else
{
   
   Write-Host "No Application Insights exists, creating new..."

   New-AzureRmResource -ResourceName $ServiceName -ResourceGroupName $ResourceGroupName -resourcetype "Microsoft.Insights/Components" -Location "Central US" -PropertyObject @{"Type"="ASP.NET"} -Force

}

Write-Host "[service online]" -ForegroundColor Green

}
else 
{
write-host "Not in Correct Subscription"
}

}