unit searchp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
st=array[1..3,1..3] of char;
nodep = ^node;
node=record
  state : st;
  parentnode : nodep;
  operator : char;
  pathcost : integer;
  fn : integer;
  depth : integer;
  end;
queuep = ^queue;
queue=record
  item : node;
  link : queuep;
  end;
resultp = ^result;
result=record
  r : char;
  link : resultp;
  end;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  top : queuep;
  topr : resultp;
  front , rear : queuep;
  initst,goalst : st;
  search_cost,sci,scw,scm : integer;
  {--------------------}
  search_kind : char;
  path_cost : integer;
  r11,r12,r13 : resultp;
  rest1,rest2 : st;


implementation

{$R *.dfm}

function ids_search(start:st):resultp;forward;
function astar(start:st;kind:char):resultp;forward;
{result structure----------------------------}
procedure addr(it:char);
var
temp : resultp;
begin
new(temp);
temp^.r := it;
temp^.link := topr;
topr := temp;
end;
{/result structure------------------------}

procedure add(it:node);
var
temp : queuep;
begin
new(temp);
temp^.item := it;
temp^.link := top;
top := temp;
end;

function del():node ;
var
temp : queuep;
begin
if top=nil then
  ShowMessage('the stack is empty')
  else
  begin
  del := (top^.item);
  temp := top;
  top := top^.link;
  Dispose(temp);
  end;
end;

procedure addq(it:node);
var
temp,xp,xq :queuep;
begin
new(temp);
temp^.item := it;
xp := front;
xq := front;
while xq<>nil do
  if (xq^.item.fn)<(temp^.item.fn) then
    begin
    xp := xq;
    xq := xq^.link;
    end
    else
       break;
if front = nil then
  begin
  front := temp;
  rear := temp;
  temp^.link := nil;
  end
  else
    begin
    if (xp=front)and(xq=front) then
      begin
      temp^.link := front;
      front := temp;
      end
      else if (xp=rear)and(xq=nil) then
        begin
        temp^.link := nil;
        rear^.link := temp;
        rear := temp;
        end
        else
          begin
          xp^.link := temp;
          temp^.link := xq;
          end;
    end;
end;

function delq():node;
var
temp : queuep;
begin
if front=nil then
  ShowMessage('the queue is empty')
  else
  begin
  temp := front;
  delq := temp^.item;
  front := temp^.link;
  Dispose(temp);
  end;
end;

function max(a,b:integer):integer;
begin
if a >= b then
  max := a
  else
    max := b;
end;
{operators-------------------------------------}
procedure opu(s1:st;var s2:st;var mo:boolean);
var
i,j,m,n : shortint;
begin
for i:=1 to 3 do
  for j:=1 to 3 do
    begin
    s2[i,j] := s1[i,j];
    if (s1[i,j]=' ') then
      begin
      m:=i;
      n:=j;
      end;
    end;
if m=1 then
  mo := false
  else
  begin
  mo := true;
  s2[m,n] := s2[m-1,n];
  s2[m-1,n] := ' ';
  end;
end;

procedure opd(s1:st;var s2:st;var mo:boolean);
var
i,j,m,n : shortint;
begin
for i:=1 to 3 do
  for j:=1 to 3 do
    begin
    s2[i,j] := s1[i,j];
    if (s1[i,j]=' ') then
      begin
      m:=i;
      n:=j;
      end;
    end;
if m=3 then
  mo := false
  else
  begin
  mo := true;
  s2[m,n] := s2[m+1,n];
  s2[m+1,n] := ' ';
  end;
end;

procedure opl(s1:st;var s2:st;var mo:boolean);
var
i,j,m,n : shortint;
begin
for i:=1 to 3 do
  for j:=1 to 3 do
    begin
    s2[i,j] := s1[i,j];
    if (s1[i,j]=' ') then
      begin
      m:=i;
      n:=j;
      end;
    end;
if n=1 then
  mo := false
  else
  begin
  mo := true;
  s2[m,n] := s2[m,n-1];
  s2[m,n-1] := ' ';
  end;
end;

procedure opr(s1:st;var s2:st;var mo:boolean);
var
i,j,m,n : shortint;
begin
for i:=1 to 3 do
  for j:=1 to 3 do
    begin
    s2[i,j] := s1[i,j];
    if (s1[i,j]=' ') then
      begin
      m:=i;
      n:=j;
      end;
    end;
if n=3 then
  mo := false
  else
  begin
  mo := true;
  s2[m,n] := s2[m,n+1];
  s2[m,n+1] := ' ';
  end;
end;
{/operators------------------------------------}

procedure TForm1.Button1Click(Sender: TObject);
var tt : string;
begin
tt := edit1.Text;
if tt<>'' then
 initst[1,1] := tt[1]
 else
 initst[1,1] := ' ';
tt := edit2.Text;
if tt<>'' then
 initst[1,2] := tt[1]
 else
 initst[1,2] := ' ';
