Clear-Host
Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "JSON (*.json)| *.json"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
    $OpenFileDialog.Dispose()
}

 function Find-Folders {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = $env:USERPROFILE+"\Desktop\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Dosyaları kaydedecek dizini Seçin"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false

		Set-Location -Path $browse.SelectedPath
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("İşlemi İptal Ettiniz. Tekrar denemek mi yoksa çıkmak mı istersiniz?", "Dosya yolu belirle", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}


#Dosya seçme işlemleri
$inputfile = Get-FileName $env:USERPROFILE+"\Downloads"
$inputdata = get-content $inputfile
if(!$inputfile){
Write-Host -ForegroundColor White -BackgroundColor Red "Hata: Seçilen dosya boş olmamalıdır.`n"
return
}

#Dosyanın bulunduğu değişken JSON halinde
$flickrImages = $inputdata | ConvertFrom-Json

#Girilen dizin halihazırda yoksa      
#If(!(test-path $targetDir))
#{
#      New-Item -ItemType Directory -Force -Path $targetDir
#}
$targetDir = Find-Folders
$targetDir = $targetDir + "\"
Write-Host -ForegroundColor Green "Şuan bulunan dizin " $targetDir

#Dosya indirme Fonksiyonu
Function DownloadFile([Object[]] $sourceFiles,[string] $targetDirectory) {            
 $wc = New-Object System.Net.WebClient            
             
 foreach ($sourceFile in $sourceFiles){            
  $sourceFileName = $sourceFile.SubString($sourceFile.LastIndexOf('/')+1)            
  $targetFileName = $targetDirectory + $sourceFileName            
  $wc.DownloadFile($sourceFile, $targetFileName)            
  Write-Host -ForegroundColor Cyan "Downloaded $sourceFile to file location $targetFileName"             
 }            
            
} DownloadFile $flickrImages $targetDir