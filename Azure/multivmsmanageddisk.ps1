# Set variables.  vmlist and avsetlist are used to populate two or more resource names
$subscriptionid = "subscriptionid"
$vmlist = Get-Content C:\path\tofile\unmanagedvms.txt
$avsetlist = Get-Content C:\path\tofile\unmanagedavsets.txt
$rgname = "name of resource group"

# Connect to Azure account and set subscription
Connect-AzureRmAccount
Set-AzureRmContext -SubscriptionId $subscriptionid

#Convert AV sets to managed
foreach ($avsetname in $avsetlist) {
    Write-Host "Converting AV set to managed" $avsetlist -ForegroundColor Yellow
    $avset = Get-AzureRmAvailabilitySet -ResourceGroupName $rgname -Name $avsetname
    Update-AzureRmAvailabilitySet -AvailabilitySet $avset -Sku Aligned
}

# Stop VMs
foreach ($vmname in $vmlist) {
    Write-Host "Stopping VM" $vmname -ForegroundColor Yellow
    Stop-AzureRmVM -ResourceGroupName $rgname -Name $vmname -Force
}

# Convert to managed disk
foreach ($vmname in $vmlist) {
    Write-Host "Converting VM to managed disk" $vmname -ForegroundColor yellow
    ConvertTo-AzureRmVMManagedDisk -ResourceGroupName $rgname -Name $vmname
}