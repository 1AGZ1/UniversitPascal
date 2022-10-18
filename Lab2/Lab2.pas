uses Figures, graph, crt;

var
 P0:List;
 key:char;
// GraphDriver, GraphMode: integer;
 d, m: integer;

begin
// GraphDriver:=Detect;
// InitGraph(GraphDriver, GraphMode, 'c:\FPC\');
 InitGraph(d, m, 'c:\FPC\');

 P0.Init;
 P0.Add (new(PointPtr,     init(200, 200, 2)));
 P0.Add (new(PointPtr,     init(200, 201, 2)));
 P0.Add (new(PointPtr,     init(200, 199, 2)));
 P0.Add (new(PointPtr,     init(201, 200, 2)));
 P0.Add (new(PointPtr,     init(199, 200, 2)));

 P0.Add (new(CirclePtr,    init(200, 200, 120, 5)));
 P0.Add (new(LinePtr,      init(200, 500 , 300, 0, 3)));
 P0.Add (new(LinePtr,      init(800, 100, 0, 100, 3)));
 P0.Add (new(RectanglePtr, init(600, 600, 100, 100, 1)));
 P0.Add (new(TrianglePtr, init(400, 400, 50, 50, 50, -50, 4)));
 P0.Show;

 key := readkey;
 repeat
  key := readkey;
  if key <> '#13' then P0.drag(key);
 until key = '#13';

 P0.done;
 readln();
end.
