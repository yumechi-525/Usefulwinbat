function global:Convert-Doc2PdfXps 
{ 
<# 
.SYNOPSIS 
WordファイルからPDFファイルまたはXPSファイルを作成します。 
 
.DESCRIPTION 
この関数は、WordファイルからPDFファイルまたはXPSファイルを作成します。 
 
.PARAMETER SourceFiles 
変換するWordファイルをフルパスで指定します。 
 
.PARAMETER XPS 
このスイッチパラメータを使用するとWordファイルからXPSファイルを作成します。 
省略した場合にはPDFファイルが作成されます。 
 
.EXAMPLE 
C:\PS> Convert-Doc2PdfXps C:\Work\議事録.docx 
 
説明 
----------- 
C:\Work\議事録.docx というファイルから C:\Work\議事録.pdf というPDFファイルを作成します。 
 
.EXAMPLE 
C:\PS> Convert-Doc2PdfXps C:\Work\議事録.docx -XPS 
 
説明 
----------- 
C:\Work\議事録.docx というファイルから C:\Work\議事録.xps というXPSファイルを作成します。 
 
.EXAMPLE 
C:\PS> dir *.docx | Convert-Doc2PdfXps 
 
説明 
----------- 
カレントディレクトリにあるすべての *.docx ファイルからPDFファイルを作成します。 
 
.EXAMPLE 
C:\PS> dir *.docx | Convert-Doc2PdfXps -XPS 
 
説明 
----------- 
カレントディレクトリにあるすべての *.docx ファイルからXPSファイルを作成します。 
 
注意
事前に実行ポリシーを与えておいてください．管理者権限が必要です．
Set-ExecutionPolicy RemoteSigned

#> 
[CmdletBinding()] 
Param ( 
    [parameter(Mandatory=$true, position=0, 
        ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true)] 
    [Alias('FullName')]     
    [string[]]$SourceFiles 
    , 
    [switch]$XPS         
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
            if ( $XPS ) 
            { 
                # XPSとして保存する 
                $filename = [IO.Path]::ChangeExtension($file, ".xps") 
                $objDoc.ExportAsFixedFormat($filename, $WdExportFormat::wdExportFormatXPS) 
            } 
            else 
            { 
                # PDFとして保存する 
                $filename = [IO.Path]::ChangeExtension($file, ".pdf") 
                $objDoc.ExportAsFixedFormat($filename, $WdExportFormat::wdExportFormatPDF) 
            } 
        } 
    }     
    end 
    { 
        Write-Host "変換が完了しました！！" 
        $objDoc.Close() 
        $objWord.Quit() 
    } 
}

dir | ? Name -Match '\.docx?'  | Convert-Doc2PdfXps