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
          Mass: 50000
          PhysicsBodyScale {
            X: 14
            Y: 7
            Z: 2
          }
          ExitBinding {
            Value: "mc:egameaction:invalid"
          }
          PhysicsBodyOffset {
            X: -40
            Z: 70
          }
          MaxSpeed: 1120
          AccelerationRate: 600
          DecelerationRate: 15
          BrakeStrength: 15
          TireFriction: 2
          CenterOfMassOFfset {
            X: -40
            Z: 20
          }
          GravityScale: 2.6
          CoastBrakeStrength: 10
          DamageSettings {
            StartImmortal: true
          }
          Tank {
            LeftTreadRadius: 80
            LeftTreadWidth: 80
            RightTreadRadius: 80
            RightTreadWidth: 80
            LeftTreadOffset {
              X: -40
              Y: -250
              Z: 80
            }
            RightTreadOffset {
              X: -40
              Y: 250
              Z: 80
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
  SerializationVersion: 97
}
