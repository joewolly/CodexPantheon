# Codex Pantheon v0.7.0 graphics

The collection uses astronomical space imagery: a blue-white spiral galaxy for Astra, a warm sun for Sol, and three cratered moons for the Luna specialist lanes. Deep-space black, indigo, blue and violet nebulae support flat white modern sans-serif typography. Cyan, violet and amber distinguish the specialist lanes.

## Assets

| File | Purpose |
| --- | --- |
| [Banner](../codex-pantheon-banner.png) | Approved space artwork and repository wordmark |
| [Logo](../codex-pantheon-logo.png) | Transparent galaxy, sun, and three-moon illustration |
| [Illustrated explainer](../pantheon.png) | Primary README overview |
| [Architecture SVG](codex-pantheon-v0.7-architecture.svg) | Editable, accessible technical reference |

Older versioned graphics remain recoverable from Git history. Historical release documentation is retained.

## Content contract

- GPT-6 Astra **or** GPT-5.6 Sol fills one main-thread Orchestrator role, selected using native Codex controls.
- All three specialists use GPT-5.6 Luna High. Explorer and Librarian gather read-only evidence. Fixer implements the Orchestrator's specification and runs assigned validation.
- Evidence when needed → Orchestrator plan → Luna Fixer implementation → Orchestrator review and verification.
- Activation is explicit and thread-scoped. Daily delegates sequentially; Full permits justified parallelism.
- Assignments use minimum sufficient context; `fork_turns: "none"` remains the default.
- No numerical performance, cost, or quota claims.

## Production

Raster images were generated with built-in imagegen and copied into the repository at their original resolution. The approved banner served as the explainer's style reference. The final logo was generated separately with actual alpha transparency. The SVG is authored directly so text and relationships remain editable.

## Final prompts

### Banner

```text
undefined
```

### Logo

```text
Generate a square PNG logo on a transparent background. A compact astronomical illustration of a tilted blue-white spiral galaxy, a small golden sun beside it, and three cratered moons below with cyan, violet and amber rim lighting. Actual deep-space photography aesthetic, beautiful blue and violet spiral arms, luminous center. Isolated subject on transparency. No text, no frame, no ornaments. Simple clean silhouette and generous transparent padding. Please output with genuine alpha transparency.
```

### Explainer

The original poster from commit `c407da9` provided composition and information-hierarchy reference; the preceding space explainer provided the astronomical theme and current role labels. The final artwork also includes a decorative “Same goals. Higher standards.” line and explicitly labels results as occurring after Orchestrator review.

```text
Use case: infographic-diagram
Asset type: spectacular Codex Pantheon v0.7.0 README explainer poster, landscape 3:2, highest practical resolution.
Input images: Image 1 current space explainer supplies accurate roles and SPACE ART THEME. Image 2 original character poster supplies only its dynamic editorial composition, layered visual storytelling, rich explanatory detail, and dramatic scale. Absolutely NO characters or fantasy architecture from Image 2.
Primary request: make a genuinely exciting space explainer with the visual ambition and information richness of the original poster, not a uniform boxed org chart. Astronomy photography meets elegant space-mission editorial design. Sweeping luminous blue-violet galaxy across the upper middle, warm solar corona on the upper right; large textured cyan/violet/amber moons rise out of subtle data panels across the lower middle. Expansive depth, foreground lunar horizon along bottom, natural starfields and nebula, dynamic curved light paths for delegation. White modern sans-serif type, restrained cyan accents, beautifully balanced readable composition.
Top-left large "PANTHEON", small "CODEX • v0.7.0", supporting sentence "Specialized agents. Clear roles. Your mission."
Upper-middle hero: ONE shared Orchestrator area, not a box around each object. A magnificent blue-white spiral galaxy labeled "GPT-6 ASTRA", a warm sun labeled "GPT-5.6 SOL", with very visible "OR" between. Shared title "ORCHESTRATOR" and "One main thread • Selected in Codex". Galaxy and sun should feel like real massive celestial objects embedded in the scene, not tiny icons.
Left floating callout "YOU" with "Describe your goal" and "Stay in control", arrow to Orchestrator.
Right of hero a compact readable responsibility callout: "Understands the goal" / "Plans and architects" / "Delegates to specialists" / "Reviews and verifies".
Three large foreground moons with distinctly different crater texture, cyan Explorer, violet Librarian, amber Fixer. They project out above restrained translucent information panels. Above their shared branching connector: "DELEGATES SPECIALIZED WORK".
Explorer panel exact text: "LUNA EXPLORER" / "Repository reconnaissance" / "Finds and inspects relevant code" / "Traces behavior and dependencies" / "Returns focused evidence" / "READ-ONLY".
Librarian panel: "LUNA LIBRARIAN" / "Research & references" / "Checks documentation and APIs" / "Finds authoritative sources" / "Returns focused evidence" / "READ-ONLY".
Fixer panel: "LUNA FIXER" / "Implementation" / "Receives the scoped specification" / "Makes the code changes" / "Runs assigned validation" / "WORKSPACE-WRITE".
A shared readable caption: "All specialists: GPT-5.6 Luna High".
Right edge small "RESULTS" callout with "Implemented changes" / "Validation evidence" / "Clear explanations". Make clear results follow Orchestrator review, not automatic direct Fixer-to-user delivery.
Bottom explicit handoff strip with arrows: "Evidence when needed" → "Orchestrator plan" → "Fixer implements" → "Orchestrator reviews & verifies".
Below that three concise footer groups:
"ON DEMAND" / "$pantheon or $pantheon-daily"
"TWO PROFILES" / "Daily: sequential • Full: justified parallelism"
"LEAN CONTEXT" / "Minimum sufficient evidence"
Keep copy verbatim and highly legible, no additional slogans. Exact dollar signs. Hierarchy through scale and space, not thick boxes. Give large celestial imagery room to breathe. No characters, humans, armor, temples, pillars, metallic emblems, shields, serif type, holographic people, game UI or tiny unreadable labels. No quantitative claims or numeric call ceilings. One Orchestrator role with two alternative models, exactly three specialist moons.
```

## Maintenance

Keep the artwork space-focused: galaxies, suns, moons, starfields, subtle nebulae, and modern typography. Preserve the explicit **OR** between Astra and Sol and the three named specialist lanes. Check rendered text, actual logo alpha, image references, and SVG text bounds after revisions.
