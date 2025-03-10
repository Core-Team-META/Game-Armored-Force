Assets {
  Id: 6202995398843253048
  Name: "TANK_CHASSIS_Upgraded_GE_PantherD"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 13454049678549189348
      Objects {
        Id: 13454049678549189348
        Name: "TANK_CHASSIS_Upgraded_GE_PantherD"
        Transform {
          Scale {
            X: 1.15
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:alwaysvisible"
        }
        Vehicle {
          DriverPosition {
            Z: 200
          }
          DriverRotation {
          }
          EnterTrigger {
            SelfId: 841534158063459245
          }
          Camera {
          }
          Mass: 45000
          PhysicsBodyScale {
            X: 5
            Y: 3
            Z: 1.3
          }
          IsDriverHidden: true
          IsDriverAttached: true
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -50
            Z: 105
          }
          MaxSpeed: 1475
          AccelerationRate: 400
          DecelerationRate: 15
          BrakeStrength: 1031
          TireFriction: 10
          CenterOfMassOFfset {
            Z: 20
          }
          GravityScale: 1
          CoastBrakeStrength: 103.1
          Tank {
            LeftTreadRadius: 70
            LeftTreadWidth: 120
            RightTreadRadius: 70
            RightTreadWidth: 120
            LeftTreadOffset {
              X: -30
              Y: -200
              Z: 65
            }
            RightTreadOffset {
              X: -30
              Y: 200
              Z: 65
            }
            HandbrakeBinding {
              Value: "mc:egameaction:extraaction_27"
            }
            TurnSpeed: 65
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 93
}
