class_name Patch
extends Area2D

signal patch_collected(patch_type)

enum PatchType {
	DOUBLE_JUMP = 0,
	STUN_ARM = 1,
}

export (PatchType) var patch_type := PatchType.DOUBLE_JUMP


func _on_patch_body_entered(_body: Node) -> void:
	emit_signal('patch_collected', patch_type)
	queue_free()
