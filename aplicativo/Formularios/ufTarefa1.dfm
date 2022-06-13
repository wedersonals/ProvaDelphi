object fTarefa1: TfTarefa1
  Left = 0
  Top = 0
  Caption = 'fTarefa1'
  ClientHeight = 363
  ClientWidth = 663
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 38
    Height = 13
    Caption = 'Colunas'
  end
  object Label2: TLabel
    Left = 199
    Top = 5
    Width = 37
    Height = 13
    Caption = 'Tabelas'
  end
  object Label3: TLabel
    Left = 390
    Top = 5
    Width = 49
    Height = 13
    Caption = 'Condi'#231#245'es'
  end
  object Label4: TLabel
    Left = 8
    Top = 187
    Width = 57
    Height = 13
    Caption = 'SQL Gerado'
  end
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 185
    Height = 150
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 199
    Top = 24
    Width = 185
    Height = 150
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 390
    Top = 24
    Width = 185
    Height = 150
    TabOrder = 2
  end
  object Memo4: TMemo
    Left = 7
    Top = 206
    Width = 648
    Height = 149
    TabOrder = 3
  end
  object Button1: TButton
    Left = 581
    Top = 22
    Width = 75
    Height = 25
    Caption = 'GeraSQL'
    TabOrder = 4
    OnClick = Button1Click
  end
  object spQuery: TspQuery
    Left = 600
    Top = 72
  end
end
