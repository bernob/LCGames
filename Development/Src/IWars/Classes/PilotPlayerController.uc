class PilotPlayerController extends PlayerController;

state PlayerDriving
{
ignores SeePlayer, HearNoise, Bump;

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

	// Set the throttle, steering etc. for the vehicle based on the input provided
	function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
	{
		local UTVehicle_XFighter CurrentVehicle;

		CurrentVehicle = UTVehicle_XFighter(Pawn);
		if (CurrentVehicle != None)
		{
			//`log("Forward:"@InForward@" Strafe:"@InStrafe@" Up:"@InUp);
			bPressedJump = InJump;
			CurrentVehicle.SetInputsWithPitch(InForward, -InStrafe, InUp, PlayerInput.aMouseY, PlayerInput.aMouseX);
			CheckJumpOrDuck();
		}
	}

	function PlayerMove( float DeltaTime )
	{
		// update 'looking' rotation
		UpdateRotation(DeltaTime);

		// TODO: Don't send things like aForward and aStrafe for gunners who don't need it
		// Only servers can actually do the driving logic.
		ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
		if (Role < ROLE_Authority)
		{
			ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		}

		bPressedJump = false;
	}

	unreliable server function ServerUse()
	{
		local Vehicle CurrentVehicle;

		CurrentVehicle = Vehicle(Pawn);
		CurrentVehicle.DriverLeave(false);
	}

	event BeginState(Name PreviousStateName)
	{
		CleanOutSavedMoves();
	}

	event EndState(Name NextStateName)
	{
		CleanOutSavedMoves();
	}
}
DefaultProperties
{
}
