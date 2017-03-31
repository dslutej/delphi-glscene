//
// This unit is part of the GLScene Project, http://glscene.org
//
{
  Base classes for GLScene.
  History:
     05/10/08 - DanB - Creation, from GLMisc.pas + other places
     The whole history is logged in previous version of the unit
}

unit GLBaseClasses;

interface

uses
  System.Classes,
  System.SysUtils,

  GLStrings,
  GLPersistentClasses,
  GLCrossPlatform;

type

  TProgressTimes = record
    deltaTime, newTime: Double
  end;

  {Progression event for time-base animations/simulations.
     deltaTime is the time delta since last progress and newTime is the new
     time after the progress event is completed. }
  TGLProgressEvent = procedure(Sender: TObject; const deltaTime, newTime: Double) of object;

  IGLNotifyAble = interface(IInterface)
    ['{00079A6C-D46E-4126-86EE-F9E2951B4593}']
    procedure NotifyChange(Sender: TObject);
  end;

  IGLProgessAble = interface(IInterface)
    ['{95E44548-B0FE-4607-98D0-CA51169AF8B5}']
    procedure DoProgress(const progressTime: TProgressTimes);
  end;

  {An abstract class describing the "update" interface.  }
  TGLUpdateAbleObject = class(TGLInterfacedPersistent, IGLNotifyAble)
  private
    FOwner: TPersistent;
    FUpdating: Integer;
    FOnNotifyChange: TNotifyEvent;
  public
    constructor Create(AOwner: TPersistent); virtual;
    procedure NotifyChange(Sender: TObject); virtual;
    procedure Notification(Sender: TObject; Operation: TOperation); virtual;
    function GetOwner: TPersistent; override;
    property Updating: Integer read FUpdating;
    procedure BeginUpdate; inline;
    procedure EndUpdate; inline;
    property Owner: TPersistent read FOwner;
    property OnNotifyChange: TNotifyEvent read FOnNotifyChange write FOnNotifyChange;
  end;

  {A base class describing the "cadenceing" interface.  }
  TGLCadenceAbleComponent = class(TGLComponent, IGLProgessAble)
  public

    procedure DoProgress(const progressTime: TProgressTimes); virtual;
  end;

  {A base class describing the "update" interface.  }
  TGLUpdateAbleComponent = class(TGLCadenceAbleComponent, IGLNotifyAble)
  public

    procedure NotifyChange(Sender: TObject); virtual;
  end;

  TGLNotifyCollection = class(TOwnedCollection)
  private
    FOnNotifyChange: TNotifyEvent;
  protected
    procedure Update(item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; AItemClass: TCollectionItemClass);
    property OnNotifyChange: TNotifyEvent read FOnNotifyChange write FOnNotifyChange;
  end;

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
implementation
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

//---------------------- TGLUpdateAbleObject -----------------------------------

constructor TGLUpdateAbleObject.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TGLUpdateAbleObject.NotifyChange(Sender: TObject);
begin
  if FUpdating = 0 then
  begin
    if Assigned(Owner) then
    begin
      if Owner is TGLUpdateAbleObject then
        TGLUpdateAbleObject(Owner).NotifyChange(Self)
      else if Owner is TGLUpdateAbleComponent then
        TGLUpdateAbleComponent(Owner).NotifyChange(Self);
    end;
    if Assigned(FOnNotifyChange) then
      FOnNotifyChange(Self);
  end;
end;

procedure TGLUpdateAbleObject.Notification(Sender: TObject; Operation: TOperation);
begin
end;

function TGLUpdateAbleObject.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TGLUpdateAbleObject.BeginUpdate;
begin
  Inc(FUpdating);
end;

procedure TGLUpdateAbleObject.EndUpdate;
begin
  Dec(FUpdating);
  if FUpdating <= 0 then
  begin
    Assert(FUpdating = 0);
    NotifyChange(Self);
  end;
end;

// ------------------
// ------------------ TGLCadenceAbleComponent ------------------
// ------------------

procedure TGLCadenceAbleComponent.DoProgress(const progressTime: TProgressTimes);
begin
  // nothing
end;

// ------------------
// ------------------ TGLUpdateAbleObject ------------------
// ------------------

procedure TGLUpdateAbleComponent.NotifyChange(Sender: TObject);
begin
  if Assigned(Owner) then
    if (Owner is TGLUpdateAbleComponent) then
      (Owner as TGLUpdateAbleComponent).NotifyChange(Self);
end;

// ------------------
// ------------------ TGLNotifyCollection ------------------
// ------------------

constructor TGLNotifyCollection.Create(AOwner: TPersistent; AItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, AItemClass);
  if Assigned(AOwner) and (AOwner is TGLUpdateAbleComponent) then
    OnNotifyChange := TGLUpdateAbleComponent(AOwner).NotifyChange;
end;

procedure TGLNotifyCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if Assigned(FOnNotifyChange) then
    FOnNotifyChange(Self);
end;

end.

