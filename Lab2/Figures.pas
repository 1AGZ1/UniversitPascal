unit Figures;

interface
uses graph, crt;

type

 Location = object
  x,y: integer;
  procedure Init(xValue, yValue: integer);
 end;

 PointPtr = ^Point;
 Point = object (Location)
 
  color: integer;
  Visible: boolean;
  constructor Init(xValue, yValue, colorValue:integer);
  destructor Done; 
    virtual;
  procedure Show; 
    virtual;
  procedure Hide; 
    virtual;
  procedure Drag(movX, movY: integer); 
    virtual;

 end;

 NodePtr = ^Node;
 Node = record
  Item: PointPtr;
  next: NodePtr;
 end;

 List=object (Point)
  Nodes:NodePtr;
  constructor Init;
  destructor Done; virtual;
  procedure Add(Item: PointPtr);
  procedure Show;
  procedure Hide;
  procedure Drag (key:char);
 end;

 CirclePtr = ^Circle;
 Circle = object (Point)
  Radius:integer;
  constructor Init(xValue, yValue, radiusValue, colorValue:integer);
  procedure Show; virtual;
  procedure Hide; virtual;
 end;

 LinePtr = ^Line;
 Line = object (Point)
  x2, y2: integer;
  constructor Init(x1Value, y1Value, x2Value, y2Value, colorValue: integer);
  procedure Show; virtual;
  procedure Hide; virtual;
 end;

 RectanglePtr = ^Rectangle;
 Rectangle = object (Line)
  procedure Show; virtual;
  procedure Hide; virtual;
 end;

 TrianglePtr = ^Triangle;
 Triangle = object (Line)
  x3,y3:integer;
  constructor Init(xV1, yV1, xV2, yV2, xV3, yV3, colorValue: integer);
  procedure Show; virtual;
  procedure Hide; virtual;
 end;

implementation

//Location----------------------------------------

procedure Location.Init(xValue, yValue: integer);
begin
  x:=xValue;
  y:=yValue;
end;

//Point--------------------------------------

constructor Point.Init(xValue, yValue, colorValue: integer);
begin
 Location.Init(xValue, yValue);
 color:=colorValue;
 Visible:=false;
end;

destructor Point.Done;
begin
 Hide;
end;

procedure Point.Show;
begin
 Visible:=True;
 PutPixel(x,y,color)
end;

procedure Point.Hide;
begin
 Visible:=False;
 PutPixel(x,y,0);
end;

procedure Point.Drag (movX, movY:integer);
begin
 Hide;
 inc(x, movX);
 inc(y, movY);
 Show;
end;

//Circle----------------------------------------------------

constructor Circle.Init (xValue, yValue, radiusValue, colorValue: integer);
begin
 Location.Init(xValue,yValue);
 Radius:=radiusValue;
 color:=colorValue;
end;

procedure Circle.Show;
begin
 visible:= true;
 SetColor(color);
 graph.Circle(x,y,Radius);
end;

procedure Circle.Hide;
begin
 Visible := false;
 SetColor(0);
 graph.circle(x,y,Radius);
 SetColor(color);
end;

//Line-------------------------------------------------------

constructor Line.Init(x1Value, y1Value, x2Value, y2Value, colorValue: integer);
begin
 Point.Init(x1Value, y1Value, colorValue);
 x2 := x2Value;
 y2 := y2Value;
end;

procedure Line.Show;
begin
 Visible := true;
 SetColor(color);
 graph.Line(x, y, x+x2, y+y2);
end;

procedure Line.Hide;
begin
 Visible := false;
 SetColor(0);
 graph.Line(x, y, x+x2, y+y2);
 SetColor(color);
end;

//Rectangle------------------------------------------------

procedure Rectangle.Show;
begin
 Visible := true;
 SetColor(color);
 graph.rectangle(x, y, x+x2, y+y2);
end;

procedure Rectangle.Hide;
begin
 Visible := false;
 SetColor(0);
 graph.rectangle(x,y,x+x2,y+y2);
 SetColor(color);
end;

//Triangle------------------------------------------------
constructor Triangle.Init(xV1, yV1, xV2, yV2, xV3, yV3, colorValue: integer);
begin
 Point.Init(xV1, yV1, colorValue);
 x2 := x + xV2;
 y2 := y + yV2;
 x3 := x + xV3;
 y3 := y + yV3;
end;

procedure TriangleDraw(x1, y1, x2, y2, x3,y3:integer);begin
  graph.Line(x1, y1, x2, y2);
  graph.Line(x2, y2, x3, y3);
  graph.Line(x3, y3, x1, y1);
end;


procedure Triangle.Show;
begin
 Visible := true;
 SetColor(color);
 TriangleDraw(x, y, x+x2, y+y2, x+x3, y+y3);
end;

procedure Triangle.Hide;
begin
 Visible := false;
 SetColor(0);
 TriangleDraw(x, y, x+x2, y+y2, x+x3, y+y3);
end;


//List---------------------------------------------------------

constructor List.Init;
begin
 Nodes:=nil;
end;

destructor List.Done;
var
 q:NodePtr;
begin
 while Nodes <> NIL do
 begin
  q:=Nodes;
  Nodes:=q^.next;
  dispose(q^.Item, Done);
  dispose(q);
 end;
end;

procedure List.Add(Item: PointPtr);
var
 q:NodePtr;
begin
 new(q);
 q^.Item := Item;
 q^.next :=  Nodes;
 Nodes:= q;
end;

procedure List.Show;
var
 q: NodePtr;
begin
 Visible := true;
 q := Nodes;
 while q <> NIL do
 begin
  q^.Item^.Show;
  q := q^.next;
 end;
end;

procedure List.Hide;
var
 q: NodePtr;
begin
 Visible := false;
 q := Nodes;
 while q <> NIL do
 begin
  q^.Item^.Hide;
  q:= q^.next;
 end;
end;

procedure GetDelta (var movX: integer; var movY: integer; key:char);
begin
 case ord(key) of
 80: movY:=50;
 72: movY:=-50;
 77: movX:=50;
 75: movX:=-50;
 end;
end;

procedure List.Drag(key: char);
var
 q: NodePtr;
 movX, movY: integer;
begin
 q := Nodes;
 movX := 0;
 movY := 0;
 GetDelta(movX, movY, key);
 while q<>NIL do
 begin
  q^.Item^.Drag(movX, movY);
  q := q^.next;
 end;
end;

begin
end.
