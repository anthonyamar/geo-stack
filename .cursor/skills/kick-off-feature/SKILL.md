---
name: kick-off-feature
description: Kick off a new feature from an initial prompt or Linear context, converge on a shared plan, publish a PRD as a Linear Project, then break it into executable issues.
---

# Kick-off Feature

This skill defines the **end-to-end workflow** to start a new feature: from an initial idea → shared plan → PRD “contract” → Linear Project → tracer-bullet issues ready for execution.

## Preconditions

- **Linear is the source of truth** for PM. You MUST use the **Linear MCP** to read/create/update Projects and Issues.
- GitHub is for code collaboration artifacts (branches/PR/CI) and is operated via **`gh`**.
- The user is a **solo developer** but expects a **team-like** process (PM + review discipline). Hence you must always assign the user to project, issues, PR... (anthonyamar)

## Process

### 1) Capture scope & context (input phase)

The user may provide:

- A freeform description of what they want
- A structured spec
- Or a request to “pull” context from Linear (Issue and/or Project)

If the user references **a Linear Issue and/or Project**:

- Fetch it from Linear via MCP.
- If it is a **Project**, also fetch and include **the associated Issues** as context.
- Summarize the essential constraints, goals, and unknowns in a few bullets (no design yet).

If the user provides the description directly:

- Normalize it into: problem, target users/actors, success criteria, non-goals, constraints, open questions.

### 2) Plan mode + “grill me” until shared understanding

Stay in **Plan mode**.

- You MUST use the **`grill-me`** skill to interview the user relentlessly.
- Walk the decision tree branch-by-branch until you reach a shared language and the plan is internally consistent.
- If any question can be answered by exploring the repo, explore it instead of asking.
- For each question, provide your recommended answer.

The output of this step is a clear set of decisions and assumptions, ready to be turned into a PRD.

### 3) Plan mode: write the PRD “contract” and publish it as a Linear Project

Stay in **Plan mode**.

- Once the grilling is complete, you MUST use **`write-prd`** to produce the PRD “contract”.
- Iterate with the user until the PRD is accepted (tight wording, explicit scope, explicit decisions).
- When accepted, publish the PRD in Linear as a **Project** via MCP.
- If you can confidently apply existing labels, do so; otherwise apply **no labels** (the user will do it manually).

### 4) Plan mode: break the PRD into executable issues (vertical slices)

Stay in **Plan mode**.

- Use **`to-issues`** to break the accepted PRD into independently-grabbable, tracer-bullet **vertical slices**.
- Ensure each slice is end-to-end (schema/API/UI/tests) and verifiable on its own.
- Create the resulting issues in Linear via MCP and associate them to the Project.

### 5) Return only the Linear Project reference

When the breakdown is finished:

- Output **only** the **Linear Project ID or link** (no extra commentary).
- The user will open a new agent to execute the plan from that Project.
