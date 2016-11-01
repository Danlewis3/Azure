if($env:RemoveDeployment  -eq 'true')
{
    $ServiceName= "das-$env:EnvironmentName-$env:type-cs"

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

    If($Default.IsCurrent -eq 'True')
    {
        $service = Get-AzureService -ServiceName $ServiceName
        if($service)
        {
            Remove-AzureDeployment -ServiceName $ServiceName
        }
        else
        {
            Write-Host "Cannot find cloud service $ServiceName"
        }
    }
    else
    {
        write-host "Not in Correct Subscription"
    }
}
else 
{
    Write-Host 'Deployment removal is disabled'
}
