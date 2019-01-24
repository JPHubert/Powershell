$locName = "South Central US"
Get-AzureRMVMImagePublisher -Location $locName | Select PublisherName

$pubName = "MicrosoftWindowsDesktop"
Get-AzureRMVMImageOffer -Location $locName -Publisher $pubName | Select Offer

$offerName = "Windows-10"
Get-AzureRMVMImageSku -Location $locName -Publisher $pubName -Offer $offerName | Select Skus