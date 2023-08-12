object MainForm: TMainForm
  Left = 346
  Top = 140
  BorderStyle = bsToolWindow
  ClientHeight = 132
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblProduct: TLabel
    Left = 6
    Top = 6
    Width = 79
    Height = 19
    AutoSize = False
    Caption = '&Product:'
    FocusControl = cboProduct
    Layout = tlCenter
  end
  object lblSerial: TLabel
    Left = 6
    Top = 66
    Width = 79
    Height = 21
    AutoSize = False
    Caption = '&Serial Number:'
    FocusControl = mSerialNumber
    Layout = tlCenter
  end
  object lblUserName: TLabel
    Left = 6
    Top = 36
    Width = 79
    Height = 21
    AutoSize = False
    Caption = 'User &Name:'
    FocusControl = edtUserName
    Layout = tlCenter
  end
  object btnCopy: TButton
    Left = 246
    Top = 102
    Width = 37
    Height = 21
    Caption = '&Copy'
    TabOrder = 4
    OnClick = btnCopyClick
  end
  object btnAbout: TButton
    Left = 288
    Top = 102
    Width = 19
    Height = 21
    Caption = '&?'
    TabOrder = 5
    OnClick = btnAboutClick
  end
  object cboProduct: TComboBox
    Left = 84
    Top = 6
    Width = 223
    Height = 21
    Style = csOwnerDrawFixed
    ItemHeight = 15
    TabOrder = 0
    OnChange = OnChange
    OnCloseUp = cboProductCloseUp
    OnDrawItem = cboProductDrawItem
  end
  object edtUserName: TEdit
    Left = 84
    Top = 36
    Width = 223
    Height = 21
    TabOrder = 1
    OnChange = OnChange
  end
  object mSerialNumber: TMemo
    Left = 84
    Top = 66
    Width = 223
    Height = 21
    Alignment = taCenter
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
  object btnGenerate: TButton
    Left = 180
    Top = 102
    Width = 61
    Height = 21
    Caption = '&Generate'
    TabOrder = 3
    OnClick = btnGenerateClick
  end
  object VistaAltFix: TVistaAltFix
    Left = 144
    Top = 36
  end
end
