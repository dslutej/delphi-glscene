{: This demo shows how to use a GLFeedback object to
   extract mesh data from regular GLScene objects.<p>

   The GLFeedback object uses the GL_FEEDBACK render
   mode to gather vertex information passed through
   the OpenGL render pipeline. The resultant buffer
   can store information like point, line and polygon
   vertex position, texture coordinate and color.

   The BuildMeshFromBuffer function will parse the
   buffer for polygon data and apply it to the assigned
   lists. If the VertexIndices list is assigned it will
   perform a mesh recalculation to eliminate any
   duplicate vertex positions which will allow for
   smooth normal calculation. The texture coords
   returned will be per index value. They can either
   be used in a TFGIndexTexCoordList or resampled for
   use with other facegroup types.

}
program feedback;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
