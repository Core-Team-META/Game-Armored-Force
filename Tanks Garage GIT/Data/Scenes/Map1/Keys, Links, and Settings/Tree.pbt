Name: "Keys, Links, and Settings"
RootId: 13966797509968964878
Objects {
  Id: 2911846559236864704
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
  ParentId: 13966797509968964878
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
  Id: 9431579987956007090
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
  ParentId: 13966797509968964878
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
  Id: 17736868490696546371
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
  ParentId: 13966797509968964878
  UnregisteredParameters {
    Overrides {
      Name: "cs:MatchDestroyed"
      NetReference {
        Key: "1E428694127B3A42"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:MatchDamage"
      NetReference {
        Key: "69F38F9E0AC35D5C"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalDestroyed"
      NetReference {
        Key: "E89D215FA147D48E"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalDamage"
      NetReference {
        Key: "C75FD87B1C50EEA0"
        Type {
          Value: "mc:enetreferencetype:leaderboard"
        }
      }
    }
    Overrides {
      Name: "cs:TotalWinRate"
      NetReference {
        Key: "DCDE795C250E72DF"
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
  Id: 8053548290070406507
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
  ParentId: 13966797509968964878
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
