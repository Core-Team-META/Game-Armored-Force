Assets {
  Id: 6798521115850491294
  Name: "TANK_CHASSIS_Default_USSR_IS3"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 6627506282493155443
      Objects {
        Id: 6627506282493155443
        Name: "TANK_CHASSIS_Default_USSR_IS3"
        Transform {
          Scale {
            X: 1.55
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
          Mass: 50000
          PhysicsBodyScale {
            X: 5
            Y: 3.5
            Z: 1
          }
          IsDriverHidden: true
          IsDriverAttached: true
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -70
            Z: 105
          }
          MaxSpeed: 800
          AccelerationRate: 400
          DecelerationRate: 15
          BrakeStrength: 1
          TireFriction: 10
          CenterOfMassOFfset {
            Z: 20
          }
          GravityScale: 1
          CoastBrakeStrength: 0.1
          Tank {
            LeftTreadRadius: 70
            LeftTreadWidth: 100
            RightTreadRadius: 70
            RightTreadWidth: 100
            LeftTreadOffset {
              Y: -225
              Z: 67
            }
            RightTreadOffset {
              X: -25
              Y: 225
              Z: 67
            }
            HandbrakeBinding {
              Value: "mc:egameaction:extraaction_27"
            }
            TurnSpeed: 50
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
