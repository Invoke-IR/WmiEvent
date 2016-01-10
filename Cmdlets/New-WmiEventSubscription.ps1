function New-WmiEventSubscription
{
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = 'ComputerNameSet')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        [Parameter(ParameterSetName = 'ComputerNameSet')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory, ParameterSetName = 'CimSessionSet')]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory)]
        [string]
        $FilterName,
        
        [Parameter(Mandatory)]
        [ValidateSet('ActiveScriptEventConsumer', 'CommandLineEventConsumer', 'LogFileEventConsumer', 'NtEventLogEventConsumer', 'SMTPEventConsumer')]
        [string]
        $ConsumerType,

        [Parameter(Mandatory)]
        [string]
        $ConsumerName
    )

    begin
    {
        $class = Get-CimClass -Namespace root\subscription -ClassName __FilterToConsumerBinding

        if($PSCmdlet.ParameterSetName.Contains('ComputerSet'))
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
    }

    process
    {
        if(($PSBoundParameters.ContainsKey('ComputerName')) -or ($PSBoundParameters.ContainsKey('CimSession')))
        {                
            foreach($s in $CimSession)
            {
                $Filter = Get-wmieventFilter -Name $FilterName -CimSession $s

                switch($ConsumerType)
                {
                    ActiveScriptEventConsumer
                    {
                        $Consumer = Get-ActiveScriptEventConsumer -Name $ConsumerName -CimSession $s
                    }
                    CommandLineEventConsumer
                    {
                        $Consumer = Get-CommandLineEventConsumer -Name $ConsumerName -CimSession $s
                    }
                    LogFileEventConsumer
                    {
                        $Consumer = Get-LogFileEventConsumer -Name $ConsumerName -CimSession $s
                    }
                    NtEventLogEventConsumer
                    {
                        $Consumer = Get-NtEventLogEventConsumer -Name $ConsumerName -CimSession $s
                    }
                    SmtpEventConsumer
                    {
                        $Consumer = Get-SmtpEventConsumer -Name $ConsumerType -CimSession $s
                    }
                    default
                    {
                        Write-Error -Message 'Invalid Consumer Type'
                    }
                }

                $props = @{
                    Filter = $Filter
                    Consumer = $Consumer
                }

                New-CimInstance -CimClass $class -Property $props -CimSession $s
            }
        }
        else
        {
            $Filter = Get-WmiEventFilter -Name $FilterName

            switch($ConsumerType)
            {
                ActiveScriptEventConsumer
                {
                    $Consumer = Get-ActiveScriptEventConsumer -Name $ConsumerName
                }
                CommandLineEventConsumer
                {
                    $Consumer = Get-CommandLineEventConsumer -Name $ConsumerName
                }
                LogFileEventConsumer
                {
                    $Consumer = Get-LogFileEventConsumer -Name $ConsumerName
                }
                NtEventLogEventConsumer
                {
                    $Consumer = Get-NtEventLogEventConsumer -Name $ConsumerName
                }
                SmtpEventConsumer
                {
                    $Consumer = Get-SmtpEventConsumer -Name $ConsumerName
                }
                default
                {
                    Write-Error -Message 'Invalid Consumer Type'
                }
            }

            $props = @{
                Filter = $Filter
                Consumer = $Consumer
            }

            New-CimInstance -CimClass $class -Property $props
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