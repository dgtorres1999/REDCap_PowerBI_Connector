# Power BI to REDCap Connector
<br>This is a custom data connector which you can use in Power BI to connect to your REDCap installation. The connector is able to get data from all types of REDCap projects including longitudinal and projects with repeat instruments.<br/>
<br>To use the connector download the .mez file located inside Bin/AnyCpu/Debug folder and store it in your local [Documents]\Microsoft Power BI Desktop\Custom Connectors folder.  If the folder doesn't exist, create it.
For more information on how to use a connector go to <a href="https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-connector-extensibility">Connector extensibility in Power BI.</a><br/>
You must pass the following parameters when connecting Power BI to REDCap
<ul>
  <li>REDCap URL</li>
  <li>Project API Token</li>
  <li>Select between records or reports</li>
   <li>Report ID (Only for reports)</li>
  <li>Raw or Label data format</li>
  <li>Raw or Label headers</li>
  <li>Export Checkbox Labels</li>
  <li>Export Survey Fields (Select 'False' for reports)</li>
  <li>Export Data Access Groups (Select 'False' for reports)</li>
  </ul>
 Optional parameters for records you may pass are
 <ul>
  <li>Fields</li>
  <li>Forms</li>
  <li>Events</li>
  </ul>

