function New-WmiEventSubscription
{
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = 'ComputerByNameSet')]
        [Parameter(ParameterSetName = 'ComputerByValueSet')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'ComputerByNameSet')]
        [Parameter(ParameterSetName = 'ComputerByValueSet')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'SessionByNameSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByValueSet')]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory, ParameterSetName = 'ComputerByNameSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByNameSet')]
        [string]
        $FilterName,
        
        [Parameter(Mandatory, ParameterSetName = 'ComputerByNameSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByNameSet')]
        [ValidateSet('ActiveScriptEventConsumer', 'CommandLineEventConsumer', 'LogFileEventConsumer', 'NtEventLogEventConsumer', 'SMTPEventConsumer')]
        [string]
        $ConsumerType,

        [Parameter(Mandatory, ParameterSetName = 'ComputerByNameSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByNameSet')]
        [string]
        $ConsumerName,

        [Parameter(Mandatory, ParameterSetName = 'ComputerByValueSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByValueSet')]
        [ciminstance]
        $Consumer,

        [Parameter(Mandatory, ParameterSetName = 'ComputerByValueSet')]
        [Parameter(Mandatory, ParameterSetName = 'SessionByValueSet')]
        [ciminstance]
        $Filter
    )

    begin
    {
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
        }
    }

    process
    {
        if(($PSBoundParameters.ContainsKey('ComputerName')) -or ($PSBoundParameters.ContainsKey('CimSession')))
        {                
            foreach($s in $CimSession)
            {
                if($PSCmdlet.ParameterSetName.Contains('ByName'))
                {
                    $Filter = Get-WmiEventFilterX -Name $FilterName -CimSession $s

                    switch($ConsumerType)
                    {
                        ActiveScriptEventConsumer
                        {
                            $Consumer = Get-ActiveScriptEventConsumerX -Name $ConsumerName -CimSession $s
                        }
                        CommandLineEventConsumer
                        {
                            $Consumer = Get-CommandLineEventConsumerX -Name $ConsumerName -CimSession $s
                        }
                        LogFileEventConsumer
                        {
                            $Consumer = Get-LogFileEventConsumerX -Name $ConsumerName -CimSession $s
                        }
                        NtEventLogEventConsumer
                        {
                            $Consumer = Get-NtEventLogEventConsumerX -Name $ConsumerName -CimSession $s
                        }
                        SmtpEventConsumer
                        {
                            $Consumer = Get-SmtpEventConsumerX -Name $ConsumerType -CimSession $s
                        }
                        default
                        {
                            Write-Error -Message 'Invalid Consumer Type'
                        }
                    }
                }

                $props = @{
                    Filter = $Filter
                    Consumer = $Consumer
                }
                
                Start-Job -ScriptBlock {New-CimInstance -Namespace root\subscription -ClassName __FilterToConsumerBinding -Property $props -CimSession $s}
            }
        }
        else
        {
            if($PSCmdlet.ParameterSetName.Contains('ByName'))
            {
                # run against localhost

                $Filter = Get-WmiEventFilterX -Name $FilterName

                switch($ConsumerType)
                {
                    ActiveScriptEventConsumer
                    {
                        $Consumer = Get-ActiveScriptEventConsumerX -Name $ConsumerName
                    }
                    CommandLineEventConsumer
                    {
                        $Consumer = Get-CommandLineEventConsumerX -Name $ConsumerName
                    }
                    LogFileEventConsumer
                    {
                        $Consumer = Get-LogFileEventConsumerX -Name $ConsumerName
                    }
                    NtEventLogEventConsumer
                    {
                        $Consumer = Get-NtEventLogEventConsumerX -Name $ConsumerName
                    }
                    SmtpEventConsumer
                    {
                        $Consumer = Get-SmtpEventConsumerX -Name $ConsumerName
                    }
                    default
                    {
                        Write-Error -Message 'Invalid Consumer Type'
                    }
                }
            }

            $props = @{
                Filter = $Filter
                Consumer = $Consumer
            }

            Start-Job -ScriptBlock {New-CimInstance -Namespace root\subscription -ClassName __FilterToConsumerBinding -Property $props}
        }
    }

    end
    {
        $Null = Get-Job | Receive-Job -Wait
        $Null = Get-Job | Remove-Job

        if($PSBoundParameters.ContainsKey('ComputerName'))
        {
            # Clean up the CimSessions we created to support the ComputerName parameter
            $CimSession | Remove-CimSession
        }
    }
}