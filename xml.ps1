 Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "XML (*.xml)| *.xml"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

$XmLFileName = Get-FileName "C:\Users\ofe\Desktop"
[xml]$XmLFile = Get-Content $XmLFileName

$XmLBase = $XmLFile.databases.database.Get(0)

$MySQLDatabaseName = [string]$XmLBase.name
$MySQLTableName = [string]$XmLBase.tables.table.Get(0).name


