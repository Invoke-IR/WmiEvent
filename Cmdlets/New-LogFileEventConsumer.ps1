function New-LogFileEventConsumer
{
    [CmdletBinding()]
    Param(
        #region CommonParameters

        [Parameter(ParameterSetName = 'ByComputerName')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'ByComputerName')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'BySession')]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [Int32]
        $ThrottleLimit,
        
        #endregion CommonParameters

        #region LogFileParameters
        
        [Parameter(Mandatory)]
        [string]
        $Filename,
        
        [Parameter()]
        [bool]
        $IsUnicode,
        
        [Parameter()]
        [UInt64]
        $MaximumFileSize,
        
        [Parameter(Mandatory)]
        [string]
        $Text
        
        #endregion LogFileParameters
    )

    begin
    {
        $parameters = $PSBoundParameters

        if($PSBoundParameters.ContainsKey('ComputerName'))
        {
            if($PSBoundParameters.ContainsKey('Credential'))
            {
                #Here we have to get CimSessions
                $CimSession = New-CimSessionDcom -ComputerName $ComputerName -Credential $Credential
            }
            else
            {
                #Here we have to get CimSessions
                $CimSession = New-CimSessionDcom -ComputerName $ComputerName
            }
                
            #Remove ComputerName from $parameters
            $parameters.Remove('ComputerName') | Out-Null

            #Remove Credential from $parameters
            $parameters.Remove('Credential') | Out-Null

            #Add CimSessions to $parameters
            $parameters.Add('CimSession', $CimSession)
        }
    }

    process
    {
        $Jobs = New-LogFileEventConsumerX @parameters -AsJob

        Receive-Job -Job $Jobs -Wait

        $Jobs | Remove-Job
    }
    
    end
    {
        if($PSBoundParameters.ContainsKey('ComputerName'))
        {
            # Clean up the CimSessions we created to support the ComputerName parameter
            $CimSession | Remove-CimSession
        }
    }
}