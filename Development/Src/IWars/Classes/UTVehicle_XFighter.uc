class UTVehicle_XFighter extends UTVehicle_Cicada;

var() float Pitch;
var() float Yawn;

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

	GetAxes(Rotation, AR_ForwardsNormalX, AR_SidewardsNormalY, AR_UpwardsNormalZ);

	if(bDriving)
	{
		SetHidden(true);
	}
	
	//Mesh.AddForce(AR_UpwardsNormalZ*(-0));
	if (PlayerController(Controller) != None)
	{
		if(Rise != 0) {Rise /= Abs(Rise);}
		AR_RotationForwardsNormalX  = AR_ForwardsNormalX	* 1000 * Steering;		//Roll
		AR_RotationSidewardsNormalY = AR_SidewardsNormalY	* 300 * Pitch/100;      //Pitch
		AR_RotationUpwardsNormalZ   = AR_UpwardsNormalZ	    * 300 * Yawn/100;       //Yaw
		AR_ForceRotation = AR_RotationForwardsNormalX + AR_RotationSidewardsNormalY + AR_RotationUpwardsNormalZ; // Add them together to get final rotation vector
	
		AR_TranslationForwardsNormalX  = AR_ForwardsNormalX	    * 1000 * Throttle;	//Forward/Backward
		AR_TranslationSidewardsNormalY = AR_SidewardsNormalY	* 30 * Steering*0;	//Sideways
		AR_TranslationUpwardsNormalZ   = AR_UpwardsNormalZ	    * 1000 * Rise;		//Up/Down
		AR_ForceTranslation = AR_TranslationForwardsNormalX + AR_TranslationSidewardsNormalY + AR_TranslationUpwardsNormalZ; // Add them together to get final rotation vector

		Mesh.AddForce(AR_ForceTranslation);
		Mesh.AddTorque(AR_ForceRotation);
	}
	
	Super.Tick(DeltaTime);
}

DefaultProperties 
{
	SimObj=none
	bStayUpright=false
	bFixedCamZ=false
}
