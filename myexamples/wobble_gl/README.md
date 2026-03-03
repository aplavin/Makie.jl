# GLMakie Wobble Demo

Standalone environment with local Makie packages dev'd:

- `Makie` from `/Users/aplavin/.julia/dev/Makie/Makie`
- `GLMakie` from `/Users/aplavin/.julia/dev/Makie/GLMakie`

Run:

```bash
julia --project=/Users/aplavin/.julia/dev/Makie/myexamples/wobble_gl /Users/aplavin/.julia/dev/Makie/myexamples/wobble_gl/wobble_demo_glmakie.jl
```

The script opens a GL window and also writes:

- `wobble_demo_glmakie.png`

Wobble controls:

- `wobble`: amplitude as a fraction of line span.
- `wobble_scale`: wobble wavelength in plot units (smaller = tighter/faster oscillations).
- `wobble_seed`: deterministic random phase seed.

Note: Axis/grid internals are `LineSegments` in pixel-space, so they usually need a larger `wobble_scale`
than data-space `Lines`.
