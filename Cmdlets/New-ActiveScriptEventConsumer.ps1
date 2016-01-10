function New-ActiveScriptEventConsumer
{
    [CmdletBinding()]
    Param(
        #region CommonParameters

        [Parameter(ParameterSetName = 'FileNameByComputerName')]
        [Parameter(ParameterSetName = 'ScriptTextByComputerName')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'FileNameByComputerName')]
        [Parameter(ParameterSetName = 'ScriptTextByComputerName')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'FileNameBySession')]
        [Parameter(Mandatory, ParameterSetName = 'ScriptTextBySession')] 
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

        #region ActiveScriptParameters

        [Parameter()]
        [UInt32]
        $KillTimeout,

        [Parameter(Mandatory)]
        [ValidateSet('VBScript', 'jscript')]
        [string]
        $ScriptingEngine,

        [Parameter(Mandatory, ParameterSetName = 'FileNameByComputerName')] 
        [Parameter(Mandatory, ParameterSetName = 'FileNameBySession')] 
        [ValidateNotNull()]
        [string]
        $ScriptFileName,
        
        [Parameter(Mandatory, ParameterSetName = 'ScriptTextByComputerName')] 
        [Parameter(Mandatory, ParameterSetName = 'ScriptTextBySession')] 
        [ValidateNotNull()]
        [string]
        $ScriptText
        
        #endregion ActiveScriptParameters
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
        $Jobs = New-ActiveScriptEventConsumerX @parameters -AsJob

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