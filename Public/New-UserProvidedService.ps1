<#
.Synopsis
   Creates a new cloud foundry user provided service
.DESCRIPTION
   The New-UserProvidedService cmdlet creates a new user provided services and returns the object as defined by the API
.PARAMETER Org
    This parameter is the Org object
.PARAMETER Name
    This parameter is the name of the new space
.PARAMETER Params
    This parameter is the parameters for the user provided service
.PARAMETER SyslogDrainUrl
    This parameter is the sys log drain url
.PARAMETER RouteServiceUrl
    This parameter is the route service url
#>
function New-UserProvidedService {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [psobject]
        $Space,

        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Position = 1)]
        $Params,

        [Parameter(Position = 2)]
        [String]
        $SyslogDrainUrl,

        [Parameter(Position = 3)]
        [String]
        $RouteServiceUrl
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        
        $base = Get-BaseHost
        $url = "$($base)/v2/user_provided_service_instances"
        $body = @{
            "credentials"=$Params
            "name"=$Name
            "route_service_url"= $RouteServiceUrl
            "space_guid"=$Space.metadata.guid
            "syslog_drain_url"=$SyslogDrainUrl
        }
        $header = Get-Header
        $response = (Invoke-WebRequest -Uri $url -Method Post -Header $header -Body ($body | ConvertTo-Json))
        Write-Debug $response
        if ($response.StatusCode -ne 201) {
            $message = "New-UserProvidedService: $($url) $($response.StatusCode)"
            Write-Error -Message $message
            throw $message
        }
        Write-Output ($response | ConvertFrom-Json)
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}
