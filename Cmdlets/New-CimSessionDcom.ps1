function New-CimSessionDcom
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',
        
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    begin
    {
        $parameters = @{
            SessionOption = (New-CimSessionOption -Protocol Dcom);
            SkipTestConnection = $True;
            Credential = $Credential;
            ComputerName = $ComputerName;
        }   
    }

    process
    {
        New-CimSession @parameters
    }

    end
    {

    }
}