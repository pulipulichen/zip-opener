#AutoIt3Wrapper_icon="icon.ico"
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>

$clipboard = ""
Local $aArray[0] = []

$tmpDir = @TempDir & "/zip-opener"
;$tmpDir = @ScriptDir & "/temp"

For $i = 1 To $CmdLine[0]

   Local $filePath = $CmdLine[$i]
   ;MsgBox($MB_SYSTEMMODAL, "", $filePath)
   If FileExists ($filePath) == 1 Then
	  Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  $pathSplit = _PathSplit($filePath, $sDrive, $sDir, $sFileName, $sExtension)

	  $fileName = $pathSplit[3]

	  ;MsgBox($MB_SYSTEMMODAL, $fileName, $filePath)

	  $zipPath = $tmpDir & '/' & $fileName

	  If DirGetSize ($zipPath) <> -1 Then
		 DirRemove($zipPath, 1)
	  EndIf

	  If DirGetSize ($zipPath) == -1 Then
		 $unzipCmd = @ScriptDir & '/7zip/7z.exe x "' & $filePath & '" -o"' & $zipPath & '"'
		 ;MsgBox($MB_SYSTEMMODAL, $fileName, $unzipCmd)

		 RunWait($unzipCmd)

		 ; 查看這裡面有什麼檔案，然後全部開啟它
		 Local $aFileList = _FileListToArray($zipPath, "*")
		 For $f = 1 To $aFileList[0]
			$unzipFilePath = '"' & $zipPath & "/" & $aFileList[$f] & '"'
			;MsgBox($MB_SYSTEMMODAL, $fileName, $file)
			ShellExecute($unzipFilePath)
		 Next
	  Else
		 MsgBox($MB_SYSTEMMODAL, "Error", "Cannot remove directory: " & $zipPath)
	  EndIf


   EndIf
Next