tt := edit3.Text;
if tt<>'' then
 initst[1,3] := tt[1]
 else
 initst[1,3] := ' ';
tt := edit4.Text;
if tt<>'' then
 initst[2,1] := tt[1]
 else
 initst[2,1] := ' ';
tt := edit5.Text;
if tt<>'' then
 initst[2,2] := tt[1]
 else
 initst[2,2] := ' ';
tt := edit6.Text;
if tt<>'' then
 initst[2,3] := tt[1]
 else
 initst[2,3] := ' ';
tt := edit7.Text;
if tt<>'' then
 initst[3,1] := tt[1]
 else
 initst[3,1] := ' ';
tt := edit8.Text;
if tt<>'' then
 initst[3,2] := tt[1]
 else
 initst[3,2] := ' ';
tt := edit9.Text;
if tt<>'' then
 initst[3,3] := tt[1]
 else
 initst[3,3] := ' ';
rest1 := initst;
search_kind := 'i';
r12 := ids_search(initst);
sci := search_cost;
search_cost := 1;
rest1 := initst;
search_kind := 'w';
r13 := astar(initst,search_kind);
scw := search_cost;
search_cost := 1;
rest1 := initst;
search_kind := 'm';
topr := nil;
r11 := astar(initst,search_kind);
scm := search_cost;
Button2.Visible := true;
if r11 = nil then
  begin
  Button2.Visible := false;
  Button3.Visible := true;
  end;
Button1.Visible := false;
Label2.Visible := true;
Label3.Visible := true;
Label4.Visible := true;
Label6.Visible := true;
Label7.Visible := true;
Label1.Visible := false;
Label3.Caption := Label3.Caption + inttostr(scm);
Label6.Caption := Label6.Caption + inttostr(scw);
Label7.Caption := Label7.Caption + inttostr(sci);
Label4.Caption := Label4.Caption + inttostr(path_cost);
end;

function goal_test(s:st):boolean;
var
i,j : shortint;
b : boolean;
begin
b := true;
for i:=1 to 3 do
  for j:=1 to 3 do
    if s[i,j]<>goalst[i,j] then
      b := false;
