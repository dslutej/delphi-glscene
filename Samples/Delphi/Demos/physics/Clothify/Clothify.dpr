{: Clothify demo.<p>

   Caution: this demo mixes several experimental thingies, and will probably be
            cleaned-up/split to be easier to follow, ad interim, you enter
            the jungle below at your own risks :)
	<b>History : </b><font size=-1><ul>
      <li>1/23/03 - MF - Added shadow volumes. Yeah, more code in this allready
                         too complex demo.
      <li>?/?/03 - MF - Created
  </ul>
}
program Clothify;

uses
  Forms,
  fClothify in 'fClothify.pas' {frmClothify};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmClothify, frmClothify);
  Application.Run;
end.
