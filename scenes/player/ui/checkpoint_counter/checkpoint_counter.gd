extends PanelContainer


func set_validated_checkpoint(validated_checkpoint: int) -> void:
  %Validated.text = str(validated_checkpoint)


func set_total_checkpoint(total_checkpoint: int) -> void:
  %Total.text = str(total_checkpoint)
