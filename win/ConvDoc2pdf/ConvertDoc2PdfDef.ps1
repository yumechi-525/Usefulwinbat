# powershell Set-ExecutionPolicy RemoteSigned
# powershellスクリプトを実行可能状態にする必要あり

function global:Convert-Doc2Pdf
{ 
[CmdletBinding()] 
Param ( 
    [parameter(Mandatory=$true, position=0, 
        ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true)] 
    [Alias('FullName')]     
    [string[]]$SourceFiles
    ) 
    begin 
    { 
        $WdExportFormat = "Microsoft.Office.Interop.Word.WdExportFormat" -as [type]     
         
        # Wordオブジェクトの作成 
        $objWord = New-Object -ComObject Word.Application 
        $objWord.Visible = $False 
         
        Write-Host "変換を開始します" 
    } 
    process 
    {            
        foreach ($file in $SourceFiles) 
        { 
            #ファイルを開く 
            $objDoc = $objWord.documents.open($file) 
            $objDoc.Saved = $True 
         
            Write-Host "変換中... $file" 
            # PDFとして保存する 
            $filename = [IO.Path]::ChangeExtension($file, ".pdf") 
            $objDoc.ExportAsFixedFormat($filename, $WdExportFormat::wdExportFormatPDF) 
        } 
    }     
    end 
    { 
        Write-Host "変換が完了しました！！" 
        $objDoc.Close() 
        $objWord.Quit() 
    } 
}