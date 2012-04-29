class UTVehicleFactory_XFighter extends UTVehicleFactory_Cicada;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_Cicada.Mesh.SK_VH_Cicada'
		Translation=(X=-40.0,Y=0.0,Z=-70.0)
	End Object


	Begin Object Name=CollisionCylinder
		CollisionHeight=+120.0
		CollisionRadius=+200.0
		Translation=(X=0.0,Y=0.0,Z=-40.0)
	End Object

	DrawScale=1
	VehicleClass="UTVehicle_XFighter_Content"
	VehicleClassPath="IWars.UTVehicle_XFighter_Content"
}