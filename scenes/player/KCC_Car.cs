using Godot;
using System;

[GlobalClass]
public partial class KCC_Car : RigidBody3D {

  public Vector3 SphereOffset = Vector3.Down;
  public double Acceleration = 35;
  public double Steering = 18;
  public double TurnSpeed = 4;
  public double TurnStopLimit = 0.75;

  public double SpeedInput = 0;
  public double TurnInput = 0;

  private RayCast3D _rayCast;
  private MeshInstance3D _mesh;
  private MeshInstance3D _wheelFL;
  private MeshInstance3D _wheelFR;

  public override void _Ready() {
    _mesh = GetNode<MeshInstance3D>("BaseCar");
    _wheelFL = _mesh.GetNode<MeshInstance3D>("F_L");
    _wheelFR = _mesh.GetNode<MeshInstance3D>("F_R");
    _rayCast = GetNode<RayCast3D>("RayCast3D");
  }

  public override void _PhysicsProcess(double delta) {
    base._PhysicsProcess(delta);
    _mesh.Position = Position + SphereOffset;
    if (_rayCast.IsColliding()) {
      ApplyCentralForce(_mesh.GlobalBasis.Z * (float)SpeedInput);
    }
  }

  public override void _Process(double delta) {
    base._Process(delta);
    if (!_rayCast.IsColliding()) {
      return;
    }

    SpeedInput = Input.GetAxis("brake", "accelerate") * Acceleration;
    TurnInput = Input.GetAxis("turn_left", "turn_right") * Mathf.DegToRad(Steering);
    _wheelFR.RotateY((float)TurnInput);
    _wheelFL.RotateY((float)TurnInput);

    if (LinearVelocity.Length() > TurnStopLimit) {
      Basis NewBasis = _mesh.GlobalBasis.Rotated(
        _mesh.GlobalBasis.Y, (float)TurnInput
      );
      _mesh.GlobalBasis = _mesh.GlobalBasis.Slerp(
        NewBasis, (float)TurnSpeed * (float)delta
      );
      _mesh.GlobalBasis = _mesh.GlobalBasis.Orthonormalized();
    }
  }
}
