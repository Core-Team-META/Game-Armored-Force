Assets {
  Id: 5378724831550057665
  Name: "Lock Cursor to Screen"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 6253506126193878080
      Objects {
        Id: 6253506126193878080
        Name: "Lock Cursor to Screen"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 1109124758184799295
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceoff"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:forceoff"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 1109124758184799295
        Name: "LockCursorToScreen"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 6253506126193878080
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 963903306325518875
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Description: "This CC will ensure that your cursor does not leave the screen/game while you are playing as to make sure it does not go to a secondary monitor."
  }
  SerializationVersion: 93
  DirectlyPublished: true
}
