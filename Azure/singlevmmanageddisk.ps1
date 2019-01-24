#Input parameters
param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]
  $ResourceGroupName,

  [Parameter(Position = 1, Mandatory = $true)]
  [string]
  $VMName
)

#First Stop the VM
Write-Host "Stopping the VM " $VMName -ForegroundColor Yellow
Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMName # dont use -Force 

Write-Host "Converting the VM to Managed VM including Disks " $VMName -ForgroundColor Green
ConvertTo-AzureRmVMManagedDisk -ResourceGroupName $ResourceGroupName -VMName $VMName

Write-Host "Completed" -ForegroundColor Green