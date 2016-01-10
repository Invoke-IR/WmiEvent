function New-CommandLineEventConsumer
{
    [CmdletBinding()]
    Param(
        #region CommonParameters

        [Parameter(ParameterSetName = 'CommandLineTemplateByComputerName')]
        [Parameter(ParameterSetName = 'ExecutablePathByComputerName')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'CommandLineTemplateByComputerName')]
        [Parameter(ParameterSetName = 'ExecutablePathByComputerName')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateBySession')]
        [Parameter(Mandatory, ParameterSetName = 'ExecutablePathBySession')]
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

        #region CommandLineParameters
        
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateByComputerName')]
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateBySession')]
        [ValidateScript({Test-Path $_})]
        [string]
        $CommandLineTemplate,
        
        [Parameter(Mandatory, ParameterSetName = 'ExecutablePathByComputerName')]
        [Parameter(Mandatory, ParameterSetName = 'ExecutablePathBySession')]
        [string]
        $ExecutablePath,
        
        [Parameter()]
        [bool]
        $CreateNewProcessGroup,
        
        [Parameter()]
        [bool]
        $CreateSeparateWowVdm,
        
        [Parameter()]
        [bool]
        $CreateSharedWowVdm,
        
        [Parameter()]
        [bool]
        $ForceOffFeedback,
        
        [Parameter()]
        [bool]
        $ForceOnFeedback,
        
        [Parameter()]
        [ValidateSet(0x20, 0x40, 0x80, 0x100)]
        [Int32]
        $Priority,
        
        [Parameter()]
        [bool]
        $RunInteractively,
        
        [Parameter()]
        [ValidateRange(0x00,0x0A)]
        [UInt32]
        $ShowWindowCommand,
        
        [Parameter()]
        [bool]
        $UseDefaultErrorMode,
        
        [Parameter()]
        [string]
        $WindowTitle,
        
        [Parameter()]
        [string]
        $WorkingDirectory,
        
        [Parameter()]
        [UInt32]
        $XCoordinate,
        
        [Parameter()]
        [UInt32]
        $XNumCharacters,
        
        [Parameter()]
        [UInt32]
        $XSize,
        
        [Parameter()]
        [UInt32]
        $YCoordinate,
        
        [Parameter()]
        [UInt32]
        $YNumCharacters,
        
        [Parameter()]
        [UInt32]
        $YSize
        
        #endregion CommandLineParameters
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
        $Jobs = New-CommandLineEventConsumerX @parameters -AsJob

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