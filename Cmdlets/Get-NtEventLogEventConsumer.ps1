function Get-NtEventLogEventConsumer
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

        [Parameter(Mandatory, ParameterSetName = 'ByCimSession')]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [Int32]
        $ThrottleLimit = 32
        
        #endregion CommonParameters
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
        $Jobs = Get-NtEventLogEventConsumerX @parameters -AsJob -ThrottleLimit $ThrottleLimit

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