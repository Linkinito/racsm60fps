# SCHEMA_V2.md

The task file is authoritative. These are recommended canonical columns.

## master_inventory.csv

inventory_id,canonical_name,original_corpus_id,module_instances,implementation_group_ids,object_type,terminal_status,timing_mechanism_count,A0_status,B0_prediction,B1_prediction,C1_prediction,C1_verdict,candidate_patch_count,priority,evidence_state,confidence,dossier_path,source_path,notes

## timing_mechanisms.csv

mechanism_id,inventory_id,implementation_group_id,class,function,address,module,mechanism_family,gameplay_domain,producer,consumer,relevant_field,constant,A0_model,B0_model,B1_model,C1_model,A0_multiplier,B0_multiplier,B1_multiplier,C1_multiplier,C1_verdict,candidate_ids,priority,evidence_state,confidence,source_kind,source_path,independently_rechecked,scope,evidence,notes

## patch_candidates.csv

candidate_id,mechanism_id,class,module,address,candidate_type,original_instruction,original_opcode,candidate_instruction,candidate_opcode,original_constant,candidate_constant,expected_effect,shared_scope,risk,priority,evidence_state,confidence,status,manual_test_id,source_path,notes

## implementation_groups.csv

implementation_group_id,semantic_name,canonical_module,canonical_address,instance_count,instances,fingerprint_method,evidence_state,confidence,differences,notes

## manual_test_queue.csv

manual_test_id,candidate_id,priority,gameplay_area,setup,A0_reference,C1_expected_bug,candidate_expected_result,side_effects_to_watch,evidence_needed,status,notes

## Role progress JSON

Example:

```json
{
  "role": "mapper",
  "canonical_expected": 534,
  "shard_size": 25,
  "completed_shards": [1,2,3],
  "next_shard": 4,
  "completed_canonical_names": 75,
  "extra_discovered_items": 4,
  "last_updated_utc": "..."
}
```

Never increment completion for an untouched row.
