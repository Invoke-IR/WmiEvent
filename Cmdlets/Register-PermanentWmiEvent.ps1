function Register-PermanentWmiEvent
{
    [CmdletBinding()]
    Param(
        #region CommonParameters
        
        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'LogFileComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'SMTPComputerSet')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'LogFileComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'SMTPComputerSet')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'LogFileSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'SMTPSessionSet')]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,
        
        #endregion CommonParameters

        #region FilterParameters
        
        [Parameter(Mandatory)]
        [string]
        $EventNamespace,
        
        [Parameter(Mandatory)]
        [string]
        $Query,
        
        [Parameter(Mandatory)]
        [ValidateSet('WQL')]
        [string]
        $QueryLanguage,

        #endregion FilterParameters

        #region CommonConsumerParameters
        
        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptFileSessionSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [Parameter(ParameterSetName = 'ActiveScriptTextSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]$KillTimeout = 0,
        
        #endregion CommonConsumerParameters

        #region ActiveScriptParameters

        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileSessionSet')]
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextSessionSet')]
        [ValidateSet('VBScript', 'jscript')]
        [string]
        $ScriptingEngine,

        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileSessionSet')] 
        [ValidateNotNull()]
        [string]
        $ScriptFileName,
        
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextSessionSet')] 
        [ValidateNotNull()]
        [string]
        $ScriptText,
        
        #endregion ActiveScriptParameters
        
        #region CommandLineParameters
        
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateSessionSet')]
        [ValidateScript({Test-Path $_})]
        [string]
        $CommandLineTemplate,
        
        [Parameter(Mandatory, ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'CommandLineSessionSet')]
        [string]
        $ExecutablePath,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $CreateNewProcessGroup,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $CreateSeparateWowVdm,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $CreateSharedWowVdm,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $ForceOffFeedback,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $ForceOnFeedback,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [ValidateSet(0x20, 0x40, 0x80, 0x100)]
        [Int32]
        $Priority,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $RunInteractively,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [ValidateRange(0x00,0x0A)]
        [UInt32]
        $ShowWindowCommand,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [bool]
        $UseDefaultErrorMode,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [string]
        $WindowTitle,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [string]
        $WorkingDirectory,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $XCoordinate,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $XNumCharacters,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $XSize,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $YCoordinate,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $YNumCharacters,
        
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineSessionSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineTemplateSessionSet')]
        [UInt32]
        $YSize,
        
        #endregion CommandLineParameters

        #region LogFileParameters
        
        [Parameter(Mandatory, ParameterSetName = 'LogFileComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'LogFileSessionSet')]
        [string]
        $Filename,
        
        [Parameter(ParameterSetName = 'LogFileComputerSet')]
        [Parameter(ParameterSetName = 'LogFileSessionSet')]
        [bool]
        $IsUnicode,
        
        [Parameter(ParameterSetName = 'LogFileComputerSet')]
        [Parameter(ParameterSetName = 'LogFileSessionSet')]
        [UInt64]
        $MaximumFileSize,
        
        [Parameter(Mandatory, ParameterSetName = 'LogFileComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'LogFileSessionSet')]
        [string]
        $Text,
        
        #endregion LogFileParameters

        #region NtEventLogParameters
        
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogSessionSet')]
        [ValidateNotNull()]
        [UInt16]
        $Category,
        
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogSessionSet')]
        [ValidateNotNull()]
        [UInt32]
        $EventID,
        
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogSessionSet')]
        [ValidateSet(0x00, 0x01, 0x02, 0x04, 0x08, 0x10)]
        [ValidateNotNull()]
        [UInt32]
        $EventType,
        
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogSessionSet')]
        [string[]]
        $InsertionStringTemplates,
        
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogSessionSet')]
        [string]
        $NameOfUserSidProperty,
        
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogSessionSet')]
        [string]
        $NameOfRawDataProperty,
        
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'NtEventLogSessionSet')]
        [ValidateScript({$_ -notlike '*:*'})]
        [ValidateNotNull()]
        [string]
        $SourceName,
        
        [Parameter(ParameterSetName = 'NtEventLogComputerSet')]
        [Parameter(ParameterSetName = 'NtEventLogSessionSet')]
        [string]$UNCServerName,
        
        #endregion NtEventLogParameters

        #region SMTPParameters
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string]
        $BccLine,
        
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string]
        $CcLine,
        
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string]
        $FromLine,
        
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string[]]
        $HeaderFields,
        
        [Parameter(Mandatory, ParameterSetName = 'SmtpComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'SmtpSessionSet')]
        [string]
        $Message,
        
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string]
        $ReplyToLine,
        
        [Parameter(Mandatory, ParameterSetName = 'SmtpComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'SmtpSessionSet')]
        [ValidateNotNull()]
        [string]
        $SMTPServer,
        
        [Parameter(ParameterSetName = 'SmtpComputerSet')]
        [Parameter(ParameterSetName = 'SmtpSessionSet')]
        [string]
        $Subject,
        
        [Parameter(Mandatory, ParameterSetName = 'SmtpComputerSet')]
        [Parameter(Mandatory, ParameterSetName = 'SmtpSessionSet')]
        [string]
        $ToLine
        
        #endregion SMTPParameters
    )

    begin
    {
        $FilterParamKeys = $PSBoundParameters.Keys | Where-Object { $_ -in (Get-Command New-WmiEventFilter | ForEach-Object Parameters | ForEach-Object Keys) }
        $FilterProps = @{}
        $FilterParamKeys | ForEach-Object { $FilterProps[$_] = $PSBoundParameters[$_] }
        
        $ConsumerParamKeys = $PSBoundParameters.Keys | Where-Object { $_ -in (Get-Command New-WmiEventConsumer | ForEach-Object Parameters | ForEach-Object Keys) }
        $ConsumerProps = @{}
        $ConsumerParamKeys | ForEach-Object { $ConsumerProps[$_] = $PSBoundParameters[$_] }

        if($PSCmdlet.ParameterSetName.Contains('ComputerSet'))
        {
            if($PSBoundParameters.ContainsKey('ComputerName'))
            {
                if($PSBoundParameters.ContainsKey('Credential'))
                {
                    #Here we have to get CimSessions
                    $CimSession = New-CimSessionDcom -ComputerName $ComputerName -Credential $Credential
                    $FilterProps.Remove('Credential')
                    $ConsumerProps.Remove('Credential')
                }
                else
                {
                    #Here we have to get CimSessions
                    $CimSession = New-CimSessionDcom -ComputerName $ComputerName
                }
                $FilterProps.Remove('ComputerName')
                $ConsumerProps.Remove('ComputerName')
            }
        }
        else
        {
            $FilterProps.Remove('CimSession')
            $ConsumerProps.Remove('CimSession')
        }
    }

    process
    {
        if(($PSBoundParameters.ContainsKey('ComputerName')) -or ($PSBoundParameters.ContainsKey('CimSession')))
        {                
            foreach($s in $CimSession)
            {
                $Filter = New-WmiEventFilter @FilterProps -CimSession $s

                if($PSCmdlet.ParameterSetName.Contains('ActiveScript'))
                {
                    $Consumer = New-ActiveScriptEventConsumer @ConsumerProps -CimSession $s
                }
                elseif($PSCmdlet.ParameterSetName.Contains('CommandLine'))
                {
                    $Consumer = New-CommandLineEventConsumer @ConsumerProps -CimSession $s
                }
                elseif($PSCmdlet.ParameterSetName.Contains('LogFile'))
                {
                    $Consumer = New-LogFileEventConsumer @ConsumerProps -CimSession $s
                }
                elseif($PSCmdlet.ParameterSetName.Contains('NtEventLog'))
                {
                    $Consumer = New-NtEventLogEventConsumer @ConsumerProps -CimSession $s
                }
                elseif($PSCmdlet.ParameterSetName.Contains('Smtp'))
                {
                    $Consumer = New-SmtpEventConsumer @ConsumerProps -CimSession $s
                }
                else
                {
                    Write-Error -Message 'Invalid Consumer Type'
                }

                New-WmiEventSubscription -Filter $Filter -Consumer $Consumer -CimSession $s
            }
        }
        else
        {
            $Filter = New-WmiEventFilter @FilterProps

            if($PSCmdlet.ParameterSetName.Contains('ActiveScript'))
            {
                $Consumer = New-ActiveScriptEventConsumer @ConsumerProps
            }
            elseif($PSCmdlet.ParameterSetName.Contains('CommandLine'))
            {
                $Consumer = New-CommandLineEventConsumer @ConsumerProps
            }
            elseif($PSCmdlet.ParameterSetName.Contains('LogFile'))
            {
                $Consumer = New-LogFileEventConsumer @ConsumerProps
            }
            elseif($PSCmdlet.ParameterSetName.Contains('NtEventLog'))
            {
                $Consumer = New-NtEventLogEventConsumer @ConsumerProps
            }
            elseif($PSCmdlet.ParameterSetName.Contains('Smtp'))
            {
                $Consumer = New-SmtpEventConsumer @ConsumerProps
            }
            else
            {
                Write-Error -Message 'Invalid Consumer Type'
            }

            New-WmiEventSubscription -Filter $Filter -Consumer $Consumer -CimSession $s
        }
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