goal_test := b;
end;
{expand-------------------------------------}
function h1(st1:st):integer;forward;
function h2(st1:st):integer;forward;
procedure expand(var a:nodep;kind:char);
var
stat : st;
bool : boolean;
n : node;
hu : integer;
begin
opu(a^.state,stat,bool);
if bool then
  begin
  search_cost := search_cost + 1;
  n.state := stat;
  n.parentnode := a;
  n.operator := 'u';
  n.pathcost := a^.pathcost + 1 ;
  n.depth := a^.depth + 1;
  if kind = 'i' then
      add(n)
    else if kind = 'w' then
      begin
      hu := h1(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end
    else if kind = 'm' then
      begin
      hu := h2(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end;
  end;
opd(a.state,stat,bool);
if bool then
  begin
  search_cost := search_cost + 1;
  n.state := stat;
  n.parentnode := a;
  n.operator := 'd';
  n.pathcost := a^.pathcost + 1 ;
  n.depth := a^.depth + 1;
  if kind = 'i' then
      add(n)
    else if kind = 'w' then
      begin
      hu := h1(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end
    else if kind = 'm' then
      begin
      hu := h2(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end;
  end;
opl(a.state,stat,bool);
if bool then
  begin
  search_cost := search_cost + 1;
  n.state := stat;
  n.parentnode := a;
  n.operator := 'l';
  n.pathcost := a^.pathcost + 1 ;
  n.depth := a^.depth + 1;
  if kind = 'i' then
      add(n)
    else if kind = 'w' then
      begin
      hu := h1(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end
    else if kind = 'm' then
      begin
      hu := h2(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end;
  end;
opr(a.state,stat,bool);
if bool then
  begin
  search_cost := search_cost + 1;
  n.state := stat;
  n.parentnode := a;
  n.operator := 'r';
  n.pathcost := a^.pathcost + 1 ;
  n.depth := a^.depth + 1;
  if kind = 'i' then
      add(n)
    else if kind = 'w' then
      begin
      hu := h1(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end
    else if kind = 'm' then
      begin
      hu := h2(stat);
      n.fn := max(a^.fn,hu+n.pathcost);
      addq(n);
      end;
  end;
end;
{/expand------------------------------------}

{IDS & dls----------------------------------}
function dls(s:st;limit:integer):resultp;
var
initn : node;
temp,g : nodep;
gtest,cutoff : boolean;
stat : st;
bool : boolean;
n : node;
begin
{make initial node}
initn.state := s;
initn.parentnode := nil;
initn.operator := ' ';
initn.pathcost := 0;
initn.depth := 0;
add(initn);
while(top <> nil) do
begin
new(temp);
temp^ := del();
gtest := false;
if (goal_test(temp^.state)) then
    begin
    gtest := true;
    path_cost := temp.pathcost;
    break;
    end
    else if temp^.depth <> limit then
        begin
        expand(temp,search_kind);
        end;
end;
if gtest = true then
  begin
  g := temp;
  while(g^.operator <> ' ') do
    begin
    addr(g^.operator);
    g := g^.parentnode;
    end;
  dls :=topr;
  end
  else
    dls := nil;
end;

function ids_search(start:st):resultp;
var
depth : integer;
b : boolean;
re : resultp;
begin
b := true;
depth := 0;
while b do
begin
re:=dls(start,depth);
if re <> nil then
  b := false
  else
      depth := depth + 1;
end;
ids_search := re
end;
{/IDS & dls---------------------------------}

procedure TForm1.FormCreate(Sender: TObject);
begin
goalst[1,2]:= '1';
goalst[1,3]:= '2';
goalst[2,1]:= '3';
goalst[2,2]:= '4';
goalst[2,3]:= '5';
goalst[3,1]:= '6';
goalst[3,2]:= '7';
goalst[3,3]:= '8';
goalst[1,1]:= ' ';
search_cost := 1;
path_cost := 0;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
mm : boolean;
begin
if r11<>nil then
  begin
 if r11.r = 'u' then
  opu(rest1,rest2,mm)
  else if r11.r = 'd' then
  opd(rest1,rest2,mm)
    else if r11.r = 'l' then
    opl(rest1,rest2,mm)
      else if r11.r = 'r' then
      opr(rest1,rest2,mm);
Edit1.Text := '';
Edit1.Text := Edit1.Text+rest2[1,1];
Edit2.Text := '';
Edit2.Text := Edit2.Text+rest2[1,2];
Edit3.Text := '';
Edit3.Text := Edit3.Text+rest2[1,3];
Edit4.Text := '';
Edit4.Text := Edit4.Text+rest2[2,1];
Edit5.Text := '';
Edit5.Text := Edit5.Text+rest2[2,2];
Edit6.Text := '';
Edit6.Text := Edit6.Text+rest2[2,3];
Edit7.Text := '';
Edit7.Text := Edit7.Text+rest2[3,1];
Edit8.Text := '';
Edit8.Text := Edit8.Text+rest2[3,2];
Edit9.Text := '';
Edit9.Text := Edit9.Text+rest2[3,3];
rest1 := rest2;
r11 := r11.link;
end;
if (r11 = nil) then
  begin
  Button2.Visible := false;
  Button3.Visible := true;
  end;
end;

{heuristic1 : wrong position------------------}
function h1(st1:st):integer;
var
i,j,k : shortint;
begin
k := 0;
for i := 1 to 3 do
  for j :=1 to 3 do
    if st1[i,j]=goalst[i,j] then
      k := k + 1;
if st1[2,2] = ' ' then
    k := k - 1;
k := 8 - k;
h1 := k;
end;
{/heuristic1 : wrong position-----------------}

{heuristic2 : manhatan distance---------------}
function h2(st1:st):integer;
var
i,j,k : shortint;
begin
k := 0;
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '1' then
      k := k + (i - 1) + abs(j - 2);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '2' then
      k := k + (i - 1) + abs(j - 3);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '3' then
      k := k + abs(i - 2) + (j - 1);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '4' then
      k := k + abs(i - 2) + abs(j - 2);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '5' then
      k := k + abs(i - 2) + abs(j - 3);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '6' then
      k := k + abs(i - 3) + (j - 1);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '7' then
      k := k + abs(i - 3) + abs(j - 2);
for i := 1 to 3 do
  for j := 1 to 3 do
    if st1[i,j] = '8' then
      k := k + abs(i - 3) + abs(j - 3);
h2 := k;
end;
{/heuristic2 : manhatan distance--------------}

{a* search------------------------------------}
function astar(start:st;kind:char):resultp;
var
initn : node;
temp,g : nodep;
gtest : boolean;
begin
{make initial node}
initn.state := start;
initn.parentnode := nil;
initn.operator := ' ';
initn.pathcost := 0;
initn.depth := 0;
if kind = 'w' then
  initn.fn := h1(start)
  else if kind = 'm' then
    initn.fn := h2(start);
addq(initn);
gtest := false;
while(not gtest) do
begin
new(temp);
temp^ := delq();
if (goal_test(temp^.state)) then
    begin
    gtest := true;
    path_cost := temp.pathcost;
    break;
    end
    else
        begin
        expand(temp,search_kind);
        end;
end;
if gtest = true then
  begin
  g := temp;
  while(g^.operator <> ' ') do
    begin
    addr(g^.operator);
    g := g^.parentnode;
    end;
  astar :=topr;
  end
  else
  astar := nil;
end;
{/a* search-----------------------------------}

procedure TForm1.Button3Click(Sender: TObject);
begin
close;
end;

end.
