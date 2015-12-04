Attribute VB_Name = "Sheet_Helpers"
Option Explicit

'---------------------------------------------------------------------------------------
' Module    : Sheet_Helpers
' Author    : @byronwall
' Date      : 2015 07 24
' Purpose   : Contains code related to sheets and sheet processing
'---------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------
' Procedure : LockAllSheets
' Author    : @byronwall
' Date      : 2015 07 24
' Purpose   : Locks all sheets with the same password
'---------------------------------------------------------------------------------------
'
Sub LockAllSheets()

    Dim pass As Variant
    pass = Application.InputBox("Password to lock")

    If pass = False Then
        MsgBox "Cancelled."
    Else
        Application.ScreenUpdating = False

        'Changed to activeworkbook so if add-in is not installed, it will target the active book rather than the xlam
        Dim sheet As Worksheet
        For Each sheet In ActiveWorkbook.Sheets
            On Error Resume Next
            sheet.Protect (pass)
        Next

        Application.ScreenUpdating = True
    End If

End Sub

'---------------------------------------------------------------------------------------
' Procedure : OutputSheets
' Author    : @byronwall
' Date      : 2015 07 24
' Purpose   : Creates a new worksheet with a list and link to each sheet
'---------------------------------------------------------------------------------------
'
Sub OutputSheets()

    Dim wsOut As Worksheet
    Set wsOut = Worksheets.Add(Before:=Worksheets(1))
    wsOut.Activate

    Dim rngOut As Range
    Set rngOut = wsOut.Range("B2")

    Dim iRow As Integer
    iRow = 0

    Dim sht As Worksheet
    For Each sht In Worksheets

        If sht.name <> wsOut.name Then

            sht.Hyperlinks.Add _
                    rngOut.Offset(iRow), "", _
                    "'" & sht.name & "'!A1", , _
                        sht.name
            iRow = iRow + 1

        End If
    Next sht

End Sub

'---------------------------------------------------------------------------------------
' Procedure : UnlockAllSheets
' Author    : @byronwall
' Date      : 2015 07 24
' Purpose   : Unlocks all sheets with the same password
'---------------------------------------------------------------------------------------
'
Sub UnlockAllSheets()

    Dim pass As Variant
    pass = Application.InputBox("Password to unlock")
    
    Dim iErr As Integer
    iErr = 0
    
    If pass = False Then
        MsgBox "Cancelled."
    Else
        Application.ScreenUpdating = False
        'Changed to activeworkbook so if add-in is not installed, it will target the active book rather than the xlam
        Dim sht As Worksheet
        For Each sht In ActiveWorkbook.Sheets
            'Let's keep track of the errors to inform the user
            If Err.Number <> 0 Then iErr = iErr + 1
            Err.Clear
            On Error Resume Next
            sht.Unprotect (pass)

        Next sht
        If Err.Number <> 0 Then iErr = iErr + 1
        Application.ScreenUpdating = True
    End If
    If iErr <> 0 Then
    MsgBox (iErr & " sheets could not be unlocked due to bad password.")
    End If
End Sub

'---------------------------------------------------------------------------------------
' Procedure : AscendSheets
' Author    : @raymondwise
' Date      : 2015 08 07
' Purpose   : Places worksheets in ascending alphabetical order.
'---------------------------------------------------------------------------------------
Sub AscendSheets()
Application.ScreenUpdating = False
Dim wb As Workbook
Set wb = ActiveWorkbook

Dim intSheets As Integer
intSheets = wb.Sheets.count

Dim i As Integer
Dim j As Integer

With wb
    For j = 1 To intSheets
        For i = 1 To intSheets - 1
            If UCase(.Sheets(i).name) > UCase(.Sheets(i + 1).name) Then
                .Sheets(i).Move after:=.Sheets(i + 1)
            End If
        Next i
    Next j
End With

Application.ScreenUpdating = True
End Sub
'---------------------------------------------------------------------------------------
' Procedure : DescendSheets
' Author    : @raymondwise
' Date      : 2015 08 07
' Purpose   : Places worksheets in descending alphabetical order.
'---------------------------------------------------------------------------------------
Sub DescendSheets()
Application.ScreenUpdating = False
Dim wb As Workbook
Set wb = ActiveWorkbook

Dim intSheets As Integer
intSheets = wb.Sheets.count

Dim i As Integer
Dim j As Integer

With wb
    For j = 1 To intSheets
        For i = 1 To intSheets - 1
            If UCase(.Sheets(i).name) < UCase(.Sheets(i + 1).name) Then
                .Sheets(i).Move after:=.Sheets(i + 1)
            End If
        Next i
    Next j
End With

Application.ScreenUpdating = True
End Sub
