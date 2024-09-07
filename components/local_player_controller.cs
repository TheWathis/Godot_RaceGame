using Godot;
using System;

// Class for the local player (car) controller
public partial class local_player_controller : Node
{
  // The desired force of the engine
  [Export] public float engineForce = 0.0f;
  // The desired force of the brakes
  [Export] public float brakeForce = 0.0f;
  // The desired direction of the car
  [Export] public float steerTarget = 0.0f;

  public override void _PhysicsProcess(double delta)
  {
    if (!IsMultiplayerAuthority())
    {
      return;
    }

    // Get input from keyboard actions
    engineForce = Input.GetActionStrength("accelerate");
    brakeForce = Input.GetActionStrength("brake");
    steerTarget = Input.GetAxis("turn_right", "turn_left");
  }
}
