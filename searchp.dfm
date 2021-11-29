object Form1: TForm1
  Left = 195
  Top = 125
  Width = 696
  Height = 495
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 136
    Top = 168
    Width = 82
    Height = 13
    Caption = 'fill the initial state '
  end
  object Label2: TLabel
    Left = 184
    Top = 320
    Width = 39
    Height = 13
    Caption = 'report :  '
    Visible = False
  end
  object Label3: TLabel
    Left = 184
    Top = 384
    Width = 249
    Height = 13
    Caption = 'search cost of a* with manhatan distance heuristic:   '
    Visible = False
  end
  object Label4: TLabel
    Left = 184
    Top = 408
    Width = 59
    Height = 13
    Caption = 'path cost :   '
    Visible = False
  end
  object Label6: TLabel
    Left = 184
    Top = 368
    Width = 221
    Height = 13
    Caption = 'search cost of a* with wrong position heuristic :'
    Visible = False
  end
  object Label7: TLabel
    Left = 184
    Top = 352
    Width = 124
    Height = 13
    Caption = 'search cost of ids search :'
    Visible = False
  end
  object Edit1: TEdit
    Left = 296
    Top = 136
    Width = 25
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 328
    Top = 136
    Width = 25
    Height = 21
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 360
    Top = 136
    Width = 25
    Height = 21
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 296
    Top = 160
    Width = 25
    Height = 21
    TabOrder = 3
  end
  object Edit5: TEdit
    Left = 328
    Top = 160
    Width = 25
    Height = 21
    TabOrder = 4
  end
  object Edit6: TEdit
    Left = 360
    Top = 160
    Width = 25
    Height = 21
    TabOrder = 5
  end
  object Edit7: TEdit
    Left = 296
    Top = 184
    Width = 25
    Height = 21
    TabOrder = 6
  end
  object Edit8: TEdit
    Left = 328
    Top = 184
    Width = 25
    Height = 21
    TabOrder = 7
  end
  object Edit9: TEdit
    Left = 360
    Top = 184
    Width = 25
    Height = 21
    TabOrder = 8
  end
  object Button1: TButton
    Left = 168
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Submit'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 224
    Width = 121
    Height = 25
    Caption = 'next state'
    TabOrder = 10
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 568
    Top = 360
    Width = 75
    Height = 25
    Caption = 'exit'
    TabOrder = 11
    Visible = False
    OnClick = Button3Click
  end
end
