<#
.SYNOPSIS
  This runbook will retrieve a key vault if one exists.
  
.DESCRIPTION
  This runbook will retrieve a key vault if one exists.

  PREREQUISITE
  This runbook uses system maanged identity for Azurelogin. Assign appropriate role for system managed identity under this Automation account before start this runbook.

  More details: https://learn.microsoft.com/azure/automation/enable-managed-identity-for-automation#assign-role-to-a-system-assigned-managed-identity

  PREREQUISITE
  The modules "Az.Accounts" and "Az.KeyVault" have to be imported into the automation account. They can be imported from
  the Module Gallery. 

.PARAMETER VaultName 
  Mandatory
  This is the name of the key vault.
  
.NOTES
  AUTHOR: Nina Li
  LASTEDIT: June 20, 2023
#>

param
(
	[Parameter (Mandatory=$true)]
	[string] $VaultName,
    [Parameter (Mandatory=$true)]
	[string] $SubscriptionId,
    [Parameter (Mandatory=$true)]
    [string] $ResourceGroupName
)

"Logging in to Azure..."
    # Ensures you do not inherit an AzContext in your runbook
    Disable-AzContextAutosave -Scope Process

    # Connect to Azure with system-assigned managed identity
    Connect-AzAccount -Identity

    # set and store context
    $AzureContext = Set-AzContext -SubscriptionId $SubscriptionId

# Try to retrieve the key vault.
$keyVault = Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName
if ($keyVault -eq $null)
{
	throw "Could not retrieve key vault $VaultName. Check that a key vault with this name exists in the resource group $ResourceGroupName."
}

# Return the key vault
$keyVault[0]
