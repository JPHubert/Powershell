param(
    [string]$tenantId="c3ee3519-57e6-471b-bc4b-57c422e89a62",
    [string]$file="e:\Azure-ARM-VMs.csv"
) 

if ($tenantId -eq "") {
    Login-AzAccount 
    $subs = Get-AzSubscription
} else {
    Login-AzAccount -tenantid $tenantId 
    $subs = Get-AzSubscription -TenantId $tenantId 
}


$vmobjs = @()

foreach ($sub in $subs)
{
    
    Write-Host Processing subscription $sub.SubscriptionName

    try
    {

        Select-AzSubscription -SubscriptionId $sub.SubscriptionId -ErrorAction Continue

        $vms = Get-AzVM 

        foreach ($vm in $vms)
        {
            $vmInfo = [pscustomobject]@{
                'Subscription'=$sub.SubscriptionName
                'Mode'='ARM'
                'Name'=$vm.Name
                'OSType' = $vm.StorageProfile.OsDisk.OsType
                'ResourceGroupName' = $vm.ResourceGroupName
                'Location' = $vm.Location
                'VMSize' = $vm.HardwareProfile.VMSize
                'Status' = $null
                'AvailabilitySet' = $vm.AvailabilitySetReference.Id 
                'ManagedDisk' = $vm.StorageProfile.OsDisk.ManagedDisk
                'AzureAgent' = $vm.OSProfile.WindowsConfiguration.ProvisionVMAgent }
        
            $vmStatus = $vm | Get-AzVM -Status
            $vmInfo.Status = $vmStatus.Statuses[1].DisplayStatus

            $vmobjs += $vmInfo

        }  
    }
    catch
    {
        Write-Host $error[0]
    }
}

$vmobjs | Export-Csv -NoTypeInformation -Path $file
Write-Host "VM list written to $file"