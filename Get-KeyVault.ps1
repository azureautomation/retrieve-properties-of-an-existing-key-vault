<#
.SYNOPSIS
  This runbook will retrieve a key vault if one exists.
  
.DESCRIPTION
  This runbook will retrieve a key vault if one exists.

  PREREQUISITE
  The automation account requires a System Managed Identity
  See the link below for more inforamtion
  
  https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation
  
  PREREQUISITE
  The Automation Account System Managed Identity needs to be granted permissions to read the Azure Key Vault
  See the link below for more inforamtion on how to grant permissions to Managed Identities
  
  https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal
  
  
  PREREQUISITE
  This runbook has been written and tested using PowerShell 5.1 and the Az modules version 6.0.0.0
  See the link below for more information
  
  https://learn.microsoft.com/en-us/azure/automation/shared-resources/modules

.PARAMETER VaultName 
  Mandatory
  This is the name of the key vault.
  
.PARAMETER ResourceGroupName 
  Mandatory
  This is the name of the resource group that the key vault is in.
  
.NOTES
  ORIGINAL AUTHOR: Andreas Wieberneit
  UPDATES: Brian McDermott
  LASTEDIT: June 13, 2023
#>

param
(
	[Parameter (Mandatory=$true)]
	[string] $VaultName,
	[Parameter (Mandatory=$true)]
	[string] $ResourceGroupName
)

# Authenticate to Azure using the Managed Identity
connect-azaccount -identity

# Try to retrieve the key vault.
$keyVault = Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName 
if ($keyVault -eq $null)
{
	throw "Could not retrieve key vault $VaultName. Check that a key vault with this name exists in the resource group $ResourceGroupName."
}

# Return the key vault
$keyVault[0]
