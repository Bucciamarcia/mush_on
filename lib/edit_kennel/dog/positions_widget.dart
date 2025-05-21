import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/text_title.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';

class PositionsWidget extends StatelessWidget {
  final DogPositions positions;
  final Function(DogPositions) onPositionsChanged;
  const PositionsWidget(
      {super.key, required this.positions, required this.onPositionsChanged});

  @override
  Widget build(BuildContext context) {
    final positionCards = positions
        .toJson()
        .entries
        .map((e) => PositionCard(e.key, e.value as bool))
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            TextTitle("Positions"),
            IconButton.outlined(
                onPressed: () {
                  showAdaptiveDialog(
                      context: context,
                      builder: (BuildContext context) => EditPositionsWidget(
                            positions: positions,
                            onPositionsChanged: (newPositions) =>
                                onPositionsChanged(newPositions),
                          ));
                },
                icon: Icon(Icons.edit)),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: positionCards,
        ),
      ],
    );
  }
}

class EditPositionsWidget extends StatelessWidget {
  final DogPositions positions;
  final Function(DogPositions) onPositionsChanged;
  const EditPositionsWidget(
      {super.key, required this.positions, required this.onPositionsChanged});

  @override
  Widget build(BuildContext context) {
    DogPositions newPositions = positions;
    return AlertDialog.adaptive(
      title: Text("Edit positions"),
      content: PositionToggleWidget(
        positions: positions,
        onPositionToggled: (DogPositions toggledPositions) {
          newPositions = toggledPositions;
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
          onPressed: () {
            onPositionsChanged(newPositions);
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        )
      ],
    );
  }
}

class PositionToggleWidget extends StatefulWidget {
  final DogPositions positions;
  final Function(DogPositions) onPositionToggled;
  const PositionToggleWidget(
      {super.key, required this.positions, required this.onPositionToggled});

  @override
  State<PositionToggleWidget> createState() => _PositionToggleWidgetState();
}

class _PositionToggleWidgetState extends State<PositionToggleWidget> {
  static final BasicLogger logger = BasicLogger();
  bool isLead = false;
  bool isSwing = false;
  bool isTeam = false;
  bool isWheel = false;
  @override
  void initState() {
    super.initState();
    isLead = widget.positions.lead;
    isSwing = widget.positions.swing;
    isTeam = widget.positions.team;
    isWheel = widget.positions.wheel;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lead"),
              Switch(
                key: Key("Lead toggle"),
                value: isLead,
                onChanged: (newValue) {
                  setState(() {
                    isLead = newValue;
                  });
                  logger.debug("New position for lead: $isLead");
                  widget.onPositionToggled(DogPositions(
                      lead: isLead,
                      swing: isSwing,
                      team: isTeam,
                      wheel: isWheel));
                },
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Swing"),
              Switch(
                key: Key("Swing toggle"),
                value: isSwing,
                onChanged: (newValue) {
                  setState(() {
                    isSwing = newValue;
                  });
                  logger.debug("New position for swing: $isSwing");
                  widget.onPositionToggled(DogPositions(
                      lead: isLead,
                      swing: isSwing,
                      team: isTeam,
                      wheel: isWheel));
                },
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Team"),
              Switch(
                key: Key("Team toggle"),
                value: isTeam,
                onChanged: (newValue) {
                  setState(() {
                    isTeam = newValue;
                  });
                  logger.debug("New position for team: $isTeam");
                  widget.onPositionToggled(DogPositions(
                      lead: isLead,
                      swing: isSwing,
                      team: isTeam,
                      wheel: isWheel));
                },
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Wheel"),
              Switch(
                key: Key("Wheel toggle"),
                value: isWheel,
                onChanged: (newValue) {
                  setState(() {
                    isWheel = newValue;
                  });
                  logger.debug("New position for wheel: $isWheel");
                  widget.onPositionToggled(DogPositions(
                      lead: isLead,
                      swing: isSwing,
                      team: isTeam,
                      wheel: isWheel));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class PositionCard extends StatelessWidget {
  final String position;
  final bool canRun;
  const PositionCard(this.position, this.canRun, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        color: (canRun) ? Colors.lightGreen[300] : Colors.red[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                position,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              (canRun) ? Icon(Icons.check) : Icon(Icons.cancel_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
