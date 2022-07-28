object frmPrincipal: TfrmPrincipal
  Left = 256
  Top = 188
  Width = 1305
  Height = 675
  Caption = 'Assistente Git'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    1289
    636)
  PixelsPerInch = 96
  TextHeight = 17
  object Label1: TLabel
    Left = 376
    Top = 8
    Width = 31
    Height = 17
    Caption = 'Repo'
  end
  object lbMerge: TLabel
    Left = 1024
    Top = 8
    Width = 70
    Height = 17
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Branch Base'
  end
  object Label2: TLabel
    Left = 192
    Top = 8
    Width = 106
    Height = 17
    Caption = 'Criar Nova Branch'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 17
    Caption = 'Buscar'
  end
  object btnListar: TButton
    Left = 848
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Atualizar'
    TabOrder = 0
    OnClick = btnListarClick
  end
  object Edit1: TEdit
    Left = 376
    Top = 32
    Width = 465
    Height = 25
    TabOrder = 1
    Text = 'C:\Users\Everton\source\repos\Horus3'
  end
  object ListaBranchs: TListBox
    Left = 8
    Top = 64
    Width = 1273
    Height = 561
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 21
    ParentFont = False
    TabOrder = 2
    OnClick = ListaBranchsClick
    OnDblClick = ListaBranchsDblClick
    OnKeyDown = ListaBranchsKeyDown
  end
  object btnMudarPara: TButton
    Left = 928
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Mudar Para'
    TabOrder = 3
    Visible = False
    OnClick = btnMudarParaClick
  end
  object btnMesclar: TButton
    Left = 1192
    Top = 32
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Mesclar'
    TabOrder = 4
    OnClick = btnMesclarClick
  end
  object edBranchBase: TEdit
    Left = 1024
    Top = 32
    Width = 161
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 5
    Text = 'develop'
  end
  object edNovaBranch: TEdit
    Left = 192
    Top = 32
    Width = 177
    Height = 25
    TabOrder = 6
    OnChange = edNovaBranchChange
    OnKeyDown = edNovaBranchKeyDown
  end
  object edPesquisar: TEdit
    Left = 8
    Top = 32
    Width = 177
    Height = 25
    TabOrder = 7
    OnChange = edPesquisarChange
  end
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 600
    Top = 64
  end
end
