<#
.Synopsis
   Creates a new cloud foundry service but does not wait to complete
.DESCRIPTION
   The New-Service cmdlet creates a new service and returns the service object as defined by the API
.PARAMETER Space
    This parameter is the Space object
.PARAMETER ServicePlans
    This parameter is the available service plans for the space
.PARAMETER Plan
    This parameter is the the name of the plan to use
.PARAMETER Name
    This parameter is the the name of the service instance
.PARAMETER params
    This parameter is an dictionary of the parameters
.EXAMPLE  

#>
function New-ServiceAsync {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [psobject]
        $Space,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Plan,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        $params = @()
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        $service = Get-Service -Space $space -Name $servicename
        Write-Debug ($service | ConvertTo-Json -Depth 20)
        $serviceplans = Get-ServicePlan -Service $service
        Write-Debug ($serviceplans | ConvertTo-Json -Depth 20)
        Write-Output (New-Service $Space $serviceplans $Plan $Name $Params)
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}
