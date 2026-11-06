# Changelog

## Unreleased

### Fixed

- Layout converges when direct jumps' short and long forms depend on each other
  (clef#21). Every same-section `jmp` and `jcc` starts short and grows only
  when its rel8 displacement no longer fits; a grown jump never shrinks.
  Forward targets are estimated as the pinned GNU as estimates them, which was
  read from its output on generated cases. fenrir's nested-loop file, which
  trunk refused with `layout_nonconvergent`, now matches GNU as byte for byte.
  Two adjacent jumps that span each other, which trunk left long, are now
  short as in GNU as.
- The layout pass cap is now 64 plus one per relaxable jump, because growth
  alone ends relaxation. A cascade of 200 jumps that grow one per pass
  assembles.

### Added

- `tools/relaxation-test`, the `relaxation` gate: 1,330 rows byte-identical to
  GNU as, the measured rule's model checked against GNU as's choices, and a pass
  bound on the largest case.
