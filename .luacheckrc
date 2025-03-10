stds.core = {
	read_globals = {
		-- Classes
		"AIActivity",
		"AIActivity.name",
		"AIActivity.owner",
		"AIActivity.priority",
		"AIActivity.isDebugModeEnabled",
		"AIActivity.isHighestPriority",
		"AIActivity.elapsedTime",
		"AIActivity.type",
		"AIActivity.IsA",
		"AIActivityHandler",
		"AIActivityHandler.isSelectedInDebugger",
		"AIActivityHandler.type",
		"AIActivityHandler.AddActivity",
		"AIActivityHandler.RemoveActivity",
		"AIActivityHandler.ClearActivities",
		"AIActivityHandler.GetActivities",
		"AIActivityHandler.FindActivity",
		"AIActivityHandler.IsA",
		"Ability",
		"Ability.actionBinding",
		"Ability.canActivateWhileDead",
		"Ability.animation",
		"Ability.canBePrevented",
		"Ability.castPhaseSettings",
		"Ability.executePhaseSettings",
		"Ability.recoveryPhaseSettings",
		"Ability.cooldownPhaseSettings",
		"Ability.isEnabled",
		"Ability.owner",
		"Ability.type",
		"Ability.GetTargetData",
		"Ability.SetTargetData",
		"Ability.GetCurrentPhase",
		"Ability.GetPhaseTimeRemaining",
		"Ability.Interrupt",
		"Ability.Activate",
		"Ability.AdvancePhase",
		"Ability.IsA",
		"AbilityPhaseSettings",
		"AbilityPhaseSettings.duration",
		"AbilityPhaseSettings.canMove",
		"AbilityPhaseSettings.canJump",
		"AbilityPhaseSettings.canRotate",
		"AbilityPhaseSettings.preventsOtherAbilities",
		"AbilityPhaseSettings.isTargetDataUpdated",
		"AbilityPhaseSettings.facingMode",
		"AbilityPhaseSettings.type",
		"AbilityPhaseSettings.IsA",
		"AbilityTarget",
		"AbilityTarget.hitPlayer",
		"AbilityTarget.hitObject",
		"AbilityTarget.spreadHalfAngle",
		"AbilityTarget.spreadRandomSeed",
		"AbilityTarget.type",
		"AbilityTarget.GetOwnerMovementRotation",
		"AbilityTarget.SetOwnerMovementRotation",
		"AbilityTarget.GetAimPosition",
		"AbilityTarget.SetAimPosition",
		"AbilityTarget.GetAimDirection",
		"AbilityTarget.SetAimDirection",
		"AbilityTarget.GetHitPosition",
		"AbilityTarget.SetHitPosition",
		"AbilityTarget.GetHitResult",
		"AbilityTarget.SetHitResult",
		"AbilityTarget.IsA",
		"AnimatedMesh",
		"AnimatedMesh.animationStance",
		"AnimatedMesh.animationStancePlaybackRate",
		"AnimatedMesh.animationStanceShouldLoop",
		"AnimatedMesh.playbackRateMultiplier",
		"AnimatedMesh.type",
		"AnimatedMesh.GetAnimationNames",
		"AnimatedMesh.GetAnimationStanceNames",
		"AnimatedMesh.GetSocketNames",
		"AnimatedMesh.GetAnimationEventNames",
		"AnimatedMesh.AttachCoreObject",
		"AnimatedMesh.PlayAnimation",
		"AnimatedMesh.StopAnimations",
		"AnimatedMesh.GetAnimationDuration",
		"AnimatedMesh.SetMeshForSlot",
		"AnimatedMesh.GetMeshForSlot",
		"AnimatedMesh.SetMaterialForSlot",
		"AnimatedMesh.GetMaterialSlot",
		"AnimatedMesh.GetMaterialSlots",
		"AnimatedMesh.ResetMaterialSlot",
		"AnimatedMesh.IsA",
		"AreaLight",
		"AreaLight.sourceWidth",
		"AreaLight.sourceHeight",
		"AreaLight.barnDoorAngle",
		"AreaLight.barnDoorLength",
		"AreaLight.type",
		"AreaLight.IsA",
		"Audio",
		"Audio.isSpatializationEnabled",
		"Audio.isAttenuationEnabled",
		"Audio.isOcclusionEnabled",
		"Audio.isAutoPlayEnabled",
		"Audio.isTransient",
		"Audio.isAutoRepeatEnabled",
		"Audio.pitch",
		"Audio.volume",
		"Audio.radius",
		"Audio.falloff",
		"Audio.isPlaying",
		"Audio.length",
		"Audio.currentPlaybackTime",
		"Audio.fadeInTime",
		"Audio.fadeOutTime",
		"Audio.startTime",
		"Audio.stopTime",
		"Audio.type",
		"Audio.Play",
		"Audio.Stop",
		"Audio.FadeIn",
		"Audio.FadeOut",
		"Audio.IsA",
		"BindingSet",
		"BindingSet.type",
		"BindingSet.IsA",
		"Camera",
		"Camera.followPlayer",
		"Camera.isOrthographic",
		"Camera.fieldOfView",
		"Camera.viewWidth",
		"Camera.useCameraSocket",
		"Camera.currentDistance",
		"Camera.isDistanceAdjustable",
		"Camera.minDistance",
		"Camera.maxDistance",
		"Camera.rotationMode",
		"Camera.hasFreeControl",
		"Camera.currentPitch",
		"Camera.minPitch",
		"Camera.maxPitch",
		"Camera.isYawLimited",
		"Camera.currentYaw",
		"Camera.minYaw",
		"Camera.maxYaw",
		"Camera.useAsAudioListener",
		"Camera.audioListenerOffset",
		"Camera.lerpTime",
		"Camera.isUsingCameraRotation",
		"Camera.type",
		"Camera.GetPositionOffset",
		"Camera.SetPositionOffset",
		"Camera.GetRotationOffset",
		"Camera.SetRotationOffset",
		"Camera.GetAudioListenerOffset",
		"Camera.SetAudioListenerOffset",
		"Camera.Capture",
		"Camera.IsA",
		"CameraCapture",
		"CameraCapture.resolution",
		"CameraCapture.camera",
		"CameraCapture.type",
		"CameraCapture.IsValid",
		"CameraCapture.Refresh",
		"CameraCapture.Release",
		"CameraCapture.IsA",
		"Color",
		"Color.r",
		"Color.g",
		"Color.b",
		"Color.a",
		"Color.type",
		"Color.GetDesaturated",
		"Color.ToStandardHex",
		"Color.ToLinearHex",
		"Color.IsA",
		"CoreFriendCollection",
		"CoreFriendCollection.hasMoreResults",
		"CoreFriendCollection.type",
		"CoreFriendCollection.GetResults",
		"CoreFriendCollection.GetMoreResults",
		"CoreFriendCollection.IsA",
		"CoreFriendCollectionEntry",
		"CoreFriendCollectionEntry.id",
		"CoreFriendCollectionEntry.name",
		"CoreFriendCollectionEntry.type",
		"CoreFriendCollectionEntry.IsA",
		"CoreGameCollectionEntry",
		"CoreGameCollectionEntry.id",
		"CoreGameCollectionEntry.parentGameId",
		"CoreGameCollectionEntry.name",
		"CoreGameCollectionEntry.ownerId",
		"CoreGameCollectionEntry.ownerName",
		"CoreGameCollectionEntry.isPromoted",
		"CoreGameCollectionEntry.type",
		"CoreGameCollectionEntry.IsA",
		"CoreGameEvent",
		"CoreGameEvent.id",
		"CoreGameEvent.gameId",
		"CoreGameEvent.name",
		"CoreGameEvent.referenceName",
		"CoreGameEvent.description",
		"CoreGameEvent.state",
		"CoreGameEvent.registeredPlayerCount",
		"CoreGameEvent.type",
		"CoreGameEvent.GetTags",
		"CoreGameEvent.GetStartDateTime",
		"CoreGameEvent.GetEndDateTime",
		"CoreGameEvent.IsA",
		"CoreGameEventCollection",
		"CoreGameEventCollection.hasMoreResults",
		"CoreGameEventCollection.type",
		"CoreGameEventCollection.GetResults",
		"CoreGameEventCollection.GetMoreResults",
		"CoreGameEventCollection.IsA",
		"CoreGameInfo",
		"CoreGameInfo.id",
		"CoreGameInfo.parentGameId",
		"CoreGameInfo.name",
		"CoreGameInfo.description",
		"CoreGameInfo.ownerId",
		"CoreGameInfo.ownerName",
		"CoreGameInfo.maxPlayers",
		"CoreGameInfo.isQueueEnabled",
		"CoreGameInfo.screenshotCount",
		"CoreGameInfo.hasWorldCapture",
		"CoreGameInfo.type",
		"CoreGameInfo.GetTags",
		"CoreGameInfo.IsA",
		"CoreMesh",
		"CoreMesh.meshAssetId",
		"CoreMesh.team",
		"CoreMesh.isTeamColorUsed",
		"CoreMesh.isTeamCollisionEnabled",
		"CoreMesh.isEnemyCollisionEnabled",
		"CoreMesh.isCameraCollisionEnabled",
		"CoreMesh.type",
		"CoreMesh.GetColor",
		"CoreMesh.SetColor",
		"CoreMesh.ResetColor",
		"CoreMesh.IsA",
		"CoreObject",
		"CoreObject.name",
		"CoreObject.id",
		"CoreObject.isVisible",
		"CoreObject.visibility",
		"CoreObject.isCollidable",
		"CoreObject.collision",
		"CoreObject.cameraCollision",
		"CoreObject.isEnabled",
		"CoreObject.lifeSpan",
		"CoreObject.isStatic",
		"CoreObject.isNetworked",
		"CoreObject.isClientOnly",
		"CoreObject.isServerOnly",
		"CoreObject.parent",
		"CoreObject.sourceTemplateId",
		"CoreObject.type",
		"CoreObject.GetReference",
		"CoreObject.GetTransform",
		"CoreObject.SetTransform",
		"CoreObject.GetPosition",
		"CoreObject.SetPosition",
		"CoreObject.GetRotation",
		"CoreObject.SetRotation",
		"CoreObject.GetScale",
		"CoreObject.SetScale",
		"CoreObject.GetWorldTransform",
		"CoreObject.SetWorldTransform",
		"CoreObject.GetWorldPosition",
		"CoreObject.SetWorldPosition",
		"CoreObject.GetWorldRotation",
		"CoreObject.SetWorldRotation",
		"CoreObject.GetWorldScale",
		"CoreObject.SetWorldScale",
		"CoreObject.GetVelocity",
		"CoreObject.SetVelocity",
		"CoreObject.GetAngularVelocity",
		"CoreObject.SetAngularVelocity",
		"CoreObject.SetLocalAngularVelocity",
		"CoreObject.GetChildren",
		"CoreObject.AttachToPlayer",
		"CoreObject.AttachToLocalView",
		"CoreObject.Detach",
		"CoreObject.GetAttachedToSocketName",
		"CoreObject.IsVisibleInHierarchy",
		"CoreObject.IsCollidableInHierarchy",
		"CoreObject.IsCameraCollidableInHierarchy",
		"CoreObject.IsEnabledInHierarchy",
		"CoreObject.FindAncestorByName",
		"CoreObject.FindChildByName",
		"CoreObject.FindDescendantByName",
		"CoreObject.FindDescendantsByName",
		"CoreObject.FindAncestorByType",
		"CoreObject.FindChildByType",
		"CoreObject.FindDescendantByType",
		"CoreObject.FindDescendantsByType",
		"CoreObject.FindTemplateRoot",
		"CoreObject.IsAncestorOf",
		"CoreObject.MoveTo",
		"CoreObject.MoveContinuous",
		"CoreObject.Follow",
		"CoreObject.StopMove",
		"CoreObject.RotateTo",
		"CoreObject.RotateContinuous",
		"CoreObject.LookAt",
		"CoreObject.LookAtContinuous",
		"CoreObject.LookAtLocalView",
		"CoreObject.StopRotate",
		"CoreObject.ScaleTo",
		"CoreObject.ScaleContinuous",
		"CoreObject.StopScale",
		"CoreObject.ReorderBeforeSiblings",
		"CoreObject.ReorderAfterSiblings",
		"CoreObject.ReorderBefore",
		"CoreObject.ReorderAfter",
		"CoreObject.Destroy",
		"CoreObject.GetCustomProperties",
		"CoreObject.GetCustomProperty",
		"CoreObject.SetCustomProperty",
		"CoreObject.SetNetworkedCustomProperty",
		"CoreObject.IsA",
		"CoreObjectReference",
		"CoreObjectReference.id",
		"CoreObjectReference.isAssigned",
		"CoreObjectReference.type",
		"CoreObjectReference.GetObject",
		"CoreObjectReference.WaitForObject",
		"CoreObjectReference.IsA",
		"CorePlayerProfile",
		"CorePlayerProfile.id",
		"CorePlayerProfile.name",
		"CorePlayerProfile.description",
		"CorePlayerProfile.type",
		"CorePlayerProfile.IsA",
		"CurveKey",
		"CurveKey.interpolation",
		"CurveKey.time",
		"CurveKey.value",
		"CurveKey.arriveTangent",
		"CurveKey.leaveTangent",
		"CurveKey.type",
		"CurveKey.IsA",
		"CustomMaterial",
		"CustomMaterial.type",
		"CustomMaterial.SetProperty",
		"CustomMaterial.GetProperty",
		"CustomMaterial.GetPropertyNames",
		"CustomMaterial.GetBaseMaterialId",
		"CustomMaterial.IsA",
		"Damage",
		"Damage.amount",
		"Damage.reason",
		"Damage.sourceAbility",
		"Damage.sourcePlayer",
		"Damage.type",
		"Damage.GetHitResult",
		"Damage.SetHitResult",
		"Damage.IsA",
		"DamageableObject",
		"DamageableObject.hitPoints",
		"DamageableObject.maxHitPoints",
		"DamageableObject.isDead",
		"DamageableObject.isImmortal",
		"DamageableObject.isInvulnerable",
		"DamageableObject.destroyOnDeath",
		"DamageableObject.destroyOnDeathDelay",
		"DamageableObject.destroyOnDeathClientTemplateId",
		"DamageableObject.destroyOnDeathNetworkedTemplateId",
		"DamageableObject.type",
		"DamageableObject.ApplyDamage",
		"DamageableObject.Die",
		"DamageableObject.IsA",
		"DateTime",
		"DateTime.year",
		"DateTime.month",
		"DateTime.day",
		"DateTime.hour",
		"DateTime.minute",
		"DateTime.second",
		"DateTime.millisecond",
		"DateTime.isLocal",
		"DateTime.secondsSinceEpoch",
		"DateTime.millisecondsSinceEpoch",
		"DateTime.type",
		"DateTime.ToLocalTime",
		"DateTime.ToUtcTime",
		"DateTime.ToIsoString",
		"DateTime.IsA",
		"Decal",
		"Decal.type",
		"Decal.IsA",
		"Equipment",
		"Equipment.owner",
		"Equipment.socket",
		"Equipment.type",
		"Equipment.GetAbilities",
		"Equipment.Equip",
		"Equipment.Unequip",
		"Equipment.AddAbility",
		"Equipment.IsA",
		"Event",
		"Event.type",
		"Event.Connect",
		"Event.IsA",
		"EventListener",
		"EventListener.isConnected",
		"EventListener.type",
		"EventListener.Disconnect",
		"EventListener.IsA",
		"Folder",
		"Folder.type",
		"Folder.IsA",
		"FourWheeledVehicle",
		"FourWheeledVehicle.turnRadius",
		"FourWheeledVehicle.type",
		"FourWheeledVehicle.IsA",
		"HitResult",
		"HitResult.other",
		"HitResult.socketName",
		"HitResult.type",
		"HitResult.GetImpactPosition",
		"HitResult.GetImpactNormal",
		"HitResult.GetTransform",
		"HitResult.IsA",
		"Hook",
		"Hook.type",
		"Hook.Connect",
		"Hook.IsA",
		"HookListener",
		"HookListener.isConnected",
		"HookListener.priority",
		"HookListener.type",
		"HookListener.Disconnect",
		"HookListener.IsA",
		"IKAnchor",
		"IKAnchor.target",
		"IKAnchor.anchorType",
		"IKAnchor.blendInTime",
		"IKAnchor.blendOutTime",
		"IKAnchor.weight",
		"IKAnchor.type",
		"IKAnchor.Activate",
		"IKAnchor.Deactivate",
		"IKAnchor.GetAimOffset",
		"IKAnchor.SetAimOffset",
		"IKAnchor.IsA",
		"ImpactData",
		"ImpactData.targetObject",
		"ImpactData.projectile",
		"ImpactData.sourceAbility",
		"ImpactData.weapon",
		"ImpactData.weaponOwner",
		"ImpactData.isHeadshot",
		"ImpactData.travelDistance",
		"ImpactData.type",
		"ImpactData.GetHitResult",
		"ImpactData.GetHitResults",
		"ImpactData.IsA",
		"LeaderboardEntry",
		"LeaderboardEntry.id",
		"LeaderboardEntry.name",
		"LeaderboardEntry.score",
		"LeaderboardEntry.additionalData",
		"LeaderboardEntry.type",
		"LeaderboardEntry.IsA",
		"Light",
		"Light.intensity",
		"Light.attenuationRadius",
		"Light.isShadowCaster",
		"Light.hasTemperature",
		"Light.temperature",
		"Light.team",
		"Light.isTeamColorUsed",
		"Light.type",
		"Light.GetColor",
		"Light.SetColor",
		"Light.IsA",
		"MaterialSlot",
		"MaterialSlot.slotName",
		"MaterialSlot.mesh",
		"MaterialSlot.materialAssetName",
		"MaterialSlot.materialAssetId",
		"MaterialSlot.isSmartMaterial",
		"MaterialSlot.type",
		"MaterialSlot.SetUVTiling",
		"MaterialSlot.GetUVTiling",
		"MaterialSlot.SetColor",
		"MaterialSlot.GetColor",
		"MaterialSlot.ResetColor",
		"MaterialSlot.ResetUVTiling",
		"MaterialSlot.ResetIsSmartMaterial",
		"MaterialSlot.ResetMaterialAssetId",
		"MaterialSlot.GetCustomMaterial",
		"MaterialSlot.IsA",
		"MergedModel",
		"MergedModel.type",
		"MergedModel.IsA",
		"NetReference",
		"NetReference.isAssigned",
		"NetReference.referenceType",
		"NetReference.type",
		"NetReference.IsA",
		"NetworkContext",
		"NetworkContext.type",
		"NetworkContext.IsA",
		"Object",
		"Object.serverUserData",
		"Object.clientUserData",
		"Object.type",
		"Object.IsA",
		"PartyInfo",
		"PartyInfo.id",
		"PartyInfo.name",
		"PartyInfo.partySize",
		"PartyInfo.maxPartySize",
		"PartyInfo.partyLeaderId",
		"PartyInfo.isPlayAsParty",
		"PartyInfo.isPublic",
		"PartyInfo.type",
		"PartyInfo.GetTags",
		"PartyInfo.GetMemberIds",
		"PartyInfo.IsFull",
		"PartyInfo.IsA",
		"PhysicsObject",
		"PhysicsObject.team",
		"PhysicsObject.isTeamCollisionEnabled",
		"PhysicsObject.isEnemyCollisionEnabled",
		"PhysicsObject.hitPoints",
		"PhysicsObject.maxHitPoints",
		"PhysicsObject.isDead",
		"PhysicsObject.isImmortal",
		"PhysicsObject.isInvulnerable",
		"PhysicsObject.destroyOnDeath",
		"PhysicsObject.destroyOnDeathDelay",
		"PhysicsObject.destroyOnDeathClientTemplateId",
		"PhysicsObject.destroyOnDeathNetworkedTemplateId",
		"PhysicsObject.type",
		"PhysicsObject.ApplyDamage",
		"PhysicsObject.Die",
		"PhysicsObject.IsA",
		"Player",
		"Player.id",
		"Player.name",
		"Player.team",
		"Player.isInParty",
		"Player.isPartyLeader",
		"Player.hitPoints",
		"Player.maxHitPoints",
		"Player.kills",
		"Player.deaths",
		"Player.isSpawned",
		"Player.isDead",
		"Player.mass",
		"Player.isAccelerating",
		"Player.isCrouching",
		"Player.isFlying",
		"Player.isGrounded",
		"Player.isJumping",
		"Player.isMounted",
		"Player.isSwimming",
		"Player.isWalking",
		"Player.isSliding",
		"Player.maxWalkSpeed",
		"Player.stepHeight",
		"Player.maxAcceleration",
		"Player.brakingDecelerationFalling",
		"Player.brakingDecelerationWalking",
		"Player.brakingDecelerationFlying",
		"Player.groundFriction",
		"Player.brakingFrictionFactor",
		"Player.walkableFloorAngle",
		"Player.lookSensitivity",
		"Player.animationStance",
		"Player.activeEmote",
		"Player.currentFacingMode",
		"Player.desiredFacingMode",
		"Player.maxJumpCount",
		"Player.flipOnMultiJump",
		"Player.shouldFlipOnMultiJump",
		"Player.jumpVelocity",
		"Player.gravityScale",
		"Player.maxSwimSpeed",
		"Player.maxFlySpeed",
		"Player.touchForceFactor",
		"Player.isCrouchEnabled",
		"Player.buoyancy",
		"Player.isVisible",
		"Player.isVisibleToSelf",
		"Player.spreadModifier",
		"Player.currentSpread",
		"Player.canMount",
		"Player.shouldDismountWhenDamaged",
		"Player.movementControlMode",
		"Player.lookControlMode",
		"Player.isMovementEnabled",
		"Player.isCollidable",
		"Player.parentCoreObject",
		"Player.spawnMode",
		"Player.respawnMode",
		"Player.respawnDelay",
		"Player.respawnTimeRemaining",
		"Player.occupiedVehicle",
		"Player.currentRotationRate",
		"Player.defaultRotationRate",
		"Player.type",
		"Player.GetPartyInfo",
		"Player.IsInPartyWith",
		"Player.GetWorldTransform",
		"Player.SetWorldTransform",
		"Player.GetWorldPosition",
		"Player.SetWorldPosition",
		"Player.GetWorldRotation",
		"Player.SetWorldRotation",
		"Player.GetWorldScale",
		"Player.SetWorldScale",
		"Player.GetVelocity",
		"Player.GetAbilities",
		"Player.GetEquipment",
		"Player.GetAttachedObjects",
		"Player.GetIKAnchors",
		"Player.AddImpulse",
		"Player.SetVelocity",
		"Player.ResetVelocity",
		"Player.ApplyDamage",
		"Player.EnableRagdoll",
		"Player.DisableRagdoll",
		"Player.SetVisibility",
		"Player.GetVisibility",
		"Player.GetViewWorldPosition",
		"Player.GetViewWorldRotation",
		"Player.Die",
		"Player.Spawn",
		"Player.Respawn",
		"Player.Despawn",
		"Player.ClearResources",
		"Player.GetResources",
		"Player.GetResource",
		"Player.SetResource",
		"Player.AddResource",
		"Player.RemoveResource",
		"Player.GetResourceNames",
		"Player.GetResourceNamesStartingWith",
		"Player.TransferToGame",
		"Player.TransferToScene",
		"Player.HasPerk",
		"Player.GetPerkCount",
		"Player.GetPerkTimeRemaining",
		"Player.GrantRewardPoints",
		"Player.ActivateFlying",
		"Player.ActivateWalking",
		"Player.SetMounted",
		"Player.GetActiveCamera",
		"Player.GetDefaultCamera",
		"Player.SetDefaultCamera",
		"Player.GetOverrideCamera",
		"Player.SetOverrideCamera",
		"Player.ClearOverrideCamera",
		"Player.GetLookWorldRotation",
		"Player.SetLookWorldRotation",
		"Player.IsBindingPressed",
		"Player.AttachToCoreObject",
		"Player.Detach",
		"Player.GetJoinTransferData",
		"Player.GetLeaveTransferData",
		"Player.SetPrivateNetworkedData",
		"Player.GetPrivateNetworkedData",
		"Player.GetPrivateNetworkedDataKeys",
		"Player.IsA",
		"PlayerSettings",
		"PlayerSettings.type",
		"PlayerSettings.ApplyToPlayer",
		"PlayerSettings.IsA",
		"PlayerStart",
		"PlayerStart.team",
		"PlayerStart.playerScaleMultiplier",
		"PlayerStart.spawnTemplateId",
		"PlayerStart.key",
		"PlayerStart.shouldDecrowdPlayers",
		"PlayerStart.type",
		"PlayerStart.IsA",
		"PlayerTransferData",
		"PlayerTransferData.reason",
		"PlayerTransferData.gameId",
		"PlayerTransferData.sceneId",
		"PlayerTransferData.sceneName",
		"PlayerTransferData.type",
		"PlayerTransferData.IsA",
		"PointLight",
		"PointLight.hasNaturalFalloff",
		"PointLight.falloffExponent",
		"PointLight.sourceRadius",
		"PointLight.sourceLength",
		"PointLight.type",
		"PointLight.IsA",
		"Projectile",
		"Projectile.sourceAbility",
		"Projectile.shouldBounceOnPlayers",
		"Projectile.shouldDieOnImpact",
		"Projectile.owner",
		"Projectile.speed",
		"Projectile.maxSpeed",
		"Projectile.gravityScale",
		"Projectile.drag",
		"Projectile.bouncesRemaining",
		"Projectile.bounciness",
		"Projectile.piercesRemaining",
		"Projectile.lifeSpan",
		"Projectile.capsuleRadius",
		"Projectile.capsuleLength",
		"Projectile.homingTarget",
		"Projectile.homingAcceleration",
		"Projectile.type",
		"Projectile.GetWorldTransform",
		"Projectile.GetWorldPosition",
		"Projectile.SetWorldPosition",
		"Projectile.GetVelocity",
		"Projectile.SetVelocity",
		"Projectile.Destroy",
		"Projectile.IsA",
		"Quaternion",
		"Quaternion.x",
		"Quaternion.y",
		"Quaternion.z",
		"Quaternion.w",
		"Quaternion.type",
		"Quaternion.GetRotation",
		"Quaternion.GetForwardVector",
		"Quaternion.GetRightVector",
		"Quaternion.GetUpVector",
		"Quaternion.IsA",
		"RandomStream",
		"RandomStream.seed",
		"RandomStream.type",
		"RandomStream.GetInitialSeed",
		"RandomStream.Reset",
		"RandomStream.Mutate",
		"RandomStream.GetNumber",
		"RandomStream.GetInteger",
		"RandomStream.GetVector3",
		"RandomStream.GetVector3FromCone",
		"RandomStream.IsA",
		"Rotation",
		"Rotation.x",
		"Rotation.y",
		"Rotation.z",
		"Rotation.type",
		"Rotation.IsA",
		"Script",
		"Script.context",
		"Script.scriptAssetId",
		"Script.type",
		"Script.IsA",
		"ScriptAsset",
		"ScriptAsset.name",
		"ScriptAsset.id",
		"ScriptAsset.type",
		"ScriptAsset.GetCustomProperties",
		"ScriptAsset.GetCustomProperty",
		"ScriptAsset.IsA",
		"SimpleCurve",
		"SimpleCurve.preExtrapolation",
		"SimpleCurve.postExtrapolation",
		"SimpleCurve.defaultValue",
		"SimpleCurve.minTime",
		"SimpleCurve.maxTime",
		"SimpleCurve.minValue",
		"SimpleCurve.maxValue",
		"SimpleCurve.type",
		"SimpleCurve.GetValue",
		"SimpleCurve.GetSlope",
		"SimpleCurve.IsA",
		"SmartAudio",
		"SmartAudio.isSpatializationEnabled",
		"SmartAudio.isAttenuationEnabled",
		"SmartAudio.isOcclusionEnabled",
		"SmartAudio.fadeInTime",
		"SmartAudio.fadeOutTime",
		"SmartAudio.startTime",
		"SmartAudio.stopTime",
		"SmartAudio.isAutoPlayEnabled",
		"SmartAudio.isTransient",
		"SmartAudio.isAutoRepeatEnabled",
		"SmartAudio.pitch",
		"SmartAudio.volume",
		"SmartAudio.radius",
		"SmartAudio.falloff",
		"SmartAudio.isPlaying",
		"SmartAudio.type",
		"SmartAudio.Play",
		"SmartAudio.Stop",
		"SmartAudio.FadeIn",
		"SmartAudio.FadeOut",
		"SmartAudio.IsA",
		"SmartObject",
		"SmartObject.team",
		"SmartObject.isTeamColorUsed",
		"SmartObject.type",
		"SmartObject.GetSmartProperties",
		"SmartObject.GetSmartProperty",
		"SmartObject.SetSmartProperty",
		"SmartObject.IsA",
		"SpotLight",
		"SpotLight.hasNaturalFalloff",
		"SpotLight.falloffExponent",
		"SpotLight.sourceRadius",
		"SpotLight.sourceLength",
		"SpotLight.innerConeAngle",
		"SpotLight.outerConeAngle",
		"SpotLight.type",
		"SpotLight.IsA",
		"StaticMesh",
		"StaticMesh.isSimulatingDebrisPhysics",
		"StaticMesh.type",
		"StaticMesh.SetMaterialForSlot",
		"StaticMesh.GetMaterialSlot",
		"StaticMesh.GetMaterialSlots",
		"StaticMesh.ResetMaterialSlot",
		"StaticMesh.IsA",
		"Task",
		"Task.repeatInterval",
		"Task.repeatCount",
		"Task.id",
		"Task.type",
		"Task.Cancel",
		"Task.GetStatus",
		"Task.IsA",
		"Terrain",
		"Terrain.type",
		"Terrain.IsA",
		"Transform",
		"Transform.type",
		"Transform.GetRotation",
		"Transform.SetRotation",
		"Transform.GetPosition",
		"Transform.SetPosition",
		"Transform.GetScale",
		"Transform.SetScale",
		"Transform.GetQuaternion",
		"Transform.SetQuaternion",
		"Transform.GetForwardVector",
		"Transform.GetRightVector",
		"Transform.GetUpVector",
		"Transform.GetInverse",
		"Transform.TransformPosition",
		"Transform.TransformDirection",
		"Transform.IsA",
		"TreadedVehicle",
		"TreadedVehicle.turnSpeed",
		"TreadedVehicle.type",
		"TreadedVehicle.IsA",
		"Trigger",
		"Trigger.isInteractable",
		"Trigger.interactionLabel",
		"Trigger.team",
		"Trigger.isTeamCollisionEnabled",
		"Trigger.isEnemyCollisionEnabled",
		"Trigger.type",
		"Trigger.IsOverlapping",
		"Trigger.GetOverlappingObjects",
		"Trigger.IsA",
		"UIButton",
		"UIButton.text",
		"UIButton.fontSize",
		"UIButton.isInteractable",
		"UIButton.shouldClipToSize",
		"UIButton.shouldScaleToFit",
		"UIButton.type",
		"UIButton.SetImage",
		"UIButton.GetButtonColor",
		"UIButton.SetButtonColor",
		"UIButton.GetHoveredColor",
		"UIButton.SetHoveredColor",
		"UIButton.GetPressedColor",
		"UIButton.SetPressedColor",
		"UIButton.GetDisabledColor",
		"UIButton.SetDisabledColor",
		"UIButton.GetFontColor",
		"UIButton.SetFontColor",
		"UIButton.SetFont",
		"UIButton.GetShadowColor",
		"UIButton.SetShadowColor",
		"UIButton.GetShadowOffset",
		"UIButton.SetShadowOffset",
		"UIButton.IsA",
		"UIContainer",
		"UIContainer.opacity",
		"UIContainer.cylinderArcAngle",
		"UIContainer.type",
		"UIContainer.GetCanvasSize",
		"UIContainer.SetCanvasSize",
		"UIContainer.IsA",
		"UIControl",
		"UIControl.x",
		"UIControl.y",
		"UIControl.width",
		"UIControl.height",
		"UIControl.rotationAngle",
		"UIControl.anchor",
		"UIControl.dock",
		"UIControl.type",
		"UIControl.IsA",
		"UIEventRSVPButton",
		"UIEventRSVPButton.isInteractable",
		"UIEventRSVPButton.eventId",
		"UIEventRSVPButton.type",
		"UIEventRSVPButton.IsA",
		"UIImage",
		"UIImage.isTeamColorUsed",
		"UIImage.team",
		"UIImage.shouldClipToSize",
		"UIImage.isFlippedHorizontal",
		"UIImage.isFlippedVertical",
		"UIImage.type",
		"UIImage.GetColor",
		"UIImage.SetColor",
		"UIImage.SetImage",
		"UIImage.SetPlayerProfile",
		"UIImage.SetGameScreenshot",
		"UIImage.SetGameEvent",
		"UIImage.GetImage",
		"UIImage.GetShadowColor",
		"UIImage.SetShadowColor",
		"UIImage.GetShadowOffset",
		"UIImage.SetShadowOffset",
		"UIImage.SetCameraCapture",
		"UIImage.IsA",
		"UIPanel",
		"UIPanel.shouldClipChildren",
		"UIPanel.opacity",
		"UIPanel.type",
		"UIPanel.IsA",
		"UIPerkPurchaseButton",
		"UIPerkPurchaseButton.isInteractable",
		"UIPerkPurchaseButton.type",
		"UIPerkPurchaseButton.SetPerkReference",
		"UIPerkPurchaseButton.GetPerkReference",
		"UIPerkPurchaseButton.IsA",
		"UIProgressBar",
		"UIProgressBar.progress",
		"UIProgressBar.fillType",
		"UIProgressBar.fillTileType",
		"UIProgressBar.backgroundTileType",
		"UIProgressBar.type",
		"UIProgressBar.SetFillImage",
		"UIProgressBar.GetFillImage",
		"UIProgressBar.SetBackgroundImage",
		"UIProgressBar.GetBackgroundImage",
		"UIProgressBar.GetFillColor",
		"UIProgressBar.SetFillColor",
		"UIProgressBar.GetBackgroundColor",
		"UIProgressBar.SetBackgroundColor",
		"UIProgressBar.IsA",
		"UIRewardPointsMeter",
		"UIRewardPointsMeter.type",
		"UIRewardPointsMeter.IsA",
		"UIScrollPanel",
		"UIScrollPanel.orientation",
		"UIScrollPanel.scrollPosition",
		"UIScrollPanel.contentLength",
		"UIScrollPanel.type",
		"UIScrollPanel.IsA",
		"UIText",
		"UIText.text",
		"UIText.fontSize",
		"UIText.outlineSize",
		"UIText.justification",
		"UIText.shouldWrapText",
		"UIText.shouldClipText",
		"UIText.shouldScaleToFit",
		"UIText.type",
		"UIText.GetColor",
		"UIText.SetColor",
		"UIText.ComputeApproximateSize",
		"UIText.SetFont",
		"UIText.GetShadowColor",
		"UIText.SetShadowColor",
		"UIText.GetShadowOffset",
		"UIText.SetShadowOffset",
		"UIText.GetOutlineColor",
		"UIText.SetOutlineColor",
		"UIText.IsA",
		"Vector2",
		"Vector2.x",
		"Vector2.y",
		"Vector2.size",
		"Vector2.sizeSquared",
		"Vector2.type",
		"Vector2.GetNormalized",
		"Vector2.IsA",
		"Vector3",
		"Vector3.x",
		"Vector3.y",
		"Vector3.z",
		"Vector3.size",
		"Vector3.sizeSquared",
		"Vector3.type",
		"Vector3.GetNormalized",
		"Vector3.IsA",
		"Vector4",
		"Vector4.x",
		"Vector4.y",
		"Vector4.z",
		"Vector4.w",
		"Vector4.size",
		"Vector4.sizeSquared",
		"Vector4.type",
		"Vector4.GetNormalized",
		"Vector4.IsA",
		"Vehicle",
		"Vehicle.isAccelerating",
		"Vehicle.driver",
		"Vehicle.mass",
		"Vehicle.maxSpeed",
		"Vehicle.accelerationRate",
		"Vehicle.brakeStrength",
		"Vehicle.coastBrakeStrength",
		"Vehicle.tireFriction",
		"Vehicle.gravityScale",
		"Vehicle.isDriverHidden",
		"Vehicle.isDriverAttached",
		"Vehicle.isBrakeEngaged",
		"Vehicle.isHandbrakeEngaged",
		"Vehicle.driverAnimationStance",
		"Vehicle.enterTrigger",
		"Vehicle.camera",
		"Vehicle.hitPoints",
		"Vehicle.maxHitPoints",
		"Vehicle.isDead",
		"Vehicle.isImmortal",
		"Vehicle.isInvulnerable",
		"Vehicle.destroyOnDeath",
		"Vehicle.destroyOnDeathDelay",
		"Vehicle.destroyOnDeathClientTemplateId",
		"Vehicle.destroyOnDeathNetworkedTemplateId",
		"Vehicle.type",
		"Vehicle.GetPhysicsBodyOffset",
		"Vehicle.GetPhysicsBodyScale",
		"Vehicle.SetDriver",
		"Vehicle.RemoveDriver",
		"Vehicle.AddImpulse",
		"Vehicle.GetDriverPosition",
		"Vehicle.GetDriverRotation",
		"Vehicle.GetCenterOfMassOffset",
		"Vehicle.SetCenterOfMassOffset",
		"Vehicle.ApplyDamage",
		"Vehicle.Die",
		"Vehicle.IsA",
		"Vfx",
		"Vfx.type",
		"Vfx.Play",
		"Vfx.Stop",
		"Vfx.IsA",
		"VoiceChatChannel",
		"VoiceChatChannel.name",
		"VoiceChatChannel.channelType",
		"VoiceChatChannel.type",
		"VoiceChatChannel.GetPlayers",
		"VoiceChatChannel.IsPlayerInChannel",
		"VoiceChatChannel.IsPlayerMuted",
		"VoiceChatChannel.MutePlayer",
		"VoiceChatChannel.UnmutePlayer",
		"VoiceChatChannel.IsA",
		"Weapon",
		"Weapon.attackCooldownDuration",
		"Weapon.animationStance",
		"Weapon.multiShotCount",
		"Weapon.burstCount",
		"Weapon.shotsPerSecond",
		"Weapon.shouldBurstStopOnRelease",
		"Weapon.isHitscan",
		"Weapon.range",
		"Weapon.damage",
		"Weapon.directDamage",
		"Weapon.projectileTemplateId",
		"Weapon.muzzleFlashTemplateId",
		"Weapon.trailTemplateId",
		"Weapon.beamTemplateId",
		"Weapon.impactSurfaceTemplateId",
		"Weapon.impactProjectileTemplateId",
		"Weapon.impactPlayerTemplateId",
		"Weapon.projectileSpeed",
		"Weapon.projectileLifeSpan",
		"Weapon.projectileGravity",
		"Weapon.projectileLength",
		"Weapon.projectileRadius",
		"Weapon.projectileDrag",
		"Weapon.projectileBounceCount",
		"Weapon.projectilePierceCount",
		"Weapon.maxAmmo",
		"Weapon.currentAmmo",
		"Weapon.ammoType",
		"Weapon.isAmmoFinite",
		"Weapon.outOfAmmoSoundId",
		"Weapon.reloadSoundId",
		"Weapon.spreadMin",
		"Weapon.spreadMax",
		"Weapon.spreadAperture",
		"Weapon.spreadDecreaseSpeed",
		"Weapon.spreadIncreasePerShot",
		"Weapon.spreadPenaltyPerShot",
		"Weapon.type",
		"Weapon.HasAmmo",
		"Weapon.Attack",
		"Weapon.IsA",
		"WorldText",
		"WorldText.text",
		"WorldText.type",
		"WorldText.GetColor",
		"WorldText.SetColor",
		"WorldText.SetFont",
		"WorldText.IsA",
		-- Namespaces
		"Chat",
		"CoreDebug",
		"CoreMath",
		"CorePlatform",
		"CoreSocial",
		"CoreString",
		"Environment",
		"Events",
		"Game",
		"Input",
		"Leaderboards",
		"Storage",
		"Teams",
		"UI",
		"VoiceChat",
		"World",
		-- Enums
		"AbilityFacingMode",
		"AbilityFacingMode.NONE",
		"AbilityFacingMode.MOVEMENT",
		"AbilityFacingMode.AIM",
		"AbilityPhase",
		"AbilityPhase.READY",
		"AbilityPhase.CAST",
		"AbilityPhase.EXECUTE",
		"AbilityPhase.RECOVERY",
		"AbilityPhase.COOLDOWN",
		"BroadcastEventResultCode",
		"BroadcastEventResultCode.SUCCESS",
		"BroadcastEventResultCode.FAILURE",
		"BroadcastEventResultCode.EXCEEDED_SIZE_LIMIT",
		"BroadcastEventResultCode.EXCEEDED_RATE_WARNING_LIMIT",
		"BroadcastEventResultCode.EXCEEDED_RATE_LIMIT",
		"BroadcastMessageResultCode",
		"BroadcastMessageResultCode.SUCCESS",
		"BroadcastMessageResultCode.FAILURE",
		"BroadcastMessageResultCode.EXCEEDED_SIZE_LIMIT",
		"BroadcastMessageResultCode.EXCEEDED_RATE_WARNING_LIMIT",
		"BroadcastMessageResultCode.EXCEEDED_RATE_LIMIT",
		"CameraCaptureResolution",
		"CameraCaptureResolution.VERY_SMALL",
		"CameraCaptureResolution.SMALL",
		"CameraCaptureResolution.MEDIUM",
		"CameraCaptureResolution.LARGE",
		"CameraCaptureResolution.VERY_LARGE",
		"Collision",
		"Collision.INHERIT",
		"Collision.FORCE_ON",
		"Collision.FORCE_OFF",
		"CoreGameEventState",
		"CoreGameEventState.ACTIVE",
		"CoreGameEventState.SCHEDULED",
		"CoreGameEventState.CANCELED",
		"CoreModalType",
		"CoreModalType.PAUSE_MENU",
		"CoreModalType.CHARACTER_PICKER",
		"CoreModalType.MOUNT_PICKER",
		"CoreModalType.EMOTE_PICKER",
		"CoreModalType.SOCIAL_MENU",
		"CurveExtrapolation",
		"CurveExtrapolation.CYCLE",
		"CurveExtrapolation.CYCLE_WITH_OFFSET",
		"CurveExtrapolation.OSCILLATE",
		"CurveExtrapolation.LINEAR",
		"CurveExtrapolation.CONSTANT",
		"CurveInterpolation",
		"CurveInterpolation.LINEAR",
		"CurveInterpolation.CONSTANT",
		"CurveInterpolation.CUBIC",
		"DamageReason",
		"DamageReason.UNKNOWN",
		"DamageReason.COMBAT",
		"DamageReason.FRIENDLY_FIRE",
		"DamageReason.MAP",
		"DamageReason.NPC",
		"FacingMode",
		"FacingMode.FACE_AIM_WHEN_ACTIVE",
		"FacingMode.FACE_AIM_ALWAYS",
		"FacingMode.FACE_MOVEMENT",
		"IKAnchorType",
		"IKAnchorType.LEFT_HAND",
		"IKAnchorType.RIGHT_HAND",
		"IKAnchorType.PELVIS",
		"IKAnchorType.LEFT_FOOT",
		"IKAnchorType.RIGHT_FOOT",
		"ImageTileType",
		"ImageTileType.NONE",
		"ImageTileType.HORIZONTAL",
		"ImageTileType.VERTICAL",
		"ImageTileType.BOTH",
		"InputType",
		"InputType.KEYBOARD_AND_MOUSE",
		"InputType.CONTROLLER",
		"LeaderboardType",
		"LeaderboardType.GLOBAL",
		"LeaderboardType.DAILY",
		"LeaderboardType.WEEKLY",
		"LeaderboardType.MONTHLY",
		"LookControlMode",
		"LookControlMode.NONE",
		"LookControlMode.RELATIVE",
		"LookControlMode.LOOK_AT_CURSOR",
		"MovementControlMode",
		"MovementControlMode.NONE",
		"MovementControlMode.LOOK_RELATIVE",
		"MovementControlMode.VIEW_RELATIVE",
		"MovementControlMode.FACING_RELATIVE",
		"MovementControlMode.FIXED_AXES",
		"MovementMode",
		"MovementMode.NONE",
		"MovementMode.WALKING",
		"MovementMode.FALLING",
		"MovementMode.SWIMMING",
		"MovementMode.FLYING",
		"MovementMode.SLIDING",
		"NetReferenceType",
		"NetReferenceType.LEADERBOARD",
		"NetReferenceType.SHARED_STORAGE",
		"NetReferenceType.CREATOR_PERK",
		"NetReferenceType.UNKNOWN",
		"NetworkContextType",
		"NetworkContextType.NETWORKED",
		"NetworkContextType.CLIENT_CONTEXT",
		"NetworkContextType.SERVER_CONTEXT",
		"NetworkContextType.STATIC_CONTEXT",
		"Orientation",
		"Orientation.HORIZONTAL",
		"Orientation.VERTICAL",
		"PlayerTransferReason",
		"PlayerTransferReason.UNKNOWN",
		"PlayerTransferReason.CHARACTER",
		"PlayerTransferReason.CREATE",
		"PlayerTransferReason.SHOP",
		"PlayerTransferReason.BROWSE",
		"PlayerTransferReason.SOCIAL",
		"PlayerTransferReason.PORTAL",
		"PlayerTransferReason.AFK",
		"PlayerTransferReason.EXIT",
		"PlayerTransferReason.PORTAL_SCENE",
		"PrivateNetworkedDataResultCode",
		"PrivateNetworkedDataResultCode.SUCCESS",
		"PrivateNetworkedDataResultCode.FAILURE",
		"PrivateNetworkedDataResultCode.EXCEEDED_SIZE_LIMIT",
		"ProgressBarFillType",
		"ProgressBarFillType.LEFT_TO_RIGHT",
		"ProgressBarFillType.RIGHT_TO_LEFT",
		"ProgressBarFillType.TOP_TO_BOTTOM",
		"ProgressBarFillType.BOTTOM_TO_TOP",
		"ProgressBarFillType.FROM_CENTER",
		"RespawnMode",
		"RespawnMode.NONE",
		"RespawnMode.IN_PLACE",
		"RespawnMode.ROUND_ROBIN",
		"RespawnMode.AT_CLOSEST_SPAWN_POINT",
		"RespawnMode.FARTHEST_FROM_OTHER_PLAYERS",
		"RespawnMode.FARTHEST_FROM_ENEMY",
		"RespawnMode.RANDOM",
		"RewardsDialogTab",
		"RewardsDialogTab.QUESTS",
		"RewardsDialogTab.GAMES",
		"RotationMode",
		"RotationMode.CAMERA",
		"RotationMode.NONE",
		"RotationMode.LOOK_ANGLE",
		"SpawnMode",
		"SpawnMode.RANDOM",
		"SpawnMode.ROUND_ROBIN",
		"SpawnMode.FARTHEST_FROM_OTHER_PLAYERS",
		"SpawnMode.FARTHEST_FROM_ENEMY",
		"StorageResultCode",
		"StorageResultCode.SUCCESS",
		"StorageResultCode.FAILURE",
		"StorageResultCode.STORAGE_DISABLED",
		"StorageResultCode.EXCEEDED_SIZE_LIMIT",
		"TaskStatus",
		"TaskStatus.UNINITIALIZED",
		"TaskStatus.SCHEDULED",
		"TaskStatus.RUNNING",
		"TaskStatus.COMPLETED",
		"TaskStatus.YIELDED",
		"TaskStatus.FAILED",
		"TaskStatus.CANCELED",
		"TaskStatus.BLOCKED",
		"TextJustify",
		"TextJustify.LEFT",
		"TextJustify.CENTER",
		"TextJustify.RIGHT",
		"UIPivot",
		"UIPivot.TOP_LEFT",
		"UIPivot.TOP_CENTER",
		"UIPivot.TOP_RIGHT",
		"UIPivot.MIDDLE_LEFT",
		"UIPivot.MIDDLE_CENTER",
		"UIPivot.MIDDLE_RIGHT",
		"UIPivot.BOTTOM_LEFT",
		"UIPivot.BOTTOM_CENTER",
		"UIPivot.BOTTOM_RIGHT",
		"UIPivot.CUSTOM",
		"Visibility",
		"Visibility.INHERIT",
		"Visibility.FORCE_ON",
		"Visibility.FORCE_OFF",
		"VoiceChannelType",
		"VoiceChannelType.NORMAL",
		"VoiceChannelType.POSITIONAL",
		"VoiceChatMode",
		"VoiceChatMode.NONE",
		"VoiceChatMode.TEAM",
		"VoiceChatMode.ALL",
		-- Global Functions
		"warn",
		"Tick",
		"time",
	},
}

std = "lua53+core"
max_line_length = false

-- for "setting non-standard global variable" for local functions
allow_defined = true

exclude_files = {
	".luacheckrc",
}

ignore = {
	"211", -- Unused local variable
	"212", -- Unused argument
	"213", -- Unused loop variable
	-- "231", -- Set but never accessed
	"311", -- Value assigned to a local variable is unused
	"314", -- Value of a field in a table literal is unused
	"42.", -- Shadowing a local variable, an argument, a loop variable.
	"43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
	"542", -- An empty if branch
	"6.", -- Whitespace
	"131/.*Tick", -- Allow unused `Tick`
	"131", -- Unused implicitly defined global variable. Luacheck does not understand how our require works.
}

globals = {
	"_G",
	"script",
}
