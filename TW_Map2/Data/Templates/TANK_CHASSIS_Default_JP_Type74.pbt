Assets {
  Id: 10551614147404729915
  Name: "TANK_CHASSIS_Default_JP_Type74"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 2087225168826052556
      Objects {
        Id: 2087225168826052556
        Name: "TANK_CHASSIS_Default_JP_Type74"
        Transform {
          Scale {
            X: 1
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
          Mass: 38000
          PhysicsBodyScale {
            X: 8
            Y: 3.2
            Z: 1.7
          }
          IsDriverHidden: true
          IsDriverAttached: true
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -90
            Z: 70
          }
          MaxSpeed: 1200
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
            LeftTreadRadius: 90
            LeftTreadWidth: 125
            RightTreadRadius: 90
            RightTreadWidth: 125
            LeftTreadOffset {
              X: -30
              Y: -240
              Z: 90
            }
            RightTreadOffset {
              X: -30
              Y: 240
              Z: 90
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
