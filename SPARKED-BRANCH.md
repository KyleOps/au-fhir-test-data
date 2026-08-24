# About this branch

This is not HL7 AU test data. The authoritative set is
[hl7au/au-fhir-test-data](https://github.com/hl7au/au-fhir-test-data); use that
one unless you specifically need what is described below.

`sparked-aucore-loadable` is a Sparked-maintained branch of that repository,
tracking upstream `master` and carrying the smallest patch that lets the
`au-core` folder load onto an AU Core server that does not also carry the AU
eRequesting IG. It exists because the Sparked AU Core server
(smile.sparked-fhir.com/aucore) loads this data with request validation on, and
two upstream defects otherwise block it.

## What differs from upstream

1. **Eight au-core examples had an `au-erequesting-*` entry removed from
   `meta.profile`.** They keep their `au-core-*` profile. The resources belong in
   au-core and are referenced heavily from within it; only the claim is wrong.
   Any server without `hl7.fhir.au.ereq` rejects them with
   `VALIDATION_VAL_PROFILE_UNKNOWN_NOT_POLICY`.

2. **`Patient/roberts-fred` was copied into `au-core`,** unprofiled, because
   `au-core/Encounter-gp-consultation.json` references it while its only
   definition lives in `au-erequesting`. Without it a server loading au-core
   alone auto-creates an empty placeholder patient.

Nothing else is changed. No resource content, no codings, no signatures.

## Maintenance

Rebase on upstream `master` rather than merging, so the patch stays a readable
two commits on top. Both changes are upstream defects: when the equivalent fixes
land in `hl7au/au-fhir-test-data`, drop the corresponding commit, and retire the
branch once both are gone.

Referenced by the `AU Core` dataset in
[sparked-test-data-loader](https://github.com/aehrc/sparked-test-data-loader)
`helm/sparked-test-data-loader/values.yaml`. Changing or deleting this branch
changes what that loader installs.
