Name: "Keys, Links, and Settings"
RootId: 13525167241272998667
Objects {
  Id: 18332550613480876866
  Name: "Settings"
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
  ParentId: 13525167241272998667
  UnregisteredParameters {
    Overrides {
      Name: "cs:MatchMode"
      String: "Frontline"
    }
    Overrides {
      Name: "cs:LobbyCountdown"
      Int: 40
    }
    Overrides {
      Name: "cs:MatchMaxDuration"
      Int: 1200
    }
    Overrides {
      Name: "cs:CardMaxDuration"
      Int: 5
    }
    Overrides {
      Name: "cs:VictoryMaxDuration"
      Int: 20
    }
    Overrides {
      Name: "cs:StatsMaxDuration"
      Int: 20
    }
  }
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
    Value: "mc:eindicatorvisibility:visiblewhenselected"
  }
  Script {
    ScriptAsset {
      Id: 7627234086622722874
    }
  }
}
Objects {
  Id: 9769969992331536075
  Name: "Links"
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
  ParentId: 13525167241272998667
  UnregisteredParameters {
    Overrides {
      Name: "cs:Garage"
      String: "bf3d88/armored-force"
    }
    Overrides {
      Name: "cs:Map1"
      String: "f19478/armored-force-frontline"
    }
  }
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
    Value: "mc:eindicatorvisibility:visiblewhenselected"
  }
  Script {
    ScriptAsset {
      Id: 7627234086622722874
    }
  }
}
Objects {
  Id: 13331734031230280238
  Name: "Leaderboards"
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
  ParentId: 13525167241272998667
  UnregisteredParameters {
    Overrides {
      Name: "cs:MatchDestroyed"
      NetReference {
        Key: "0308B347B7382831"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:MatchDamage"
      NetReference {
        Key: "A225E4E8B069DF06"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalDestroyed"
      NetReference {
        Key: "C4F81C2022FF674F"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalDamage"
      NetReference {
        Key: "51B170A174D269BF"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalWinRate"
      NetReference {
        Key: "9FB1C58183084EF6"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
  }
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
    Value: "mc:eindicatorvisibility:visiblewhenselected"
  }
  Script {
    ScriptAsset {
      Id: 7627234086622722874
    }
  }
}
Objects {
  Id: 1947573229981394095
  Name: "Keys"
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
  ParentId: 13525167241272998667
  UnregisteredParameters {
    Overrides {
      Name: "cs:Tanks"
      NetReference {
        Key: "fa9ee29be1d64b50a639f83e782c272b"
        Type {
          Value: "mc:enetreferencetype:sharedpersistence"
        }
      }
    }
    Overrides {
      Name: "cs:Achievements"
      NetReference {
        Type {
          Value: "mc:enetreferencetype:unknown"
        }
      }
    }
    Overrides {
      Name: "cs:Leaderboards"
      NetReference {
        Type {
          Value: "mc:enetreferencetype:unknown"
        }
      }
    }
    Overrides {
      Name: "cs:Skins"
      NetReference {
        Type {
          Value: "mc:enetreferencetype:unknown"
        }
      }
    }
  }
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
    Value: "mc:eindicatorvisibility:visiblewhenselected"
  }
  Script {
    ScriptAsset {
      Id: 7627234086622722874
    }
  }
}
