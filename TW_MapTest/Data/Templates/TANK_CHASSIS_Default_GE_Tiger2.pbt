Assets {
  Id: 2498608042342450754
  Name: "TANK_CHASSIS_Default_GE_Tiger2"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 12750289463121341098
      Objects {
        Id: 12750289463121341098
        Name: "TANK_CHASSIS_Default_GE_Tiger2"
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
          Mass: 50000
          PhysicsBodyScale {
            X: 11.5
            Y: 7
            Z: 1.8
          }
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -80
            Z: 70
          }
          MaxSpeed: 720
          AccelerationRate: 1300
          DecelerationRate: 15
          BrakeStrength: 15
          TireFriction: 4
          CenterOfMassOFfset {
            X: -70
            Z: 20
          }
          GravityScale: 2.6
          CoastBrakeStrength: 10
          Tank {
            LeftTreadRadius: 70
            LeftTreadWidth: 80
            RightTreadRadius: 70
            RightTreadWidth: 80
            LeftTreadOffset {
              X: -80
              Y: -250
              Z: 70
            }
            RightTreadOffset {
              X: -80
              Y: 250
              Z: 70
            }
            HandbrakeBinding {
              Value: "mc:egameaction:extraaction_27"
            }
            TurnSpeed: 30
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 94
}
