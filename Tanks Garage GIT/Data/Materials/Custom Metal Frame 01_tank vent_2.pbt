Assets {
  Id: 14190265191030884417
  Name: "Custom Metal Frame 01_tank vent_2"
  PlatformAssetType: 13
  SerializationVersion: 101
  CustomMaterialAsset {
    BaseMaterialId: 15321755826573265950
    ParameterOverrides {
      Overrides {
        Name: "rotate_material"
        Float: 45
      }
      Overrides {
        Name: "v_tiles"
        Float: 3
      }
      Overrides {
        Name: "u_tiles"
        Float: 8
      }
      Overrides {
        Name: "roughness_multiplier"
        Float: 1
      }
    }
    Assets {
      Id: 15321755826573265950
      Name: "Metal Frame 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_metal_frames_001_uv"
      }
    }
  }
}
