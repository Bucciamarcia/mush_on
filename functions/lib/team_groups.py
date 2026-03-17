from __future__ import annotations

from typing import Any

from firebase_admin import firestore


def rebuild_teamgroup_snapshot(teamgroup_path: str) -> dict[str, Any]:
    """
    Rebuilds `teamsSnapshot` for a teamgroup document from its `teams`
    and `dogPairs` subcollections, writes it to Firestore, and returns it.
    """
    _validate_teamgroup_path(teamgroup_path)

    db = firestore.client()
    teamgroup_ref = db.document(teamgroup_path)
    teamgroup_snapshot = teamgroup_ref.get()
    if not teamgroup_snapshot.exists:
        raise ValueError(f"Teamgroup document does not exist: {teamgroup_path}")

    teams_snapshot: dict[str, Any] = {}
    teams_docs = (
        teamgroup_ref.collection("teams")
        .order_by("rank")
        .stream()
    )

    team_count = 0
    dog_pair_count = 0

    for team_rank, team_doc in enumerate(teams_docs):
        team_data = dict(team_doc.to_dict() or {})
        team_data.pop("id", None)
        team_data["rank"] = _coerce_rank(team_data.get("rank"), team_rank)

        dog_pairs_snapshot: dict[str, Any] = {}
        dog_pair_docs = (
            team_doc.reference.collection("dogPairs")
            .order_by("rank")
            .stream()
        )

        for dog_pair_rank, dog_pair_doc in enumerate(dog_pair_docs):
            dog_pair_data = dict(dog_pair_doc.to_dict() or {})
            dog_pair_data.pop("id", None)
            dog_pair_data["rank"] = _coerce_rank(
                dog_pair_data.get("rank"), dog_pair_rank
            )
            dog_pairs_snapshot[dog_pair_doc.id] = dog_pair_data
            dog_pair_count += 1

        team_data["dogPairs"] = dog_pairs_snapshot
        teams_snapshot[team_doc.id] = team_data
        team_count += 1

    teamgroup_ref.set({"teamsSnapshot": teams_snapshot}, merge=True)

    return {
        "teamgroupPath": teamgroup_path,
        "teamsSnapshot": teams_snapshot,
        "teamCount": team_count,
        "dogPairCount": dog_pair_count,
    }


def _validate_teamgroup_path(teamgroup_path: str) -> None:
    parts = teamgroup_path.strip("/").split("/")
    if len(parts) != 6:
        raise ValueError(
            "teamgroupPath must point to a teamgroup document, for example "
            "'accounts/<account>/data/teams/history/<teamgroupId>'"
        )
    if (
        parts[0] != "accounts"
        or parts[2] != "data"
        or parts[3] != "teams"
        or parts[4] != "history"
    ):
        raise ValueError(
            "teamgroupPath must match "
            "'accounts/<account>/data/teams/history/<teamgroupId>'"
        )
    if parts[5] == "":
        raise ValueError("teamgroupPath is missing the teamgroup id")


def _coerce_rank(value: Any, fallback: int) -> int:
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    return fallback
