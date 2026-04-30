# Improve Whiteboard Plan

## Overview

The whiteboard should behave like a lightweight staff-room coordination board, not like a chat app or a complex project-management tool. The daily dashboard already covers short-lived coordination reasonably well. The next useful improvements are focused on the permanent `/whiteboard` page and on giving staff a simple way to tell whether a note still needs attention.

The suggested direction is:

- Make `/whiteboard` feel like the canonical place for standing kennel information.
- Add a minimal note lifecycle so staff can mark items as handled without deleting context.
- Sort by recent activity so active coordination naturally stays visible.
- Avoid complex workflows, channels, permissions, assignments, or chat-style behavior for now.

## Suggested Changes

### 1. Improve The Permanent Whiteboard

The current permanent whiteboard is technically functional, but visually and structurally weaker than the daily dashboard. It should be upgraded to a simple board with clearer empty states, better spacing, and optional categories.

Recommended categories:

- General
- Dogs
- Equipment
- Tours
- Maintenance

These should be lightweight labels, not separate systems. A note can have one category, with `General` as the default.

Implementation summary:

- Extend `WhiteboardElement` with an optional `category` field.
- Default missing/old notes to `General`.
- Add a category selector in the note editor.
- Display category chips on note cards.
- Group or filter notes by category on `/whiteboard`.
- Add a useful empty state, for example: `No standing notes yet. Add procedures, reminders, or kennel info staff should keep visible.`

User-centric reasoning:

Staff using a physical whiteboard rely on spatial memory and quick scanning. A flat list of permanent notes becomes hard to scan once it grows. Categories give just enough structure without turning the feature into documentation software. This helps a musher, guide, handler, or manager quickly find "equipment" or "dog-specific" information while keeping the interface simple.

### 2. Add A Lightweight Lifecycle

Daily notes and permanent notes need a simple way to show whether something still matters. Today the only real lifecycle action is delete, but deletion is too destructive for coordination. Staff often need to say "handled" while still leaving the note visible for context.

Recommended lifecycle:

- Open
- Done

Furthermore, adding a pinning feature will prioritize the pinned notes over the others, both in visual hierarchy (bold) and ordering on top.

- Pinned

Implementation summary:

- Extend `WhiteboardElement` with `isDone`, defaulting to `false`.
- Add a checkmark action on each note card.
- When checked, visually soften the note and move it below open notes.
- Keep done notes visible on the daily dashboard for the rest of the day.
- On `/whiteboard`, allow done notes to remain visible but de-emphasized, or hide them behind a simple `Show done` toggle.
- Preserve comments when marking done.

User-centric reasoning:

For kennel staff, the important question is not only "what was said?" but "does someone still need to act on this?" A simple done state answers that without needing assignments, due dates, status boards, or complex task conversion. It replaces the physical act of crossing something out on a whiteboard.

### 3. Sort By Recent Activity

Notes should not be ordered only by creation date. If someone comments on an older note, that note has become active again and should move up.

Implementation summary:

- Add `lastUpdated` or `lastActivityAt` to `WhiteboardElement`.
- Set it when creating a note.
- Update it when editing the note, adding a comment, or marking done/open.
- Sort open notes by `lastActivityAt` descending.
- Sort done notes below open notes, also by recent activity.

User-centric reasoning:

WhatsApp works partly because recent activity rises to the top. The whiteboard should borrow that behavior without becoming a chat app. Staff should not have to hunt through old notes to find what someone just replied to.

## Recommended Implementation Order

1. Add `isDone` and `lastActivityAt`.
2. Update create/edit/comment flows to maintain `lastActivityAt`.
3. Sort notes by open status first, then recent activity.
4. Add a checkmark action to mark notes done/open.
5. Improve `/whiteboard` layout and empty state.
6. Add `category` only after the lifecycle and sorting feel good in real use.
7. Add a `pinned` boolean that will prioritize important notes.
8. (extra) Add a date to each comment, as it now only shows the time.

This order keeps the highest-value coordination fixes first and avoids overbuilding category structure before there is enough real content to justify it.

## Not Recommended Yet

- Assigning notes to specific staff.
- Multi-status workflows.
- Rich text or attachments.
- Separate channels.
- Full chat threads.
- Complex notification preferences tied to categories.

These could become useful later, but they add maintenance and training cost. For this product, the better 80/20 move is a fast shared board with correct authors, recent activity, quick comments, and a simple handled/not-handled state.
