object fTarefa2: TfTarefa2
  Left = 0
  Top = 0
  Caption = 'fTarefa2'
  ClientHeight = 124
  ClientWidth = 582
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
    Top = 19
    Width = 127
    Height = 13
    Caption = 'Thread 01 - Intervalo (ms)'
  end
  object Label2: TLabel
    Left = 8
    Top = 47
    Width = 127
    Height = 13
    Caption = 'Thread 02 - Intervalo (ms)'
  end
  object Label3: TLabel
    Left = 8
    Top = 70
    Width = 49
    Height = 13
    Caption = 'Thread 01'
  end
  object Label4: TLabel
    Left = 8
    Top = 93
    Width = 49
    Height = 13
    Caption = 'Thread 02'
  end
  object seThread1: TSpinEdit
    Left = 141
    Top = 10
    Width = 127
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 20
  end
  object seThread2: TSpinEdit
    Left = 141
    Top = 38
    Width = 127
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 30
  end
  object bIniciar: TButton
    Left = 288
    Top = 8
    Width = 127
    Height = 25
    Caption = 'Iniciar Threads'
    TabOrder = 2
    OnClick = bIniciarClick
  end
  object pbThread1: TProgressBar
    Left = 141
    Top = 66
    Width = 431
    Height = 17
    TabOrder = 3
  end
  object pbThread2: TProgressBar
    Left = 141
    Top = 89
    Width = 431
    Height = 17
    TabOrder = 4
  end
end
