Param(
  [string]$sqlPasswordPara
)

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

#SQL Variables

$sqlServerVersion = "12.0"
$sqlServerLocation = "North Europe"
$databaseEdition = "Standard"
$databaseServiceLevel = "S0"
$resourcegroupName= "das-$env:EnvironmentName-$env:type-rg"


if ($env:type -eq 'comt')
{
$serverAdmin="comt-admsq"
}
elseif ($env:type -eq 'eas')
{
$serverAdmin="daseas-dbadmn"
}
elseif ($env:type -eq 'evt')
{
$serverAdmin="evtadm-1620"
}
else
{
$serverAdmin="sqlt4sk4dm"
} 






if($sqlPasswordPara){
    $securePassword = ConvertTo-SecureString "$sqlPasswordPara" -AsPlainText -Force
    $serverCreds = New-Object System.Management.Automation.PSCredential ($serverAdmin, $securePassword)
}
else
{
    $securePassword = ConvertTo-SecureString "$env:SQLServerPassworddb" -AsPlainText -Force
    $serverCreds = New-Object System.Management.Automation.PSCredential ($serverAdmin, $securePassword)    
}
$sqlServerName = "das-$env:EnvironmentName-$env:type-sql"
$databaseName = "das-$env:EnvironmentName-$env:type-db"

If($Default.IsCurrent -eq 'True'){

#Azure SQL Server
Select-AzureRmSubscription -SubscriptionName $env:subscription

$Default= Get-AzureRmSubscription -SubscriptionName $env:subscription
Write-Host $Default.SubscriptionName

Get-AzureRmSqlServer -ResourceGroupName $resourcegroupName -ServerName $sqlServerName -ev notPresent -ea 0

if ($notPresent)
{
  write-host -ForegroundColor Yellow  "Creating Azure SQL Server das-$env:EnvironmentName-$env:type-sql" 
  $sqlServer = New-AzureRmSqlServer -ServerName $sqlServerName -SqlAdministratorCredentials $ServerCreds -Location $sqlServerLocation -ResourceGroupName $resourceGroupName -ServerVersion $sqlServerVersion
}
else
{
  write-host -ForegroundColor Yellow  "Azure SQL Server das-$env:EnvironmentName-$env:type-sql already deployed "
}

}
else 
{
write-host "Not in Correct Subscription"
}
