Assets {
  Id: 324122271395806994
  Name: "TANK_CHASSIS_Upgraded_GE_Tiger2"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 17053408649802835104
      Objects {
        Id: 17053408649802835104
        Name: "TANK_CHASSIS_Upgraded_GE_Tiger2"
        Transform {
          Scale {
            X: 1.5
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
          Mass: 70000
          PhysicsBodyScale {
            X: 5
            Y: 3.5
            Z: 1.2
          }
          IsDriverHidden: true
          IsDriverAttached: true
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -30
            Z: 105
          }
          MaxSpeed: 1050
          AccelerationRate: 400
          DecelerationRate: 15
          BrakeStrength: 713
          TireFriction: 10
          CenterOfMassOFfset {
            Z: 20
          }
          GravityScale: 1
          CoastBrakeStrength: 71.3
          Tank {
            LeftTreadRadius: 55
            LeftTreadWidth: 110
            RightTreadRadius: 55
            RightTreadWidth: 110
            LeftTreadOffset {
              X: -20
              Y: -255
              Z: 57
            }
            RightTreadOffset {
              X: -20
              Y: 255
              Z: 57
            }
            HandbrakeBinding {
              Value: "mc:egameaction:extraaction_27"
            }
            TurnSpeed: 60
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
