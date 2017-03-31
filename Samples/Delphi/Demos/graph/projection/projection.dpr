{: Parallel projection demo.<p>

   This simple demo shows how to do parallel projection and blend some custom
   OpenGL calls into the scene.<br>
   You can change the viewpoint with left clic drags, change the plane orientation
   with right clic drags, and move the plane up/down with the wheel.<p>

   The points and plane are rendered directly with regular scene objects,
   but the projection lines between the points and the plane are computed
   and rendered on the fly in a TGLDirectOpenGL. This is a typical case where
   a little bit of custom code helps a lot: we could have used many TGLLines
   object to draw the lines, but this would have resulted in a lot of object
   creation and update code, and ultimately in rather poor performance.<br>
   Note the position of the plane in the scene hierarchy: it is last as it is
   a blended object. Try making it the first object, it will appear opaque
   (though it is still transparent!).
}
program projection;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
