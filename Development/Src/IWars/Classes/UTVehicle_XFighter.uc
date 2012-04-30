class UTVehicle_XFighter extends UTVehicle_Cicada;

var() float Pitch;
var() float Yawn;
var() bool bRealisticPhysics;

simulated function VehicleCalcCamera (float DeltaTime, int SeatIndex, out vector out_CamLoc, out rotator out_CamRot, out vector CamStart, optional bool bPivotOnly)
{
	GetActorEyesViewPoint(out_CamLoc, out_CamRot);
	out_CamRot = Rotation;
}

simulated function SetInputsWithPitch(float InForward, float InStrafe, float InUp,float InPitch,float InYawn)
{
	Throttle = InForward;
	Steering = InStrafe;
	Rise = InUp;
	Pitch=InPitch;
	Yawn=InYawn;
}

simulated function Tick(float DeltaTime)
{
	local Vector    
		AR_ForwardsNormalX, 
		AR_SidewardsNormalY, 
		AR_UpwardsNormalZ, 
		AR_RotationForwardsNormalX, 
		AR_RotationSidewardsNormalY, 
		AR_RotationUpwardsNormalZ, 
		AR_TranslationForwardsNormalX, 
		AR_TranslationSidewardsNormalY, 
		AR_TranslationUpwardsNormalZ, 
		AR_ForceRotation,
		AR_ForceTranslation;

	local Rotator AbsoluteRotation;
	
	if(bDriving)
	{
		SetHidden(true);
		bRealisticPhysics=false;
		if (PlayerController(Controller) != None)
		{
			if(bRealisticPhysics)
			{
				GetAxes(Rotation, AR_ForwardsNormalX, AR_SidewardsNormalY, AR_UpwardsNormalZ);

				if(Rise != 0) { Rise /= Abs(Rise); }
				
				AR_RotationForwardsNormalX  = AR_ForwardsNormalX	* 1000 * Steering;		//Roll
				AR_RotationSidewardsNormalY = AR_SidewardsNormalY	* 1 * Pitch/100;      //Pitch
				AR_RotationUpwardsNormalZ   = AR_UpwardsNormalZ	    * 1 * Yawn/100;       //Yaw
				AR_ForceRotation = AR_RotationForwardsNormalX + AR_RotationSidewardsNormalY + AR_RotationUpwardsNormalZ; // Add them together to get final rotation vector
	
				AR_TranslationForwardsNormalX  = AR_ForwardsNormalX	    * 1000 * Throttle;	//Forward/Backward
				AR_TranslationSidewardsNormalY = AR_SidewardsNormalY	* 30 * Steering*0;	//Sideways
				AR_TranslationUpwardsNormalZ   = AR_UpwardsNormalZ	    * 1000 * Rise;		//Up/Down
				AR_ForceTranslation = AR_TranslationForwardsNormalX + AR_TranslationSidewardsNormalY + AR_TranslationUpwardsNormalZ; // Add them together to get final rotation vector

				Mesh.AddForce(AR_ForceTranslation);
				Mesh.AddTorque(AR_ForceRotation);
			}
			else
			{
				GetAxes(Rotation, AR_ForwardsNormalX, AR_SidewardsNormalY, AR_UpwardsNormalZ);
				if(Rise != 0) { Rise /= Abs(Rise); }
				AbsoluteRotation.Pitch = Rotation.Pitch + Pitch;
				AbsoluteRotation.Roll = Rotation.Roll;
				AbsoluteRotation.Yaw = Rotation.Yaw + Yawn;
				
				AR_TranslationForwardsNormalX  = AR_ForwardsNormalX	    * 1000 * Throttle;	//Forward/Backward
				AR_TranslationSidewardsNormalY = AR_SidewardsNormalY	* 1000 * Steering;	//Sideways
				AR_TranslationUpwardsNormalZ   = AR_UpwardsNormalZ	    * 1000 * Rise;		//Up/Down
				AR_ForceTranslation = AR_TranslationForwardsNormalX + AR_TranslationSidewardsNormalY + AR_TranslationUpwardsNormalZ; // Add them together to get final rotation vector

				Mesh.SetRBRotation(AbsoluteRotation);
				Mesh.AddForce(AR_ForceTranslation);
				

				`log("Velocity: "@Velocity);
				`log("Rotation: "@Rotation);
				`log("ForceForward: "@AR_ForwardsNormalX);
			}
		}
	
	Super.Tick(DeltaTime);
	}
}

DefaultProperties 
{
	SimObj=UDKVehicleSimChopper
	bStayUpright=false
	bFixedCamZ=false
}
