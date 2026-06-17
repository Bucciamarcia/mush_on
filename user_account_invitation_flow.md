# User Account and Invitation Flow Review

Findings are ordered by criticality.

## Critical

### Users can grant themselves account access and roles - *** FIXED

Firestore rules allow a signed-in user to fully write their own `users/{uid}` document. Since account membership and `userLevel` are stored in that document, a user can assign themselves to any account and set themselves as `musher`.

**Change the logic:** users should not be allowed to write privileged fields such as `account` or `userLevel` directly. Account assignment and role changes should happen only through trusted server-side Cloud Functions after validating permissions.

### Invitation Cloud Functions are not authenticated or authorized - *** FIXED

`invite_user` accepts caller-provided sender email, receiver email, account, and payload without checking `req.auth`, whether the sender belongs to the account, or whether the sender has permission to invite users. `get_user_invitation_db` also returns invitation data by email without authentication or validation.

**Change the logic:** require authentication for invite-related functions. The server should derive the sender UID from `req.auth`, load the sender's user document, verify account membership and sufficient role, then create the invitation payload server-side.

## High

### Invite acceptance does not verify the signed-in email - *** FIXED

The invite page validates the URL email/security code, but after Google sign-in it accepts whichever Google account was used. A forwarded invite link could be accepted by a different email address.

**Change the logic:** after sign-in, compare the authenticated user's normalized email with the invited email. Reject acceptance if they do not match, unless a deliberate admin-approved transfer flow exists.

### Invitations are reusable and never consumed - *** FIXED

The invitation model has an `accepted` field, but accepting an invite only writes `users/{uid}`. The invitation is not marked accepted, deleted, linked to the accepted UID, or checked for previous use.

**Change the logic:** accept invitations through a Cloud Function transaction. It should verify the security code, verify the invitation is not already accepted, create or update the user membership, and mark the invite accepted with `acceptedAt` and `acceptedUid` or delete it.

### Team settings route is not role-protected - *** FIXED

The settings hub hides Team & Access from non-mushers, but `/settings/team` uses `TemplateScreen` with the default minimum rank of `guest`. Direct navigation can expose the invitation UI.

**Change the logic:** set `minUserRank: UserLevel.musher` on `TeamSettingsPage`'s `TemplateScreen`, and still keep server-side authorization in `invite_user` as the real protection.

## Medium

### Account creation has weak validation and race conditions - *** FIXED

Account names are checked for empty before trimming, then normalized only by replacing spaces with hyphens. Special characters and path separators are not rejected. Uniqueness is checked client-side by listing accounts before writing, so two users can race to create the same account.

**Change the logic:** create accounts through a Cloud Function transaction. Normalize and validate account IDs server-side, reject invalid names, and atomically create the account only if it does not already exist.

### Invitation URLs do not encode query parameters

The invitation email builds the action URL by directly interpolating email and security code into the query string. Emails containing `+` or other reserved characters can be parsed incorrectly.

**Change the logic:** URL-encode query parameters when building the invite link.

