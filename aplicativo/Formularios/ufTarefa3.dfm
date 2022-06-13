object fTarefa3: TfTarefa3
  Left = 0
  Top = 0
  Caption = 'fTarefa3'
  ClientHeight = 361
  ClientWidth = 658
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 96
    Height = 13
    Caption = 'Valores por projeto:'
  end
  object Label2: TLabel
    Left = 528
    Top = 263
    Width = 44
    Height = 13
    Caption = 'Total R$:'
  end
  object Label3: TLabel
    Left = 528
    Top = 310
    Width = 85
    Height = 13
    Caption = 'Total divis'#245'es R$:'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 27
    Width = 641
    Height = 230
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'idProjeto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NomeProjeto'
        Width = 383
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Valor'
        Width = 147
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 409
    Top = 280
    Width = 113
    Height = 25
    Caption = 'Obter Total'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 327
    Width = 138
    Height = 25
    Caption = 'Obter Total Divis'#245'es'
    TabOrder = 2
    OnClick = Button2Click
  end
  object edtTotal: TEdit
    Left = 528
    Top = 282
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object edtTotalDivisoes: TEdit
    Left = 528
    Top = 329
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '0'
  end
end
