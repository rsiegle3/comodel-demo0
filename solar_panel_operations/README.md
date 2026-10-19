# Solar Panel Operations

Built from `bird_solar_panel`, database `solar_panel`, schema `public` only.

Grain: one row per `plant_record.snapkey`. The five optional detail tables join by their declared snapshot primary and foreign keys, preserving snapshots with missing detail records. Plant and primary panel model are lookup dimensions. The calendar contains observed dates only.

Measurement aggregation uses observation averages for power, energy readings, efficiency, degradation, costs, environmental conditions and mechanical counts. Source observation intervals and cost currency codes are unspecified; these are not period generation or spending totals. Percent-valued source readings remain on a 0-100 scale. Power Loss Share is a ratio of matched aggregate components and displays as a percent. Average Combined Intervention Cost combines three average components on the same complete-input population. Both calculations expose coverage classifications and support counts.

Inspection is omitted because there is no declared link to plant or snapshot. The plant-panel membership bridge is omitted because it has no allocation weights; primary model analysis follows `plants.modhook`. No sample-observed JSON paths are omitted. Raw JSON remains available in the dataset but is not a BI attribute.

Discovery statistics initially failed with a Redis timeout. All ten tables returned sample rows. Schema-qualified sample names were rejected by the API; separate schema and bare table names succeeded. No comments were supplied by warehouse metadata.
