<h1 align="center">WmiEvent</h1>
<h5 align="center">Developed by <a href="https://twitter.com/jaredcatkinson">@jaredcatkinson</a>, <a href="https://twitter.com/mattifestation">@mattifestation</a></h5>

<p align="center">
  <a href="http://waffle.io/Invoke-IR/WniEvent">
    <img src="https://badge.waffle.io/Invoke-IR/WMIEvent.svg?l?label=ready&title=Ready">
  </a>
  <a href="http://waffle.io/Invoke-IR/WMIEvent">
    <img src="https://badge.waffle.io/Invoke-IR/WMIEvent.svg?l?label=in%20progress&title=In%20Progress">
  </a>
</p>

## Overview
An Event Filter ([__EventFilter](https://msdn.microsoft.com/en-us/library/aa394639(v=vs.85).aspx)) is a WMI Query Language (WQL) query that specifies the type of object to look for (for more details on WQL please check out [Ravikanth Chaganti's free ebook](http://www.ravichaganti.com/blog/ebook-wmi-query-language-via-powershell/)). Event Consumers ([__EventConsumer](https://msdn.microsoft.com/en-us/library/aa394635(v=vs.85).aspx)) are the action component of the Event Subscription. Event Consumers tell the subscription what to do with an object that makes it past the filter. There are five default event consumers in Windows: [ActionScriptEventConsumer](https://msdn.microsoft.com/en-us/library/aa384749(v=vs.85).aspx) (runs arbitrary vbscript or jscript code), [CommandLineEventConsumer](https://msdn.microsoft.com/en-us/library/aa389231(v=vs.85).aspx) (executes an arbitrary command), [LogFileEventConsumer](https://msdn.microsoft.com/en-us/library/aa392277(v=vs.85).aspx) (writes to a specified flat log file), [NtEventLogEventConsumer](https://msdn.microsoft.com/en-us/library/aa392715(v=vs.85).aspx) (creates a new event log), and [SMTPEventConsumer](https://msdn.microsoft.com/en-us/library/aa393629(v=vs.85).aspx) (sends an email). Lastly, the Binding ([__FilterToConsumerBinding](https://msdn.microsoft.com/en-us/library/aa394647(v=vs.85).aspx)) pairs a Filter with a Consumer.

## Cmdlets
```
Get-ActiveScriptEventConsumer - 
Get-CommandLineEventConsumer - 
Get-LogFileEventConsumer - 
Get-NtEventLogEventConsumer - 
Get-SmtpEventLogEventConsumer - 
Get-WmiEventConsumer - 
Get-WmiEventFilter - 
Get-WmiEventSubscription - 
New-ActiveScriptEventConsumer - 
New-CommandLineEventConsumer - 
New-LogFileEventConsumer - 
New-NtEventLogEventConsumer - 
New-SmtpEventConsumer - 
New-WmiEventConsumer - 
New-WmiEventFilter - 
New-WmiEventSubscription - 
New-CimSessionDcom - 
Register-PermanentWmiEvent - 
```